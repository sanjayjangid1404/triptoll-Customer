import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/screen/home/pick_location.dart';
import 'package:triptoll/util/appColors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:triptoll/util/custom_snackbar.dart';

import '../../util/appContants.dart';
import '../../util/app_fonts.dart';
import 'category_list.dart';
import 'custom_icon.dart';

class BookingInfo extends StatefulWidget {
  String pickAddress;
  String dropAddress;
  double pickLat;
  double pickLng;
  double dropLng;
  double dropLat;
  String? scheduleTime;
  String? scheduleDate;
   BookingInfo({super.key,this.scheduleDate,this.scheduleTime,required this.dropLng,required this.dropLat,required this.pickAddress,required this.pickLat,required this.pickLng,required this.dropAddress});

  @override
  State<BookingInfo> createState() => _BookingInfoState();
}

class _BookingInfoState extends State<BookingInfo> {

  late GoogleMapController _mapController;
  bool _isRouteDrawn = false;
  bool isActive = false;
  final String _googleMapsApiKey = 'AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk';
  Future<Map<String, dynamic>> calculateDistance(
      double lat1, double lon1, double lat2, double lon2) async
  {
    const apiKey = "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk";

    final url =
    Uri.parse("https://routes.googleapis.com/directions/v2:computeRoutes");

    final headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask": "routes.distanceMeters,routes.duration"
    };

    final body = jsonEncode({
      "origin": {
        "location": {
          "latLng": {"latitude": lat1, "longitude": lon1}
        }
      },
      "destination": {
        "location": {
          "latLng": {"latitude": lat2, "longitude": lon2}
        }
      },
      "travelMode": "DRIVE"
    });

    print("➡️ Sending request to $url");
    print("➡️ Headers: $headers");
    print("➡️ Body: $body");

    final response = await http.post(url, headers: headers, body: body);

    print("⬅️ Status Code: ${response.statusCode}");
    print("⬅️ Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["routes"] != null && data["routes"].isNotEmpty) {
        final route = data["routes"][0];
        final distance = route["distanceMeters"];
        final durationRaw = route["duration"]; // e.g. "5234s"

        // convert seconds → readable format
        int seconds = int.tryParse(durationRaw.replaceAll("s", "")) ?? 0;
        int hours = seconds ~/ 3600;
        int minutes = (seconds % 3600) ~/ 60;
        String durationText =
        hours > 0 ? "${hours}h ${minutes}m" : "${minutes}m";

        return {
          "chosen": {
            "distanceValue": distance,
            "durationText": durationText,
          }
        };
      } else {
        throw Exception("No route found in response: $data");
      }
    } else {
      throw Exception("Failed: ${response.statusCode} - ${response.body}");
    }
  }

  Future<Map<String, String>> getTotalDistanceAndTimeFromPickup(List<Map<String, dynamic>> stopLocations) async {
    const apiKey = "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk";
    final url = Uri.parse("https://routes.googleapis.com/directions/v2:computeRoutes");

    double totalDistanceKm = 0;
    int totalSeconds = 0;

    // 🟢 Ensure there’s at least one pickup and one drop
    if (stopLocations.length < 2) {
      throw Exception("Need at least one pickup and one drop location");
    }

    // 🔹 Loop from pickup (index 0) to all drops (1...n)
    for (int i = 0; i < stopLocations.length - 1; i++) {
      final current = stopLocations[i];
      final next = stopLocations[i + 1];

      // Skip if next is not a drop
      if (next['type'] != 'drop') continue;

      final headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": apiKey,
        "X-Goog-FieldMask": "routes.distanceMeters,routes.duration"
      };

      final body = jsonEncode({
        "origin": {
          "location": {
            "latLng": {"latitude": current['lat'], "longitude": current['lng']}
          }
        },
        "destination": {
          "location": {
            "latLng": {"latitude": next['lat'], "longitude": next['lng']}
          }
        },
        "travelMode": "DRIVE"
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final route = data["routes"]?[0];
          if (route == null) continue;

          final distanceMeters = route["distanceMeters"];
          final durationRaw = route["duration"]; // e.g. "5234s"
          final seconds = int.tryParse(durationRaw.replaceAll("s", "")) ?? 0;

          totalDistanceKm += distanceMeters / 1000.0;
          totalSeconds += seconds;

          print("✅ Pickup → Drop ${i + 1}: ${(distanceMeters / 1000).toStringAsFixed(2)} KM, ${seconds ~/ 60}m");
        } else {
          print("❌ API error ${response.statusCode}: ${response.body}");
        }
      } catch (e) {
        print("⚠️ Error at ${i} → ${i + 1}: $e");
      }
    }

    // ⏱ Convert seconds to readable time
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    String totalTime = hours > 0 ? "${hours}h ${minutes}m" : "${minutes}m";

    return {
      "total_distance": "${totalDistanceKm.toStringAsFixed(2)} KM",
      "total_time": totalTime,
    };
  }

   Map<int, TextEditingController> houseNoCt = {};
   Map<int, TextEditingController> senderName = {};
   Map<int, TextEditingController> sendMobile = {};


  // Jaipur locations as example
  final LatLng _pickupLocation = const LatLng(26.9124, 75.7873); // Jaipur center
  final LatLng _dropLocation = const LatLng(26.8371, 75.8338);   // Malviya Nagar

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<Map<String, dynamic>> stopLocations = [];
  String getUserName = '';
  String getUserPhone = '';
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      await prepareStopIcons();

      stopLocations.add({
        "type": "pickup",
        'lat': widget.pickLat,
        'lng': widget.pickLng,
        'address': widget.pickAddress,
        'sequence': stopLocations.length+1,
        'name':  'Him',
        'contact_number': Get.find<AuthController>().getUserPhone(),
        'distance_to_next': '0.00',
        'expected_time_to_next': '0.00',
        'loading_charge': '0.00',
        'loading_time': '0.0',
        'loading_duration': '0.0',
      });
      stopLocations.add({
        "type": "drop",
        'lat': widget.dropLat,
        'lng': widget.dropLng,
        'address': widget.dropAddress,
        'sequence': stopLocations.length+1,
        'name':  getUserName.toString(),
        'contact_number': getUserPhone.toString(),
        'unloading_charge': '0.00',
        'unloading_time': '0.0',
        'unloading_duration': '0.0',
      });

      _addMarkers();
      setState(() {

      });


      Get.find<AuthController>().getAllVehicleData();
      _getRouteBetweenPoints(pickLat: widget.pickLat,pickLng: widget.pickLng,stopLocations: stopLocations);
      calculateAllStopDistances().then((list) {
        print("📦 Final list for API: $list");
      });


    });
  }


  bool validateFields() {
    // Skip the 0th index (pickup)
    bool areNamesValid = !senderName.entries
        .where((entry) => entry.key != 0) // ignore index 0
        .any((entry) => entry.value.text.trim().isEmpty);

    bool areMobilesValid = !sendMobile.entries
        .where((entry) => entry.key != 0) // ignore index 0
        .any((entry) {
      final text = entry.value.text.trim();
      return text.isEmpty ||
          text.length != 10 ||
          !RegExp(r'^[0-9]+$').hasMatch(text);
    });

    return areNamesValid && areMobilesValid;
  }

  String? validateFieldsWithMessages() {
    // Skip the 0th index (pickup)
    for (var entry in senderName.entries.where((e) => e.key != 0)) {
      if (entry.value.text.trim().isEmpty) {
        return 'All sender names are required for drop locations';
      }
    }

    for (var entry in sendMobile.entries.where((e) => e.key != 0)) {
      final text = entry.value.text.trim();
      if (text.isEmpty) {
        return 'All mobile numbers are required for drop locations';
      }
      if (text.length != 10) {
        return 'Mobile numbers must be 10 digits';
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
        return 'Mobile numbers can only contain digits';
      }
    }

    return null; // No errors
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;

      // stopLocations को reorder करो
      final movedStop = stopLocations.removeAt(oldIndex);
      stopLocations.insert(newIndex, movedStop);

      // Controllers भी reorder करें
      houseNoCt = _reorderControllers(houseNoCt, oldIndex, newIndex);
      senderName = _reorderControllers(senderName, oldIndex, newIndex);
      sendMobile = _reorderControllers(sendMobile, oldIndex, newIndex);
    });
  }

  Map<int, TextEditingController> _reorderControllers(
      Map<int, TextEditingController> map, int oldIndex, int newIndex)
  {
    final controllersList = List<TextEditingController>.from(map.values);
    final moved = controllersList.removeAt(oldIndex);
    controllersList.insert(newIndex, moved);

    // Keys reassign करें
    final reordered = <int, TextEditingController>{};
    for (int i = 0; i < controllersList.length; i++) {
      reordered[i] = controllersList[i];
    }
    return reordered;
  }


  Map<String, BitmapDescriptor> stopIcons = {};

  Future<void> prepareStopIcons() async {
    for (int i = 0; i < 26; i++) { // A-Z
      String label = String.fromCharCode(65 + i);
      stopIcons[label] = await createCustomMarker(label, color: Colors.orange);
    }
  }
  // void _addMarkers() {
  //   _markers.clear();
  //
  //   // Pickup marker
  //   _markers.add(Marker(
  //     markerId: MarkerId('pickup'),
  //     position: LatLng(widget.pickLat, widget.pickLng),
  //     infoWindow: InfoWindow(title: "Pickup Location"),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //   ));
  //
  //   // Drop marker
  //   // _markers.add(Marker(
  //   //   markerId: MarkerId('drop'),
  //   //   position: LatLng(widget.dropLat, widget.dropLng),
  //   //   infoWindow: InfoWindow(title: "Drop Location"),
  //   //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   // ));
  //
  //   // Stop markers
  //   for (int i = 0; i < stopLocations.length; i++) {
  //     final stop = stopLocations[i];
  //     _markers.add(Marker(
  //       markerId: MarkerId('stop_$i'),
  //       position: LatLng(stop['lat'], stop['lng']),
  //       infoWindow: InfoWindow(title: 'Stop ${i + 1}'),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //     ));
  //   }
  //
  //   setState(() {});
  // }
  void _addMarkers() {
    _markers.clear();

    for (int i = 0; i < stopLocations.length; i++) {
      final stop = stopLocations[i];

      if (stop['type'] == 'pickup') {
        // Pickup marker - normal red
        _markers.add(Marker(
          markerId: MarkerId('pickup'),
          position: LatLng(stop['lat'], stop['lng']),
          infoWindow: InfoWindow(title: "Pickup"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
      } else {
        // Stops/Drop - labeled A, B, C, small circle
        final label = String.fromCharCode(65 + i - 1); // subtract 1 so A starts after pickup
        final icon = stopIcons[label]!; // pre-generated small icons
        _markers.add(Marker(
          markerId: MarkerId('stop_$i'),
          position: LatLng(stop['lat'], stop['lng']),
          infoWindow: InfoWindow(title: 'Stop $label'),
          icon: icon,
        ));
      }
    }

    setState(() {});
  }


  // Future<void> _getRouteBetweenPoints({
  //   required double pickLat,
  //   required double pickLng,
  //   required List<Map<String, dynamic>> stopLocations, // Required
  // }) async
  // {
  //   if (stopLocations.isEmpty) {
  //     print("No stops provided");
  //     return;
  //   }
  //
  //   // Drop location = last stop
  //   final lastStop = stopLocations.last;
  //   final dropLat = lastStop['lat'];
  //   final dropLng = lastStop['lng'];
  //
  //   // Waypoints = all stops except last (since last is drop)
  //   String waypoints = '';
  //   if (stopLocations.length > 1) {
  //     final midStops = stopLocations.sublist(0, stopLocations.length - 1);
  //     waypoints = '&waypoints=' +
  //         midStops.map((s) => '${s['lat']},${s['lng']}').join('|');
  //   }
  //
  //   final url = Uri.parse(
  //     'https://maps.googleapis.com/maps/api/directions/json?'
  //         'origin=$pickLat,$pickLng'
  //         '&destination=$dropLat,$dropLng'
  //         '$waypoints'
  //         '&key=$_googleMapsApiKey',
  //   );
  //
  //   try {
  //     final response = await http.get(url);
  //     final data = json.decode(response.body);
  //
  //     if (data['status'] == 'OK') {
  //       final points = data['routes'][0]['overview_polyline']['points'];
  //       final route = _decodePoly(points);
  //
  //       setState(() {
  //         _polylines = {
  //           Polyline(
  //             polylineId: const PolylineId('route'),
  //             points: route,
  //             color: Colors.blue,
  //             width: 5,
  //             geodesic: true,
  //           ),
  //         };
  //
  //         _markers.clear(); // Purane markers hata do
  //
  //         // Pickup location marker
  //         _markers.add(
  //           Marker(
  //             markerId: const MarkerId('pickup'),
  //             position: LatLng(pickLat, pickLng),
  //             infoWindow: const InfoWindow(title: 'Pickup'),
  //             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //           ),
  //         );
  //
  //         // All stoppages markers
  //         for (int i = 0; i < stopLocations.length; i++) {
  //           final stop = stopLocations[i];
  //           _markers.add(
  //             Marker(
  //               markerId: MarkerId('stop_$i'),
  //               position: LatLng(stop['lat'], stop['lng']),
  //               infoWindow: InfoWindow(title: 'Stop ${i + 1}'),
  //               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  //             ),
  //           );
  //         }
  //
  //         _isRouteDrawn = true;
  //       });
  //
  //     } else {
  //       print('Directions request failed: ${data['status']}');
  //     }
  //   } catch (e) {
  //     print('Error getting route: $e');
  //   }
  // }

  Future<void> _getRouteBetweenPoints({
    required double pickLat,
    required double pickLng,
    required List<Map<String, dynamic>> stopLocations,
  }) async {
    if (stopLocations.isEmpty) {
      print("No stops provided");
      return;
    }

    final lastStop = stopLocations.last;
    final dropLat = lastStop['lat'];
    final dropLng = lastStop['lng'];

    String waypoints = '';
    if (stopLocations.length > 1) {
      final midStops = stopLocations.sublist(0, stopLocations.length - 1);
      waypoints = '&waypoints=' +
          midStops.map((s) => '${s['lat']},${s['lng']}').join('|');
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=$pickLat,$pickLng'
          '&destination=$dropLat,$dropLng'
          '$waypoints'
          '&key=$_googleMapsApiKey',
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final points = data['routes'][0]['overview_polyline']['points'];
        final route = _decodePoly(points);

        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: route,
              color: Colors.blue,
              width: 5,
              geodesic: true,
            ),
          };

          _isRouteDrawn = true;
        });

      } else {
        print('Directions request failed: ${data['status']}');
      }
    } catch (e) {
      print('Error getting route: $e');
    }
  }



  Future<List<Map<String, dynamic>>> calculateAllStopDistances() async {
    List<Map<String, dynamic>> allDistances = [];

    if (stopLocations.isEmpty) return allDistances;

    // Start from pickup (always index 0)
    LatLng currentPoint = LatLng(
      stopLocations[0]['lat'],
      stopLocations[0]['lng'],
    );

    for (int i = 1; i < stopLocations.length; i++) {
      final nextStop = stopLocations[i];

      try {
        final result = await calculateDistance(
          currentPoint.latitude,
          currentPoint.longitude,
          nextStop['lat'],
          nextStop['lng'],
        );

        final distanceData = result['chosen'];
        final distanceValue = distanceData['distanceValue'] ?? 0; // meters
        final durationText = distanceData['durationText'] ?? "";
        final distanceKm = (distanceValue / 1000).toDouble();

        // 🔹 Update next stop details
        stopLocations[i - 1]['distance_to_next'] = distanceKm.toStringAsFixed(2);
        stopLocations[i - 1]['expected_time_to_next'] = durationText;

        // 🔹 Also store readable data for API payload
        allDistances.add({
          "sequence": i,
          "from_lat": currentPoint.latitude,
          "from_lng": currentPoint.longitude,
          "to_lat": nextStop['lat'],
          "to_lng": nextStop['lng'],
          "distance_km": distanceKm,
          "duration_text": durationText,
        });

        print(
            "✅ Leg $i | ${distanceKm.toStringAsFixed(2)} km | $durationText (From stop ${i - 1} → $i)");

        // Move to next leg
        currentPoint = LatLng(nextStop['lat'], nextStop['lng']);
      } catch (e) {
        print("❌ Error calculating leg $i: $e");
      }
    }

    // 🔹 Last stop (final drop) ke liye distance_to_next = 0
    stopLocations.last['distance_to_next'] = '0.00';
    stopLocations.last['expected_time_to_next'] = '0m';

    setState(() {});
    return allDistances;
  }




  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  List<LatLng> _decodePoly(String encoded) {
    final List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _updateStop(int index, String key, dynamic value) {
    setState(() {
      stopLocations[index][key] = value; // update specific field
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: null,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.5,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.pickLat, widget.pickLng),
                zoom: 14.0, // Reasonable initial zoom level
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) {
                _mapController = controller;
                // Delay the zoom to bounds to ensure map is fully loaded
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (!_isRouteDrawn) {
                    _getRouteBetweenPoints(pickLat: widget.pickLat,pickLng: widget.pickLng,stopLocations: stopLocations);
                    calculateAllStopDistances().then((list) {
                      print("📦 Final list for API: $list");
                    });
                  }
                });
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
        ],
      ),
      bottomSheet: Container(width: double.infinity,
        height: MediaQuery.of(context).size.height*0.55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight: Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 3,
              spreadRadius: 1,
              // offset: Offset(-2, -2), // 👉 ye shadow bottom-right mein dikh raha hai
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 3,
              spreadRadius: 1,
              // offset: Offset(-2, -2), // 👉 ye shadow top-left mein light effect de raha hai
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      // TODO: Navigate to forget password screen
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LocationPickerTypeAheadPage(isPick: true,title: "Pick Location",)),
                      );

                      if (result != null) {


                        print("Selected Lat: ${result['lat']}");
                        print("Selected Lng: ${result['lng']}");
                        print("Selected Address: ${result['address']}");

                        setState(() {
                          widget.pickLng = result['lng'];
                          widget.pickLat = result['lat'];
                          widget.pickAddress = result['address'];

                          _addMarkers();
                          _getRouteBetweenPoints(pickLat: result['lat'],pickLng: result['lng'],stopLocations: stopLocations);
                          calculateAllStopDistances().then((list) {
                            print("📦 Final list for API: $list");
                          });
                        });
                      }

                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined,color: Colors.green,size: 30,),
                        SizedBox(width: 5,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text(
                                  'Pickup Location'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.expand_more,color: AppColors.primaryGradient,)
                              ],
                            ),
                            Text(widget.pickAddress,maxLines: 2,),
                          ],
                        ))

                      ],
                    ),
                  ),
                ),


                SizedBox(height: 10,),

             //   const SizedBox(height: 24),

                // Drop Location

                const SizedBox(height: 8),
               /* Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      // TODO: Navigate to forget password screen
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LocationPickerTypeAheadPage(isPick: true,)),
                      );

                      if (result != null) {


                        print("Selected Lat: ${result['lat']}");
                        print("Selected Lng: ${result['lng']}");
                        print("Selected Address: ${result['address']}");

                        setState(() {
                          widget.dropLng = result['lng'];
                          widget.dropLat = result['lat'];
                          widget.dropAddress = result['address'];

                          _addMarkers();
                          _getRouteBetweenPoints(dropLat: result['lat'],dropLng: result['lng'],pickLat: widget.pickLat,pickLng: widget.pickLng);
                        });
                      }

                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined,color: Colors.red,size: 30,),
                        SizedBox(width: 5,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Drop Location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.expand_more,color: AppColors.primaryGradient,)
                              ],
                            ),
                            Text(widget.dropAddress,maxLines: 2,),
                          ],
                        ))

                      ],
                    ),
                  ),
                ),*/



                ListView.builder(
                  shrinkWrap: true,
                  itemCount: stopLocations.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final stop = stopLocations[index];
                    final controller = houseNoCt[index] ?? TextEditingController(text: stop['house'] ?? '');
                    final senderController =
                        senderName[index] ?? TextEditingController(text: (stop['name'] ?? ''));

                    final senderMobileController =
                        sendMobile[index] ?? TextEditingController(text: (stop['mobile'] ?? ''));
                    if (!houseNoCt.containsKey(index)) {
                      houseNoCt[index] = controller;
                    }

                    // if (!senderName.containsKey(index)) {
                      senderName[index] = senderController;
                    // }

                    if (!sendMobile.containsKey(index)) {
                      sendMobile[index] = senderMobileController;
                    }
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(stopLocations[index]['type'] != 'pickup')
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: const EdgeInsets.only(left: 35, right: 8, bottom: 10),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: const Icon(Icons.close, color: Colors.red, size: 22),
                                  onTap: () {

                                    if (index < stopLocations.length) {
                                      setState(() {
                                        stopLocations.removeAt(index);
                                        houseNoCt.remove(index);
                                        senderName.remove(index);
                                        sendMobile.remove(index);

                                      });
                                      _addMarkers();
                                      _getRouteBetweenPoints(
                                        pickLat: widget.pickLat,
                                        pickLng: widget.pickLng,
                                        stopLocations: stopLocations,
                                      );
                                      calculateAllStopDistances().then((list) {
                                        print("📦 Final list for API: $list");
                                      });
                                    } else {
                                      print("Invalid index: $index");
                                    }
                                  },
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LocationPickerTypeAheadPage(
                                            isPick: true,
                                            title: "Drop Location",
                                          ),
                                        ),
                                      );

                                      if (result != null) {
                                        print("Selected Lat: ${result['lat']}");
                                        print("Selected Lng: ${result['lng']}");
                                        print("Selected Address: ${result['address']}");

                                        setState(() {
                                          stopLocations[index]['lat'] = result['lat'];
                                          stopLocations[index]['lng'] = result['lng'];
                                          stopLocations[index]['address'] = result['address'];
                                        });

                                        _addMarkers();
                                        _getRouteBetweenPoints(
                                          pickLat: widget.pickLat,
                                          pickLng: widget.pickLng,
                                          stopLocations: stopLocations,
                                        );
                                        calculateAllStopDistances().then((list) {
                                          print("📦 Final list for API: $list");
                                        });
                                      }
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.location_on_outlined,
                                            color: Colors.red, size: 30),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Drop Location'.tr,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(stop['address'] ?? "", maxLines: 2),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),

                            onExpansionChanged: (expanded) {},
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                controller: controller,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: AppFonts.poppinsRegular,
                                ),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  counter: const SizedBox(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  labelText: "House/Apartment/shop (Optional)".tr,
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: AppFonts.poppinsMedium,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              TextFormField(
                                controller: senderController,
                                style: TextStyle(fontSize: 14, fontFamily: AppFonts.poppinsRegular),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  counter: SizedBox(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  labelText: "Receiver's Name".tr,
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: AppFonts.poppinsMedium,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                                  onChanged: (value) {
                                  stopLocations[index]['name'] = senderController.text.trim();
                                  getUserName = senderController.text.trim();
                                  setState(() {

                                  });
                                  print('dfdfdfdfd:::::::::${getUserName.toString()}');
                                },
                              ),

                              const SizedBox(height: 10),

                              TextFormField(
                                controller: senderMobileController,
                                style: TextStyle(fontSize: 14, fontFamily: AppFonts.poppinsRegular),
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  counter: SizedBox(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  labelText: "Receiver's Mobile Number".tr,
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: AppFonts.poppinsMedium,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                                onChanged: (value) {
                                  stopLocations[index]['contact_number'] = senderMobileController.text.trim();
                                  getUserPhone = senderMobileController.text.trim();
                                  setState(() {

                                  });
                                  print('dfdfdfdfd:::::::::${getUserName.toString()}');
                                },
                              ),
                            ],
                          ),
                        ),
                        if (index == stopLocations.length - 1)
                          Get.find<AuthController>().isLoggedIn() ?
                          GetBuilder<AuthController>(builder: (authController) {
                            return CheckboxListTile(
                              value: isActive,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                              activeColor: AppColors.primaryGradient,
                              onChanged: (bool? value) {
                                setState(() {
                                  isActive = value!;
                                  for (int i = 0; i < stopLocations.length; i++) {
                                    if (value) {
                                      stopLocations[i]['name'] = authController.getUserName();
                                      stopLocations[i]['contact_number'] = authController.getUserPhone();
                                      senderName[i] = TextEditingController(text: authController.getUserName());
                                      sendMobile[i] = TextEditingController(text: authController.getUserPhone());
                                    } else {
                                      stopLocations[i]['name'] = '';
                                      stopLocations[i]['contact_number'] = '';
                                      senderName.remove(i);
                                      sendMobile.remove(i);
                                    }
                                  }
                                });
                              },
                              title: Text(
                                "Use My Details".tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: AppFonts.poppinsMedium,
                                ),
                              ),
                            );
                          }) : SizedBox.shrink(),
                      ],
                    );



                  },
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: () async {
                    // Open your location picker screen
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationPickerTypeAheadPage(
                          isPick: true,
                          title: "Drop Location",
                        ),
                      ),
                    );

                    if (result != null) {

                      int newIndex = stopLocations.length;
                      senderName[newIndex] = TextEditingController();
                      sendMobile[newIndex] = TextEditingController();
                      setState(() {
                        stopLocations.add({
                          "type": "drop",
                          'lat': result['lat'],
                          'lng': result['lng'],
                          'sequence': stopLocations.length+1,
                          'address': result['address'],
                          'name':  senderName[newIndex],
                          'contact_number': sendMobile[newIndex],
                          'unloading_charge': '0.00',
                          'unloading_time': '0.0',
                          'unloading_duration': '0.0',
                        });
                      });

                      // Optional: update markers or route on map
                      _addMarkers();
                      _getRouteBetweenPoints(
                        pickLat: widget.pickLat,
                        pickLng: widget.pickLng,
                        stopLocations: stopLocations,
                      );
                      calculateAllStopDistances().then((list) {
                        print("📦 Final list for API: $list");
                      });
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF0D47A1),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(1),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                       Text(
                        "Add New Stop".tr,
                        style: TextStyle(
                          color: Color(0xFF0D47A1), // blue text
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ).paddingOnly(left: 10,bottom: 20),
                ),
                // SizedBox(height: 10,),
                
                // CheckboxListTile(value: isActive,
                //     controlAffinity: ListTileControlAffinity.leading,
                //     contentPadding: EdgeInsets.zero,
                //     visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                //     activeColor: AppColors.primaryGradient,
                //     onChanged: (bool? value){
                //
                //        setState(() {
                //          isActive = value!;
                //        });
                //     },
                //   title: Text("Use My Mobile Number",style: TextStyle(fontSize: 13,color: Colors.black,fontFamily: AppFonts.poppinsMedium),),
                //
                //
                //     ),
                // SizedBox(height: 10,),

                InkWell(
                  onTap: () async {
                    if (validateFields()) {
                      try {
                        // Call the API and wait for result
                        final result = await calculateDistance(
                          widget.pickLat,
                          widget.pickLng,
                          widget.dropLat,
                          widget.dropLng,
                        );
                        final resultTotal = await getTotalDistanceAndTimeFromPickup(stopLocations);

                        print("Total Distance: ${resultTotal['total_distance']}");
                        print("Total Time: ${resultTotal['total_time']}");
                        String totalDistanceNew = resultTotal['total_distance'].toString();
                        String distanceString = resultTotal['total_distance'].toString();
                        distanceString = distanceString.replaceAll(RegExp(r'[a-zA-Z\s]'), '');
                        double eLoader = double.tryParse(distanceString) ?? 0.0;
                        String totalTimeNew = resultTotal['total_time'].toString();
                        final chosen = result['chosen'];
                        final km = (chosen['distanceValue'] as int) / 1000.0;
                        final duration = chosen['durationText'];

                        // Store them in string variables
                        String distanceText = "${km.toStringAsFixed(2)} KM";
                        String timeText = duration;
                        stopLocations[0]['expected_time_to_next'] = timeText;
                        stopLocations[0]['distance_to_next'] = distanceText;
                        print("Distance: $distanceText, Time: $timeText");
                        // Now navigate and pass values
                        Get.to(() =>CategoryList(
                          dropAddress: widget.dropAddress,
                          pickAddress: widget.pickAddress,
                          pickLat: widget.pickLat,
                          pickLng: widget.pickLng,
                          sendMobile: sendMobile,
                          senderName: senderName,
                          houseNoCt: houseNoCt,
                          stopLocations: stopLocations,
                          distance: totalDistanceNew,
                          expectedTime: totalTimeNew,
                          eLoader: eLoader,
                          scheduleDate: widget.scheduleDate,
                          scheduleTime: widget.scheduleTime,
                        ));
                      } catch (e) {
                        print("Error issss: $e");
                        showCustomSnackBar("Failed to calculate distance".tr);
                      }
                    } else {
                      showCustomSnackBar("Enter Receiver details".tr);
                    }
                  },
                  child: Container(

                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    //padding: const EdgeInsets.symmetric(vertical: 17),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color:AppColors.secondaryGradient,
                      /*gradient: LinearGradient(
                            begin: Alignment(1.00, 0.00),
                            end: Alignment(-1, 0),
                            colors: [ AppColors.primaryGradient,AppColors.secondaryGradient],
                          ),*/
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppContants.btnRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'continue'.toUpperCase().tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.60,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            height: 0,
                            letterSpacing: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),

      ),
    );
  }

  @override
  void dispose() {
    for (var c in houseNoCt.values) {
      c.dispose();
    }
    super.dispose();
  }
}
