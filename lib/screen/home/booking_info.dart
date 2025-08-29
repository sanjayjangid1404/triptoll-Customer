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

class BookingInfo extends StatefulWidget {
  String pickAddress;
  String dropAddress;
  double pickLat;
  double pickLng;
  double dropLng;
  double dropLat;
   BookingInfo({super.key,required this.dropLng,required this.dropLat,required this.pickAddress,required this.pickLat,required this.pickLng,required this.dropAddress});

  @override
  State<BookingInfo> createState() => _BookingInfoState();
}

class _BookingInfoState extends State<BookingInfo> {

  late GoogleMapController _mapController;
  bool _isRouteDrawn = false;
  bool isActive = false;
  final String _googleMapsApiKey = 'AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk';

   Map<int, TextEditingController> houseNoCt = {};
   Map<int, TextEditingController> senderName = {};
   Map<int, TextEditingController> sendMobile = {};


  // Jaipur locations as example
  final LatLng _pickupLocation = const LatLng(26.9124, 75.7873); // Jaipur center
  final LatLng _dropLocation = const LatLng(26.8371, 75.8338);   // Malviya Nagar

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<Map<String, dynamic>> stopLocations = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      stopLocations.add({
        'lat': widget.dropLat,
        'lng': widget.dropLng,
        'address': widget.dropAddress,
      });

      _addMarkers();
      setState(() {

      });


      Get.find<AuthController>().getAllVehicleData();
      _getRouteBetweenPoints(pickLat: widget.pickLat,pickLng: widget.pickLng,stopLocations: stopLocations);


    });
  }


  bool validateFields() {
    // Validate sender names (not empty)
    bool areNamesValid = !senderName.values.any((c) => c.text.trim().isEmpty);

    // Validate mobile numbers (not empty AND exactly 10 digits)
    bool areMobilesValid = !sendMobile.values.any((c) =>
    c.text.trim().isEmpty ||
        c.text.trim().length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(c.text));

    return areNamesValid && areMobilesValid;
  }
  String? validateFieldsWithMessages() {
    // Check sender names
    if (senderName.values.any((c) => c.text.trim().isEmpty)) {
      return 'All sender names are required';
    }

    // Check mobile numbers
    for (var controller in sendMobile.values) {
      final text = controller.text.trim();
      if (text.isEmpty) {
        return 'All mobile numbers are required';
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
      Map<int, TextEditingController> map, int oldIndex, int newIndex) {
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

  void _addMarkers() {
    _markers.clear();

    // Pickup marker
    _markers.add(Marker(
      markerId: MarkerId('pickup'),
      position: LatLng(widget.pickLat, widget.pickLng),
      infoWindow: InfoWindow(title: "Pickup Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));

    // Drop marker
    // _markers.add(Marker(
    //   markerId: MarkerId('drop'),
    //   position: LatLng(widget.dropLat, widget.dropLng),
    //   infoWindow: InfoWindow(title: "Drop Location"),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    // ));

    // Stop markers
    for (int i = 0; i < stopLocations.length; i++) {
      final stop = stopLocations[i];
      _markers.add(Marker(
        markerId: MarkerId('stop_$i'),
        position: LatLng(stop['lat'], stop['lng']),
        infoWindow: InfoWindow(title: 'Stop ${i + 1}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }

    setState(() {});
  }


  Future<void> _getRouteBetweenPoints({
    required double pickLat,
    required double pickLng,
    required List<Map<String, dynamic>> stopLocations, // Required
  }) async {
    if (stopLocations.isEmpty) {
      print("No stops provided");
      return;
    }

    // Drop location = last stop
    final lastStop = stopLocations.last;
    final dropLat = lastStop['lat'];
    final dropLng = lastStop['lng'];

    // Waypoints = all stops except last (since last is drop)
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

          _markers.clear(); // Purane markers hata do

          // Pickup location marker
          _markers.add(
            Marker(
              markerId: const MarkerId('pickup'),
              position: LatLng(pickLat, pickLng),
              infoWindow: const InfoWindow(title: 'Pickup'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ),
          );

          // All stoppages markers
          for (int i = 0; i < stopLocations.length; i++) {
            final stop = stopLocations[i];
            _markers.add(
              Marker(
                markerId: MarkerId('stop_$i'),
                position: LatLng(stop['lat'], stop['lng']),
                infoWindow: InfoWindow(title: 'Stop ${i + 1}'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              ),
            );
          }

          _isRouteDrawn = true;
        });

      } else {
        print('Directions request failed: ${data['status']}');
      }
    } catch (e) {
      print('Error getting route: $e');
    }
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
                                const Text(
                                  'Pickup Location',
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
                    final senderController = senderName[index] ?? TextEditingController(text: stop['name'] ?? '');
                    final senderMobileController = sendMobile[index] ?? TextEditingController(text: stop['mobile'] ?? '');

                    if (!houseNoCt.containsKey(index)) {
                      houseNoCt[index] = controller;
                    }

                    if (!senderName.containsKey(index)) {
                      senderName[index] = senderController;
                    }

                    if (!sendMobile.containsKey(index)) {
                      sendMobile[index] = senderMobileController;
                    }
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            tilePadding: EdgeInsets.zero, // Align to left
                            childrenPadding: const EdgeInsets.only(left: 35, right: 8, bottom: 10),
                            title: InkWell(
                              onTap:() async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LocationPickerTypeAheadPage(isPick: true,title: "Drop Location",)),
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

                                  setState(() {
                                    // widget.pickLng = result['lng'];
                                    // widget.pickLat = result['lat'];
                                    // widget.pickAddress = result['address'];

                                    _addMarkers();
                                    _getRouteBetweenPoints(pickLat: widget.pickLat,pickLng: widget.pickLng,stopLocations: stopLocations);
                                  });
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on_outlined, color: Colors.red, size: 30),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Drop Location',
                                          style: TextStyle(
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
                            onExpansionChanged: (expanded) {
                              // Expand होने पर कुछ करना हो तो यहां
                            },
                            children: [
                              // यह TextField expand होने पर दिखेगा
                              TextField(
                                controller: controller,
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontFamily: AppFonts.poppinsRegular,
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  counter: const SizedBox(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  fillColor: const Color(0xFFC11F1F),
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
                                  labelText: "House/Apartment/shop (Optional)",
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: AppFonts.poppinsMedium,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                                onChanged: (value) {
                                  // अगर टाइप किया हुआ data stopLocations में सेव करना हो:

                                },
                              ),
                              SizedBox(height: 10,),

                              TextField(
                                controller: senderController,
                                style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                                keyboardType: TextInputType.text,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  counter: SizedBox(),
                                  border: OutlineInputBorder(



                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  fillColor: Color(0xFFC11F1F),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),

                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),

                                    borderRadius: BorderRadius.circular(4),
                                  ),

                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjust the vertical padding
                                  // hintText: "House/Apartment/shop (Optional)",
                                  labelText: "Receiver's Name",
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: AppFonts.poppinsMedium,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),

                              SizedBox(height: 10,),

                              TextField(
                                controller: senderMobileController,
                                style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  counter: SizedBox(),
                                  border: OutlineInputBorder(

                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  fillColor: Color(0xFFC11F1F),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),

                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),

                                    borderRadius: BorderRadius.circular(4),
                                  ),

                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjust the vertical padding
                                  // hintText: "House/Apartment/shop (Optional)",
                                  labelText: "Receiver's Mobile Number",
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: AppFonts.poppinsMedium,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    );



                  },
                ),
                SizedBox(height: 10,),

                SizedBox(height: 10,),
                // Divider(
                //   color: Colors.grey,
                //   thickness: 0.5,
                // ),
                // SizedBox(height: 10,),

               /* TextField(
                  controller: houseNoCt,
                  style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  decoration: InputDecoration(
                    counter: SizedBox(),
                    border: OutlineInputBorder(



                      borderRadius: BorderRadius.circular(4),
                    ),
                    fillColor: Color(0xFFC11F1F),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),

                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),

                      borderRadius: BorderRadius.circular(4),
                    ),

                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjust the vertical padding
                   // hintText: "House/Apartment/shop (Optional)",
                    labelText: "House/Apartment/shop (Optional)",
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 12,
                      fontFamily: AppFonts.poppinsMedium,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),*/


                SizedBox(height: 10,),
                
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
                  onTap: (){

                    print(validateFields());
                    if(validateFields()){
                      Get.to(CategoryList(dropAddress: widget.dropAddress,pickAddress: widget.pickAddress,pickLat: widget.pickLat,pickLng: widget.pickLng,sendMobile: sendMobile,senderName: senderName,houseNoCt: houseNoCt,stopLocations: stopLocations,));
                    }else {
                      showCustomSnackBar("Enter Receiver details");
                    }

                   //
                    // Get.offAllNamed(RouteHelper.getHomeView());



                  },
                  child: Container(

                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    //padding: const EdgeInsets.symmetric(vertical: 17),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: AppColors.primaryGradient,
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
                          'continue'.toUpperCase(),
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
