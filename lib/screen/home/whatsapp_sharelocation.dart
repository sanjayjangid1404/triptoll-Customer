import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:triptoll/screen/home/pick_location.dart';

import '../../util/app_fonts.dart';
import 'booking_info.dart';

class LocationSelectionScreen extends StatefulWidget {
  final double? lat;
  final double? long;

  const LocationSelectionScreen({
    super.key,
    required this.lat,
    required this.long,
  });

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState
    extends State<LocationSelectionScreen> {

  GoogleMapController? _mapController;
  late LatLng selectedLocation;

  bool isPickupSelected = false;

  Marker? currentMarker;
  String currentAddressWhatsapp = "Loading address...";
  double? pickupLat;
  double? pickupLng;
  String pickupAddress = "Fetching pickup location...";
  Future<void> getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    pickupLat = position.latitude;
    pickupLng = position.longitude;

    /// Address fetch karo
    List<Placemark> placemarks =
    await placemarkFromCoordinates(pickupLat!, pickupLng!);

    Placemark place = placemarks.first;

    setState(() {
      pickupAddress =
      "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.lat != null && widget.long != null) {

       selectedLocation = LatLng(widget.lat!, widget.long!);
    }
    getUserCurrentLocation();
    updateMarker();
    getAddressFromLatLng();
  }

  Future<void> getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );

      Placemark place = placemarks.first;

      setState(() {
        currentAddressWhatsapp =
        "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        currentAddressWhatsapp = "Unable to fetch address";
      });
    }
  }

  void updateMarker() {
    setState(() {
      currentMarker = Marker(
        markerId: const MarkerId("selected"),
        position: selectedLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isPickupSelected
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueRed,
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        selectedLocation,
        18, // 🔥 Zoom increase
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation,
              zoom: 18, // 🔥 More zoom
            ),
            markers: currentMarker != null ? {currentMarker!} : {},
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (latLng) {
              selectedLocation = latLng;
              updateMarker();
              getAddressFromLatLng(); // 🔥 address update
            },
            myLocationEnabled: true,
          ),

          /// BACK BUTTON
          Positioned(
            top: 50,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentAddressWhatsapp,
                    style:  TextStyle(
                      fontFamily: AppFonts.poppinsRegular,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),

                  buildOptionTile(
                    title: "Pick-up",
                    isSelected: isPickupSelected,
                    subtitle:
                    "Goods will be picked-up from pinned location",
                    color: Colors.green,
                    onTap: () {
                      isPickupSelected = true;
                      updateMarker();
                    },
                  ),

                  const SizedBox(height: 10),

                  buildOptionTile(
                    title: "Drop",
                    subtitle:
                    "Goods will be dropped at pinned location",
                    isSelected: !isPickupSelected,
                    color: Colors.red,
                    onTap: () {
                      isPickupSelected = false;
                      updateMarker();
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        DateTime now = DateTime.now();
                        DateTime updatedDateTime = now.add(const Duration(minutes: 30));
                        String formattedTime =
                            '${updatedDateTime.hour.toString().padLeft(2, '0')}:${updatedDateTime.minute.toString().padLeft(2, '0')}';
                        String onlyDate =
                        DateFormat('yyyy-MM-dd').format(updatedDateTime);
                        if(isPickupSelected){
                          Get.to( ()=> LocationPickerTypeAheadPage(
                            isShare: true,
                            isPick: false,
                            pickLng: widget.long,
                            pickLat: widget.lat,
                            houseNumber: currentAddressWhatsapp.toString(),
                            street: currentAddressWhatsapp.toString(),
                            city: currentAddressWhatsapp.toString(),
                            pickAddress: currentAddressWhatsapp.toString(),
                            title: "Drop Location",
                            date: onlyDate,
                            time: formattedTime,
                          ));
                        }else{
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => BookingInfo(
                                scheduleDate: onlyDate,
                                scheduleTime: formattedTime,
                                houseNumber: pickupAddress.toString(),
                                street: pickupAddress.toString(),
                                city: pickupAddress.toString(),
                                dropAddress: currentAddressWhatsapp.toString(),
                                dropLat: widget.lat!,
                                dropLng: widget.long!,
                                pickAddress: pickupAddress,
                                pickLat: pickupLat!,
                                pickLng: pickupLng!)),
                          );
                        }

                      },
                      child: Text("Proceed",
                          style:  TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.poppinsRegular,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [

            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? color : Colors.grey,
            ),

            const SizedBox(width: 12),


            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:  TextStyle(
                          fontFamily: AppFonts.poppinsRegular,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontFamily: AppFonts.poppinsRegular,
                        fontSize: 12,
                        color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}