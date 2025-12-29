import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import '../screen/home/pick_location.dart';

class MapShareHandler {
  static const MethodChannel _channel = MethodChannel('map_share');

  /// Call this after runApp
  static Future<void> init() async {
    log("🔥 MapShareHandler.init called");

    /// ✅ 1️⃣ LISTEN for PUSH from Android
    _channel.setMethodCallHandler((call) async {
      if (call.method == "newSharedLink") {
        final String url = call.arguments;
        log("📥 PUSH URL from Android: $url");
        await _processUrl(url);
      }
    });

    /// ✅ 2️⃣ PULL cached intent (VERY IMPORTANT)
    try {
      final String? cachedUrl =
      await _channel.invokeMethod<String>('getInitialSharedText');

      if (cachedUrl != null && cachedUrl.isNotEmpty) {
        log("📦 CACHED URL received: $cachedUrl");
        await _processUrl(cachedUrl);
      }
    } catch (e) {
      log("❌ Error fetching cached shared text: $e");
    }
  }

  static Future<void> _processUrl(String url) async {
    log("🧩 Processing URL: $url");

    String finalUrl = url;

    // 🔹 STEP 1: Expand short Google Maps link
    if (url.contains("maps.app.goo.gl")) {
      try {
        final client = HttpClient();
        final request = await client.getUrl(Uri.parse(url));
        request.followRedirects = true;
        final response = await request.close();

        if (response.redirects.isNotEmpty) {
          finalUrl = response.redirects.last.location.toString();
        } else {
          finalUrl = url; // fallback original URL
        }

        client.close();
        log("🔗 Expanded URL: $finalUrl");
      } catch (e) {
        log("❌ Failed to expand short URL: $e");
        finalUrl = url; // fallback original URL
      }
    }

    double? lat;
    double? lng;
    String? addressText;

    // 🔹 STEP 2: Try extract lat/lng from @lat,lng
    final match = RegExp(r'@(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)')
        .firstMatch(finalUrl);

    if (match != null) {
      lat = double.tryParse(match.group(1)!);
      lng = double.tryParse(match.group(2)!);
    }

    // 🔹 STEP 3: If lat/lng not found, try extracting address from /place/
    if ((lat == null || lng == null)) {
      final placeMatch = RegExp(r'/place/([^/]+)').firstMatch(finalUrl);
      if (placeMatch != null) {
        addressText =
            Uri.decodeComponent(placeMatch.group(1)!.replaceAll('+', ' '));
        log("📍 Address extracted: $addressText");
      }
    }

    // 🔹 STEP 4: If lat/lng still null, geocode from address
    if ((lat == null || lng == null) && addressText != null) {
      try {
        final locations = await locationFromAddress(addressText);
        if (locations.isNotEmpty) {
          lat = locations.first.latitude;
          lng = locations.first.longitude;
          log("📍 Found from address → Lat: $lat, Lng: $lng");
        }
      } catch (e) {
        log("❌ Address geocoding failed: $e");
      }
    }

    // ❌ Final safety check
    if (lat == null || lng == null) {
      log("❌ Unable to find location");
      return;
    }

    // 🔹 STEP 5: Reverse geocode for clean address
    final placemarks = await placemarkFromCoordinates(lat, lng);
    final place = placemarks.first;

    final address =
        "${place.street}, ${place.locality}, ${place.administrativeArea}";

    log("🏠 Address: $address");

    // 🔹 STEP 6: Navigate to map screen
    Get.to(() => LocationPickerTypeAheadPage(
      isPick: false,
      pickLat: lat,
      pickLng: lng,
      isShare: true,
      pickAddress: address,
      title: "Drop Location",
    ));
  }
}
