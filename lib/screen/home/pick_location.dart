import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:triptoll/util/appColors.dart';

import 'booking_info.dart';

class LocationPickerTypeAheadPage extends StatefulWidget {
  bool? isPick;
  String? pickAddress;
  String? title;

  double? pickLat;
  double? pickLng;


  LocationPickerTypeAheadPage({super.key,required this.isPick,this.pickLng,this.pickLat,this.pickAddress,this.title});
  @override
  _LocationPickerTypeAheadPageState createState() => _LocationPickerTypeAheadPageState();
}

class _LocationPickerTypeAheadPageState extends State<LocationPickerTypeAheadPage> {
  final TextEditingController pickController = TextEditingController();
  GoogleMapController? mapController;
  double pickupLat = 0;
  double pickupLng =0;
  final String googleApiKey = "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk";

  Future<List<Map<String, dynamic>>> _getPlaceSuggestions(String input) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&components=country:in";
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    if (data['status'] == 'OK') {
      return List<Map<String, dynamic>>.from(data['predictions']);
    } else {
      return [];
    }
  }

  Future<void> _setCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        // Permission denied permanently, handle gracefully
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      pickupLat = position.latitude;
      pickupLng = position.longitude;
    });

    _moveToLocation(pickupLat!, pickupLng!);
    await _getAddressFromLatLng(pickupLat!, pickupLng!, true);
  }


  Future<void> _getAddressFromLatLng(double lat, double lng,bool current) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            "${place.name}, ${place.subLocality}, ${place.locality}, ${place.country}";
        setState(() {
          if(current) {
            pickController.text = "";
          }
          else
          {
            pickController.text = address;
          }
        });
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
  }
  Future<Map<String, double>> _getPlaceLatLng(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    final location = data['result']['geometry']['location'];
    return {
      'lat': location['lat'],
      'lng': location['lng'],
    };
  }

  void _moveToLocation(double lat, double lng) {
    mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(lat, lng)),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setCurrentLocation();

    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(

        iconTheme: IconThemeData(color: AppColors.primaryGradient),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

       // title: Text(widget.title!,style: TextStyle(color: Colors.white),),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(pickupLat, pickupLng),
              zoom: 15,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },

            onCameraIdle: () async {
              await _getAddressFromLatLng(pickupLat, pickupLng,false);
            },

            onCameraMove: (position) {
              setState(() {
                pickupLat = position.target.latitude;
                pickupLng = position.target.longitude;
              });
            },
          ),
          Positioned(
            top: 80,
            left: 16,
            right: 16,

            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: TypeAheadField<Map<String, dynamic>>(
                textFieldConfiguration: TextFieldConfiguration(
                  //controller: pickController,
                  decoration: InputDecoration(
                    hintText: 'Enter ${widget.title}',
                    prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                suggestionsCallback: _getPlaceSuggestions,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(suggestion['description']),
                  );
                },
                onSuggestionSelected: (suggestion) async {
                  pickController.text = suggestion['description'];
                  final latLng = await _getPlaceLatLng(suggestion['place_id']);
                  setState(() {
                    pickupLat = latLng['lat']!;
                    pickupLng = latLng['lng']!;
                  });
                  _moveToLocation(pickupLat, pickupLng);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryGradient,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {

                if(widget.isPick!) {
                  Navigator.pop(context, {
                  'lat': pickupLat,
                  'lng': pickupLng,
                  'address': pickController.text,
                });
                }
                else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BookingInfo(dropAddress: pickController.text,dropLat: pickupLat!,dropLng: pickupLng!,pickAddress: widget.pickAddress!,pickLat: widget.pickLat!,pickLng: widget.pickLng!)),
                  );


                }
              },
              child: Text("Confirm ${widget.title}", style: TextStyle(fontSize: 18,color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
