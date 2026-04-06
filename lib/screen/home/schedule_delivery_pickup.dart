import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:triptoll/screen/home/pick_location.dart';
import 'dart:convert';
import 'package:triptoll/util/appColors.dart';
import 'booking_info.dart';

class ScheduleDeliveryPickUpScreen extends StatefulWidget {
  bool? isPick;
  String? pickAddress;
  String? title;
  double? pickLat;
  double? pickLng;
  String? date;
  String? time;
  String? houseNumber;
  String? city;
  String? street;
  bool? isShare;

  ScheduleDeliveryPickUpScreen({super.key,required this.isPick,required this.isShare,
    this.city,this.street,this.houseNumber,
    this.date,this.time,this.pickLng,this.pickLat,this.pickAddress,this.title});
  @override
  _ScheduleDeliveryPickUpScreenState createState() => _ScheduleDeliveryPickUpScreenState();
}

class _ScheduleDeliveryPickUpScreenState extends State<ScheduleDeliveryPickUpScreen> {
  final TextEditingController pickController = TextEditingController();
  String pickupAddress = '';
  GoogleMapController? mapController;
  double pickupLat = 0;
  double pickupLng =0;
  final String googleApiKey = "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk";
  String currentAddress = "";
  LatLng? currentLocation;
  Future<void> _getCurrentLocation() async {
    const double defaultLat = 26.9124; // Jaipur latitude
    const double defaultLng = 75.7873; // Jaipur longitude

    void setDefaultLocation() {
      setState(() {
        pickupLat = defaultLat;
        pickupLng = defaultLng;
        currentLocation = const LatLng(defaultLat, defaultLng);
        currentAddress = "Jaipur, Rajasthan";
        pickController.text = "Jaipur, Rajasthan";
        pickupAddress = "Jaipur, Rajasthan";
      });
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setDefaultLocation();
        return;
      }
    }

    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      Placemark place = placemarks.first;

      setState(() {
        pickupLat = pos.latitude;
        pickupLng = pos.longitude;
        currentLocation = LatLng(pickupLat!, pickupLng!);
        pickController.text =
        "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
        pickupAddress = "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
        currentAddress = place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea ??
            "Unknown City";
        print('city name::::${currentAddress}');

      });
    } catch (e) {
      setDefaultLocation();
    }
  }
  // Future<List<Map<String, dynamic>>> _getPlaceSuggestions(String input) async {
  //   final url =
  //       "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&components=country:in";
  //   final response = await http.get(Uri.parse(url));
  //   final data = json.decode(response.body);
  //   if (data['status'] == 'OK') {
  //     return List<Map<String, dynamic>>.from(data['predictions']);
  //   } else {
  //     return [];
  //   }
  // }
  bool isInitialLoad = true;
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
      isFromSuggestion = true;
      pickupLat = position.latitude;
      pickupLng = position.longitude;
    });

    _moveToLocation(pickupLat!, pickupLng!);
    await _getAddressFromLatLng(pickupLat!, pickupLng!, true);
  }
  Future<void> _setCurrentLocationShare() async {
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
    await _getAddressFromLatLngShare(pickupLat!, pickupLng!);
  }
  Future<void> _getAddressFromLatLngShare(double lat, double lng) async {
    try {
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey";

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        String address = '';

        for (var result in data['results']) {
          if (result['formatted_address'] != null &&
              !result['formatted_address'].contains('+') &&
              (result['types'].contains('street_address') ||
                  result['types'].contains('premise') ||
                  result['types'].contains('route') ||
                  result['types'].contains('neighborhood'))) {
            address = result['formatted_address'];
            break;
          }
        }

// fallback
        if (address.isEmpty) {
          address = data['results'][0]['formatted_address'];
        }

        setState(() {
          pickController.text = address;
          pickupAddress = address;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  GoogleMapController? _mapController;
  Future<void> _getCurrentLocation2() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      _getAddressFromLatLng(position.latitude, position.longitude,false);
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLng(currentLocation!),
    );
  }


  Future<void> _getAddressFromLatLng(double lat, double lng, bool current) async {
    try {
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey";

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        String address = '';

        for (var result in data['results']) {
          if (result['formatted_address'] != null &&
              !result['formatted_address'].contains('+') &&
              (result['types'].contains('street_address') ||
                  result['types'].contains('premise') ||
                  result['types'].contains('route') ||
                  result['types'].contains('neighborhood'))) {
            address = result['formatted_address'];
            break;
          }
        }

        if (address.isEmpty) {
          address = data['results'][0]['formatted_address'];
        }

        setState(() {
          if (current) {
            pickController.text = "";
            pickupAddress = '';
          } else {
            pickController.text = address;
            pickupAddress = address;
          }
        });
      }
    } catch (e) {
      print("Geocoding error: $e");
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
    isFromSuggestion = true;
    mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(lat, lng)),
    );
  }

  void _updateMapLocation(pickupLat,pickupLng) {
    if (pickupLat != 0 && pickupLng != 0 && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(pickupLat, pickupLng),
            zoom: 15,
          ),
        ),
      );
    }
  }
  bool _isLatLng(String value) {
    final regExp = RegExp(r'^-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?$');
    return regExp.hasMatch(value);
  }

  Future<Map<String, dynamic>> _getAddressFromLatLngSearch(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      return {
        'description': data['results'][0]['formatted_address'],
        'lat': lat,
        'lng': lng,
      };
    }

    return {
      'description': 'Unknown location',
      'lat': lat,
      'lng': lng,
    };
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isInitialLoad = true;
    _getCurrentLocation();
    print('widget.isShare1 ${widget.isShare}');
    if(widget.isShare == false) {
      _setCurrentLocation();
      log('widget.isShare1 ${widget.isShare}');
    }
    if(widget.isShare == true){
      pickupLatShare = widget.pickLat ?? 0;
      pickupLngShare = widget.pickLng ?? 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateMapLocation(pickupLatShare, pickupLngShare);
      });

      log('widget.isShare212 ${widget.isShare}');
    }
    setState(() {

    });
  }
  double pickupLatShare = 0.0;
  double pickupLngShare =0.0;
  Future<String> _getCityFromLatLng(double lat, double lng) async {
    try {
      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey";

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data["status"] != "OK") {
        return "Unknown City";
      }

      String city = "";
      String locality = "";

      for (var result in data["results"]) {
        for (var component in result["address_components"]) {

          List types = component["types"];

          if (types.contains("administrative_area_level_2")) {
            city = component["long_name"];
          }

          if (types.contains("locality")) {
            locality = component["long_name"];
          }
        }
      }


      city = city
          .replaceAll("Division", "")
          .replaceAll("District", "")
          .replaceAll("division", "")
          .replaceAll("district", "")
          .trim();

      /// If city still empty → use locality
      if (city.isEmpty) {
        city = locality;
      }

      return city.isEmpty ? "Unknown City" : city;
    } catch (e) {
      print("City detect error: $e");
      return "Unknown City";
    }
  }
  Future<void> _handlePlaceSelection(Map<String, dynamic> suggestion) async {
    final latLng = await _getPlaceLatLng(suggestion['place_id']);
    double lat = latLng['lat']!;
    double lng = latLng['lng']!;

    String city = await _getCityFromLatLng(lat, lng);

    if (widget.isPick == true) {
      widget.city = city;
      print('city is address ${widget.city}');
    }

    setState(() {
      pickController.text = suggestion['description'];
      pickupAddress = suggestion['description'];

      if (widget.isShare == true) {
        widget.pickLat = lat;
        widget.pickLng = lng;
      } else {
        pickupLat = lat;
        pickupLng = lng;
      }
    });

    _moveToLocation(lat, lng);
  }
  Future<void> _handleLatLngSelection(
      double lat, double lng, String address) async
  {

    String city = await _getCityFromLatLng(lat, lng);

    if (widget.isPick == true) {
      widget.city = city;
    }

    setState(() {
      isFromSuggestion = true;
      pickController.text = address;
      pickupAddress = address;

      if (widget.isShare == true) {
        widget.pickLat = lat;
        widget.pickLng = lng;
      } else {
        pickupLat = lat;
        pickupLng = lng;
      }
    });

    _moveToLocation(lat, lng);
  }

  Future<List<Map<String, dynamic>>> _getPlaceSuggestions(String input) async {

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String city = await _getCityFromLatLng(
        position.latitude, position.longitude);
    if (_isLatLng(input)) {
      return [
        {
          'description': 'Use this location ($input)',
          'isLatLng': true,
          'latLngText': input,
        }
      ];
    }

    // 🔹 NORMAL GOOGLE AUTOCOMPLETE
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=${Uri.encodeComponent('$input $city')}&location=${position.latitude},${position.longitude}&radius=50000&key=$googleApiKey&components=country:in";

    print('data search ${url.toString()}');
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      return List<Map<String, dynamic>>.from(data['predictions']);
    } else {
      return [];
    }
  }
  bool isFromSuggestion = false;

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
              target: widget.isShare == true ? LatLng(pickupLatShare, pickupLngShare) : LatLng(pickupLat, pickupLng),
              zoom: 18,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },

            onCameraIdle: () async {

              if (isInitialLoad) {
                isInitialLoad = false;
                log('⏭ initial load skip $pickupLat,$pickupLng');
                Future.delayed(Duration(seconds: 1),() async {
                  await _getAddressFromLatLng(pickupLat, pickupLng,false);
                  log('⏭ initial load skip $pickupLat,$pickupLng');
                },);
                return;
              }
              if (isFromSuggestion) {
                isFromSuggestion = false;
                log('sdsdsdfunc${isFromSuggestion.toString()}');
                return;
              }
              log('sdsdsd${isFromSuggestion.toString()}');
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
            bottom: 150,
            left: 20,
            child: FloatingActionButton(
              heroTag: "btnCurrentLocation",
              backgroundColor: Colors.white,
              onPressed: _getCurrentLocation2,
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: TypeAheadField<Map<String, dynamic>>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: pickController,
                  onTap: () {
                    setState(() {
                    pickController.text = '';
                    });
                  },
                  onSubmitted: (value) async {
                    if (value.isEmpty) return;

                    if (_isLatLng(value)) {
                      final parts = value.split(',');
                      final lat = double.parse(parts[0].trim());
                      final lng = double.parse(parts[1].trim());

                      final address = await _getAddressFromLatLngSearch(lat, lng);

                      _handleLatLngSelection(
                        lat,
                        lng,
                        address['description'],
                      );
                    } else {
                      final suggestions = await _getPlaceSuggestions(value);

                      if (suggestions.isNotEmpty) {
                        _handlePlaceSelection(suggestions.first);
                      }
                    }
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: '${'Enter'.tr} ${widget.title!.tr}',
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
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  color: Colors.white,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(8),
                ),
                onSuggestionSelected: (suggestion) async {
                  if (suggestion['isLatLng'] == true) {
                    final parts = suggestion['latLngText'].split(',');
                    final lat = double.parse(parts[0].trim());
                    final lng = double.parse(parts[1].trim());

                    final address =
                    await _getAddressFromLatLngSearch(lat, lng);

                    _handleLatLngSelection(
                      lat,
                      lng,
                      address['description'],
                    );
                    return;
                  }
                  final latLng = await _getPlaceLatLng(suggestion['place_id']);
                  double lat = latLng['lat']!;
                  double lng = latLng['lng']!;
                  String city = await _getCityFromLatLng(lat, lng);
                  currentAddress = city;
                  print('city is address ${currentAddress.toString()}');
                  setState(() {
                    pickController.text = suggestion['description'];
                    pickupAddress = suggestion['description'];
                    if(widget.isShare == true){
                      widget.pickLat = latLng['lat']!;
                      widget.pickLng = latLng['lng']!;
                    }else {
                      pickupLat = latLng['lat']!;
                      pickupLng = latLng['lng']!;
                    }
                  });
                  if(widget.isShare == true){
                    double pickupLat = latLng['lat']!;
                    double pickupLng = latLng['lng']!;
                    _moveToLocation(pickupLat, pickupLng);
                  }else{
                    _moveToLocation(pickupLat, pickupLng);
                  }

                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),
          Positioned(
            bottom:  MediaQuery.of(context).padding.bottom + 35,
            left: 20,
            right: 20,
            child: SafeArea(
              minimum: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGradient,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                    Get.to(LocationPickerTypeAheadPage(
                        isShare: false,
                        isPick: false,
                        pickLng: pickupLng,
                        pickLat: pickupLat,
                        houseNumber: currentAddress.toString(),
                        street: currentAddress.toString(),
                        city: currentAddress.toString(),
                        pickAddress: pickupAddress.toString(),
                        title: "Drop Location",
                        date: widget.date,
                        time: widget.time,
                      ),
                    );
                },
                child: Text("${'Confirm'.tr} ${widget.title!.tr}", style: TextStyle(fontSize: 18,color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
