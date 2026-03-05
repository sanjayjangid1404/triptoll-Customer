import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:triptoll/util/appColors.dart';
import '../../util/custom_snackbar.dart';
import 'booking_info.dart';

class LocationPickerTypeAheadPage extends StatefulWidget {
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

  LocationPickerTypeAheadPage({super.key,required this.isPick,required this.isShare,
    this.city,this.street,this.houseNumber,
    this.date,this.time,this.pickLng,this.pickLat,this.pickAddress,this.title});
  @override
  _LocationPickerTypeAheadPageState createState() => _LocationPickerTypeAheadPageState();
}

class _LocationPickerTypeAheadPageState extends State<LocationPickerTypeAheadPage> {
  final TextEditingController pickController = TextEditingController();
  String pickupAddress = '';
  GoogleMapController? mapController;
  bool _isProgrammaticChange = false;
  bool _isSelectingSuggestion = false;

  Future<String> _getCityFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea ??
            "Unknown City";
      }
    } catch (e) {
      print("City error: $e");
    }
    return "Unknown City";
  }

  double pickupLat = 0;
  double pickupLng =0;
  final String googleApiKey = "AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk";

  Future<List<Map<String, dynamic>>> _getPlaceSuggestions(String input) async {
    // 🔹 LAT LNG CASE
    if (_isLatLng(input)) {
      return [
        {
          'description': 'Use this location ($input)',
          'isLatLng': true,
          'latLngText': input,
        }
      ];
    }

    // 🔹 Normalize + encode
    final normalized = _normalizeAddress(input);
    final encoded = Uri.encodeComponent(normalized);

    /// -------------------------------
    /// 1️⃣ TRY AUTOCOMPLETE FIRST
    /// -------------------------------
    final autoUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=$encoded"
        "&key=$googleApiKey"
        "&components=country:in"
        "&language=en";

    final autoRes = await http.get(Uri.parse(autoUrl));
    final autoData = json.decode(autoRes.body);

    if (autoData['status'] == 'OK' &&
        autoData['predictions'] != null &&
        autoData['predictions'].isNotEmpty) {
      return List<Map<String, dynamic>>.from(autoData['predictions']);
    }

    final textUrl =
        "https://maps.googleapis.com/maps/api/place/textsearch/json"
        "?query=$encoded"
        "&key=$googleApiKey"
        "&language=en";

    final textRes = await http.get(Uri.parse(textUrl));
    final textData = json.decode(textRes.body);

    if (textData['status'] == 'OK' &&
        textData['results'] != null &&
        textData['results'].isNotEmpty) {
      return List<Map<String, dynamic>>.from(
        textData['results'].map((e) => {
          'description': e['formatted_address'] ?? e['name'],
          'place_id': e['place_id'],
        }),
      );
    }

    return [];
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
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            "${place.name}, ${place.subLocality}, ${place.locality}, ${place.country}";
        // setState(() {
        _isProgrammaticChange = true;

        pickController.text = address;

        setState(() {
          showSuggestions = false;
          suggestions.clear();
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          _isProgrammaticChange = false;
        });

        pickupAddress = address;
          print('address address${address}');
        // });
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
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
            pickupAddress = '';
          }
          else
          {
            _isProgrammaticChange = true;

            pickController.text = address;

            setState(() {
              showSuggestions = false;
              suggestions.clear();
            });

            Future.delayed(const Duration(milliseconds: 100), () {
              _isProgrammaticChange = false;
            });

            pickupAddress = address;
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
  Timer? _debounce;
  void _onSearchChanged(String value) {
    // Cancel previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (value.trim().isEmpty) {
        if (!mounted) return;
        setState(() {
          showSuggestions = false;
          suggestions.clear();
        });
        return;
      }

      try {
        final data = await _getPlaceSuggestions(value.trim());

        if (!mounted) return;

        setState(() {
          suggestions = data;
          showSuggestions = data.isNotEmpty;
        });
      } catch (e) {
        debugPrint('Search error: $e');
      }
    });
  }
  String _normalizeAddress(String input) {
    return input
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _lastValue = '';
  void _onTextChanged() {
    if (_isProgrammaticChange || _isSelectingSuggestion) return;

    final value = pickController.text.trim();

    // 🔥 PASTE DETECTION
    final bool isPaste =
        (value.length - _lastValue.length) > 3;
    _lastValue = value;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (value.isEmpty) {
        if (!mounted) return;
        setState(() {
          showSuggestions = false;
          suggestions.clear();
        });
        return;
      }

      /// 🔹 LAT LNG (unchanged)
      if (_isLatLng(value)) {
        setState(() {
          showSuggestions = false;
          suggestions.clear();
        });

        final parts = value.split(',');
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


      /// 🔹 ADDRESS SEARCH
      final data = await _getPlaceSuggestions(value);
      if (!mounted || data.isEmpty) return;

      // ✅ PASTE → AUTO MOVE MAP
      if (isPaste) {
        _isSelectingSuggestion = true;

        await _handlePlaceSelection(data.first);

        setState(() {
          showSuggestions = false;
          suggestions.clear();
        });

        Future.delayed(const Duration(milliseconds: 120), () {
          _isSelectingSuggestion = false;
        });
        return;
      }

      // ✅ TYPE → SHOW SUGGESTIONS ONLY
      setState(() {
        suggestions = data;
        showSuggestions = true;
      });
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.isShare1 ${widget.isShare}');
    pickController.addListener(_onTextChanged);
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
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> suggestions = [];
  bool showSuggestions = false;

  double pickupLatShare = 0.0;
  double pickupLngShare =0.0;
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
  bool _isLatLng(String value) {
    final regExp = RegExp(r'^-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?$');
    return regExp.hasMatch(value);
  }
  Future<Map<String, dynamic>> _getAddressFromLatLngSearch(
      double lat, double lng) async
  {

    final placemarks = await placemarkFromCoordinates(lat, lng);

    final place = placemarks.first;

    return {
      'description':
      '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}',
      'lat': lat,
      'lng': lng,
    };
  }
  Future<void> _handleLatLngSelection(
      double lat, double lng, String address) async
  {

    String city = await _getCityFromLatLng(lat, lng);

    if (widget.isPick == true) {
      widget.city = city;
    }

    setState(() {
      _isProgrammaticChange = true;

      pickController.text = address;

      setState(() {
        showSuggestions = false;
        suggestions.clear();
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        _isProgrammaticChange = false;
      });

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
  @override
  void dispose() {
    pickController.removeListener(_onTextChanged);
    _debounce?.cancel();
    super.dispose();
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
              target: widget.isShare == true ? LatLng(pickupLatShare, pickupLngShare) : LatLng(pickupLat, pickupLng),
              zoom: 15,
            ),
            onTap: (LatLng latLng) {
              FocusScope.of(context).unfocus();
              setState(() {
                showSuggestions = false;
                suggestions.clear();
              });
            },
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
            top: 100,
            left: 16,
            right: 16,
            child: Column(
              children: [
                TextFormField(
                  controller: pickController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: '${'Enter'.tr} ${widget.title!.tr}',
                    prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    _onTextChanged();
                  },
                  onTap: () {
                    pickController.clear();
                    suggestions.clear();
                    setState(() => showSuggestions = false);
                  },
                  onFieldSubmitted: (value) async {
                    value = value.trim();
                    if (value.isEmpty) return;

                    if (_isLatLng(value)) {
                      final parts = value.split(',');
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

                    final list = await _getPlaceSuggestions(value);
                    if (list.isNotEmpty) {
                      _handlePlaceSelection(list.first);
                    }

                    FocusScope.of(context).unfocus();
                    setState(() => showSuggestions = false);
                  },
                ),


                if (showSuggestions) ...[
                  const SizedBox(height: 4),
                  Material(
                    elevation: 6,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(suggestion['description']),
                          onTap: () async {
                            _isSelectingSuggestion = true;

                            FocusScope.of(context).unfocus();

                            await _handlePlaceSelection(suggestion);

                            setState(() {
                              showSuggestions = false;
                              suggestions.clear();
                            });

                            // 🔥 small delay so controller listener ignore ho jaye
                            Future.delayed(const Duration(milliseconds: 100), () {
                              _isSelectingSuggestion = false;
                            });
                          },

                        );
                      },
                    ),
                  ),
                ],
              ],
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
                _setCurrentLocationShare();
                if(widget.isPick!) {
                  Navigator.pop(context, {
                  'lat': pickupLat,
                  'lng': pickupLng,
                  'address': pickController.text,
                });
                  print('qwertyuiback${widget.pickLat.toString()}');
                }
                else {
                  if(widget.isShare == true){

                    print('class mean:::share location is work ${pickupLat.toString() + pickupLng.toString() + widget.pickLat!.toString()}');
                    print('class mean:::share location is work ${ pickController.text.toString()}');
                     Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          BookingInfo(scheduleDate: widget.date,
                              scheduleTime: widget.time,
                              pickAddress: pickupAddress,
                              pickLat: pickupLat,
                              houseNumber: widget.houseNumber.toString(),
                              street: widget.street.toString(),
                              city: widget.city.toString(),
                              pickLng: pickupLng,
                              dropAddress: widget.pickAddress!,
                              dropLat: widget.pickLat!,
                              dropLng: widget.pickLng!)),
                    );
                  }
                  else{
                    print('class mean:::share location not work');
                    print('qwertyui1111${widget.pickLat.toString()}');
                    print('qwertyui1111${ widget.city.toString()}');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BookingInfo(
                          scheduleDate: widget.date,
                          scheduleTime: widget.time,
                          houseNumber: widget.houseNumber.toString(),
                          street: widget.street.toString(),
                          city: widget.city.toString(),
                          dropAddress: pickupAddress,
                          dropLat: pickupLat,
                          dropLng: pickupLng,
                          pickAddress: widget.pickAddress!,
                          pickLat: widget.pickLat!,
                          pickLng: widget.pickLng!)),
                    );
                  }



                }
              },
              child: Text("${'Confirm'.tr} ${widget.title!.tr}", style: TextStyle(fontSize: 18,color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
