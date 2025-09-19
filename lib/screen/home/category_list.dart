import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/model/vehicle_data.dart';
import 'package:triptoll/screen/home/pick_location.dart';
import 'package:triptoll/screen/home/review_booking.dart';
import 'package:http/http.dart' as http;
import 'package:triptoll/screen/home/userTraking_view.dart';

import '../../util/appColors.dart';
import '../../util/appContants.dart';
import 'homeview.dart';

class CategoryList extends StatefulWidget {
  String pickAddress;
  String dropAddress;


  double pickLat;
  double pickLng;
  String distance;
  String expectedTime;
  Map<int, TextEditingController> houseNoCt = {};
  Map<int, TextEditingController> senderName = {};
  Map<int, TextEditingController> sendMobile = {};
  List<Map<String, dynamic>> stopLocations = [];
  CategoryList({super.key,required this.distance,required this.expectedTime,required this.pickAddress,required this.pickLat,required this.pickLng
    ,required this.dropAddress,required this.senderName,required this.sendMobile,required this.houseNoCt,required this.stopLocations});



  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList>  with SingleTickerProviderStateMixin{
  int selectIndex = 0;
  int selectItem = 0;
  Data? selectData;
  double totalFare = 0;
  bool _isRouteDrawn = false;
  bool _driverAccepted = false;
  List<Map<String, double>>? cachedFaresAndRates;


  int _waitingTime = 0;
  late Timer _timer;
  // double discountPercentage = 0;
  final String _googleMapsApiKey = 'AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk';
  late GoogleMapController _mapController;
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // bool isDiscountApplied = false;
  String selectedPayment = "Online"; // default

  late StreamSubscription _driverStream;
  double _progress = 1.0;
  Duration _remaining = const Duration(minutes: 10);
  void _startTimer() {
    const total = 600; // 10 min in seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
      } else {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
          _progress = _remaining.inSeconds / total;
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
    _driverStream = Stream.periodic(Duration(seconds: 60), (count) => count).listen((count) {
      if (count >= 9 && Get.find<AuthController>().driver == null) {
        Get.find<AuthController>().cancelOrder(
          bookingID: Get.find<AuthController>().newBookingID,
          reason: "No driver found in 10 minutes",
          comment: "Auto-cancelled",
          isOrder: false,
        );
        Get.snackbar(
          "Ride Cancelled",
          "All drivers are busy, please try after some time",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          duration: Duration(seconds: 12),
          margin: EdgeInsets.all(12),
          borderRadius: 8,
        );
        _driverStream.cancel();
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _waitingTime++;
      });
      if (Get.find<AuthController>().driver!=null) {
        _timer.cancel();
        setState(() {
          _driverAccepted = true;
        });
        // In real app, you would navigate to ride tracking screen
      }
    });
    _addMarkers();
    WidgetsBinding.instance.addPostFrameCallback((_) {



      _getRouteBetweenPoints(pickLat: widget.pickLat,pickLng: widget.pickLng, stopLocations: widget.stopLocations);
      fetchDiscount();
      if(Get.find<AuthController>().vehicleData!=null){
        calculateAndCacheFares(Get.find<AuthController>());
      }

      setState(() {

      });
    });

  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }
  @override
  void dispose() {
    _driverStream.cancel();
    _timer.cancel();
    super.dispose();
  }
  Future<String?> fetchDiscountPercentage() async {
    final url = Uri.parse('${AppContants.baseURl}Home/contactUsInfo');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List contacts = data['contact'];

        // Find the item with type "discount"
        final discountItem = contacts.firstWhere(
              (item) => item['type'] == 'discount',
          orElse: () => null,
        );

        if (discountItem != null) {
          return discountItem['description']; // e.g., "10"
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return null; // In case of error or not found
  }

  void fetchDiscount() async {
    final discount = await fetchDiscountPercentage();
    if (discount != null) {
      setState(() {
       // discountPercentage = double.tryParse(discount) ?? 0;
      });
    }
  }

  double calculateDistanceWithPickup({
    required double pickLat,
    required double pickLng,
    required List<Map<String, dynamic>> stops,
  }) {
    double totalDistance = 0.0;

    if (stops.isEmpty) return 0.0;

    // 1. Pickup से पहला stop तक distance
    double distanceToFirstStop = Geolocator.distanceBetween(
      pickLat,
      pickLng,
      stops.first['lat'],
      stops.first['lng'],
    );
    totalDistance += distanceToFirstStop / 1000;

    // 2. बाकी सभी stops के बीच distance
    for (int i = 0; i < stops.length - 1; i++) {
      double segmentDistance = Geolocator.distanceBetween(
        stops[i]['lat'],
        stops[i]['lng'],
        stops[i + 1]['lat'],
        stops[i + 1]['lng'],
      );
      totalDistance += segmentDistance / 1000;
    }

    return double.parse(totalDistance.toStringAsFixed(2)); // Round 2 decimals
  }

  Map<String, double> calculateFare({
    required double distanceInKm,
    required Data vehicleData,
  }) {
    final double baseFare = double.parse(vehicleData.baseFare.toString());
    final double baseFareUpto = double.parse(vehicleData.baseFareUpto.toString());

    final rates = [
      double.parse(vehicleData.rate1PerKm.toString()),
      double.parse(vehicleData.rate2PerKm.toString()),
      double.parse(vehicleData.rate3PerKm.toString()),
      double.parse(vehicleData.rate4PerKm.toString()),
    ];

    if (distanceInKm <= baseFareUpto) {
      return {
        'totalFare': baseFare,
        'randomRate': 0, // no random rate used
      };
    }



    final double extraDistance = distanceInKm - baseFareUpto;
    final double randomRate = rates[Random().nextInt(rates.length)];
    final double extraFare = extraDistance * randomRate;
     totalFare = baseFare + extraFare;

     print(totalFare);

    return {
      'totalFare': totalFare,
      'randomRate': randomRate,
    };
  }
  calculateAndCacheFares(AuthController authController) {
    if (widget.pickLat == null || widget.pickLng == null) return;

    final distance = calculateDistanceWithPickup(
      pickLat: widget.pickLat,
      pickLng: widget.pickLng,
      stops: widget.stopLocations,
    );

    cachedFaresAndRates = authController.vehicleData!.data!.map((vehicle) {
      return calculateFare(
        distanceInKm: distance,
        vehicleData: vehicle,
      );
    }).toList();
  }

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};


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
    for (int i = 0; i < widget.stopLocations.length; i++) {
      final stop = widget.stopLocations[i];
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {

        //authController.isShowDriver ?

        return
          PopScope(
            canPop: false, // Disables default back navigation
            onPopInvoked: (bool didPop) async {
              if (didPop) return; // Already handled

              // Navigate to HomePage and clear the stack

              if(authController.isShowDriver) {
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false, // Remove all previous routes
              );
              }
              else {
                Get.back();
              }
            },
         child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,

          appBar: AppBar(
            centerTitle: false,
            iconTheme: IconThemeData(color: AppColors.primaryGradient),
            backgroundColor: Colors.transparent,

           // title: Text("Choose Vehicle",style: TextStyle(color: Colors.white),),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.7,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(widget.pickLat, widget.pickLng),
                            zoom: 10.5,
                          ),
                          markers: _markers,
                          polylines: _polylines,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          rotateGesturesEnabled: true,
                          zoomControlsEnabled: true,

                          // Smooth map movement handling
                          onCameraMove: (position) {
                            // Optional: Update marker position during movement if needed
                            // setState(() {
                            //   _currentPosition = position.target;
                            // });
                          },
                          onCameraIdle: () {
                            // Optional: Perform actions when map stops moving
                            // _handleMapIdle();
                          },

                          onMapCreated: (controller) {
                            _mapController = controller;

                            // Improved delayed route drawing
                            Future.delayed(const Duration(milliseconds: 500), () {
                              if (mounted && !_isRouteDrawn) {
                                _getRouteBetweenPoints(
                                  stopLocations: widget.stopLocations,
                                  pickLat: widget.pickLat,
                                  pickLng: widget.pickLng,
                                );
                              }
                            });
                          },
                        ),
                      ),

                      Positioned(
                        bottom: 0, // distance from bottom
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 1,
                                spreadRadius: 1,
                                // offset: Offset(-2, -2), // 👉 ye shadow bottom-right mein dikh raha hai
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                blurRadius: 1,
                                spreadRadius: 1,
                                // offset: Offset(-2, -2), // 👉 ye shadow top-left mein light effect de raha hai
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    // TODO: Navigate to forget password screen
                                    // final result = await Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => LocationPickerTypeAheadPage(isPick: true,)),
                                    // );
                                    //
                                    // if (result != null) {
                                    //
                                    //
                                    //   print("Selected Lat: ${result['lat']}");
                                    //   print("Selected Lng: ${result['lng']}");
                                    //   print("Selected Address: ${result['address']}");
                                    //
                                    //   setState(() {
                                    //     widget.pickLng = result['lng'];
                                    //     widget.pickLat = result['lat'];
                                    //     widget.pickAddress = result['address'];
                                    //
                                    //     // _addMarkers();
                                    //     // _getRouteBetweenPoints(dropLat: widget.dropLat,dropLng: widget.dropLng,pickLat: result['lat'],pickLng: result['lng']);
                                    //   });
                                    // }

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
                                                (authController.getUserName()??"")+"  ,  "+(authController.getUserPhone()??""),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black.withOpacity(0.6)
                                                ),
                                              ),
                                             // Icon(Icons.expand_more,color: AppColors.primaryGradient,)
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

                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(), // अगर ScrollView के अंदर है
                                itemCount: widget.stopLocations.length,
                                itemBuilder: (context, index) {
                                  final stop = widget.stopLocations[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                                Text(
                                                  (widget.senderName[index]!.value.text??"")+"  ,  "+(widget.sendMobile[index]!.value.text??""),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black.withOpacity(0.6)
                                                  ),
                                                ),
                                                //  Icon(Icons.expand_more,color: AppColors.primaryGradient,)
                                              ],
                                            ),
                                            Text(stop["address"]??"Unknow",maxLines: 2,),
                                          ],
                                        ))

                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Total distance  :-'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(widget.distance,maxLines: 2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14
                                    ),),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Expected Time :-'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(widget.expectedTime,maxLines: 2,style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14
                                  ),),
                                ],
                              ),
                             /* Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    // TODO: Navigate to forget password screen
                                    // final result = await Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => LocationPickerTypeAheadPage(isPick: true,)),
                                    // );
                                    //
                                    // if (result != null) {
                                    //
                                    //
                                    //   print("Selected Lat: ${result['lat']}");
                                    //   print("Selected Lng: ${result['lng']}");
                                    //   print("Selected Address: ${result['address']}");
                                    //
                                    //   setState(() {
                                    //     widget.dropLng = result['lng'];
                                    //     widget.dropLat = result['lat'];
                                    //     widget.dropAddress = result['address'];
                                    //
                                    //     // _addMarkers();
                                    //     // _getRouteBetweenPoints(dropLat: result['lat'],dropLng: result['lng'],pickLat: widget.pickLat,pickLng: widget.pickLng);
                                    //   });
                                    // }

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
                                              Text(
                                                (widget.senderName??"")+"  ,  "+(widget.sendMobile??""),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black.withOpacity(0.6)
                                                ),
                                              ),
                                            //  Icon(Icons.expand_more,color: AppColors.primaryGradient,)
                                            ],
                                          ),
                                          Text(widget.dropAddress,maxLines: 2,),
                                        ],
                                      ))

                                    ],
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ),








                /* SizedBox(
                   height: 50,
                   child: ListView.builder(
                     shrinkWrap: true,

                     scrollDirection: Axis.horizontal,
                     itemCount: authController.categoryTypeResponse!=null &&  authController.categoryTypeResponse!.data!=null ? authController.categoryTypeResponse!.data!.length:0,
                     itemBuilder: (context, index) {

                       return InkWell(
                         onTap: (){
                           setState(() {
                             selectIndex = index;
                             authController.getCategoryVehicle(authController.categoryTypeResponse!.data![index].id.toString());
                           });
                         },
                         child: Container(
                           margin: EdgeInsets.symmetric(horizontal: 8),
                           padding: EdgeInsets.symmetric(horizontal: 15),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(4),
                             color: Colors.white,
                             border: Border.all(color: selectIndex == index ? AppColors.primaryGradient:Colors.grey)
                           ),
                           child: Row(
                             children: [
                               Text(authController.categoryTypeResponse!.data![index].name!)
                             ],
                           ),
                         ),
                       );

                   },),
                 ),
            */
                SizedBox(height: 15,),

              authController.isVehicle ? Center(child: CircularProgressIndicator(color: AppColors.primaryGradient,),):
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: authController.vehicleData!=null && authController.vehicleData!.data!=null ? authController.vehicleData!.data!.length:0,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: (context, index) {
                  final double baseFare = cachedFaresAndRates?[index]['totalFare'] ?? 0;
                  final double randomRate = cachedFaresAndRates?[index]['randomRate'] ?? 0;
                  print(baseFare);

                  return  InkWell(
                  onTap: (){
                    setState(() {
                      selectIndex = index;
                    });
                  },
                  child: Container(

                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: selectIndex == index ? AppColors.secondaryGradient: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex:3,
                            child: Image.network("${AppContants.imageURL}uploaded_files/category_img/${authController.vehicleData!.data![index].fileName}",height: 40,)),
                        Expanded(
                            flex:7,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(

                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text("${authController.vehicleData!.data![index].name??""}",style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w700),),
                                    // Text("${authController.vehicleData!.data![index].model??""}",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w400),),
                                      Text("${authController.vehicleData!.data![index].maxLoad??"0"} Kg",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w400),),


                                    ],
                                  ),
                                ),
                                Text("${AppContants.rupessSystem}${baseFare.toStringAsFixed(0)
                                }",style: TextStyle(fontSize: 18,color: AppColors.primaryGradient,fontWeight: FontWeight.w700),),
                              ],
                            ))


                      ],
                    ),

                  ),
                );
              },),


                SizedBox(height: 80,)
              ],
            ),
          ),
           bottomSheet: authController.isShowDriver ?  _buildBottomSheet(authController): Row(
             children: [

               IconButton(onPressed: (){
                 showPaymentBottomSheet(context,setState);

               }, icon: CircleAvatar(
                   backgroundColor: AppColors.secondaryGradient,
                   child: ImageIcon(AssetImage("assets/images/rupess.jpg"),color: Colors.white,size: 40,))),
               Expanded(
                 child: InkWell(
                   onTap: (){
                     var lastHouseNoValue;

                     if (widget.houseNoCt.isNotEmpty) {
                       var lastKey = widget.houseNoCt.keys.last;
                       lastHouseNoValue = widget.houseNoCt[lastKey]?.text;
                     }
                     var lastSenderName;
                     if (widget.senderName.isNotEmpty) {
                       lastSenderName = widget.senderName[widget.senderName.keys.last]?.text;
                     }

                     var lastSendMobile;
                     if (widget.sendMobile.isNotEmpty) {
                       lastSendMobile = widget.sendMobile[widget.sendMobile.keys.last]?.text;
                     }
                     var lastStopLocation;
                     if (widget.stopLocations.isNotEmpty) {
                       lastStopLocation = widget.stopLocations.last;
                     }
                     Map<String, dynamic> bookingData = {
                       'pickAddress': widget.pickAddress,
                       'dropAddress': lastStopLocation["address"],
                      'sendName': lastSenderName,
                       'sendMobile': lastSendMobile,
                       'sendNo': lastSendMobile,
                       'pickLat': widget.pickLat,
                       'pickLng': widget.pickLng,
                       'dropLat': lastStopLocation["address"],
                       'dropLng': lastStopLocation["address"],
                       "rate":(cachedFaresAndRates?[selectIndex]['randomRate'] ?? 0),

                       'distanceInKm': calculateDistanceWithPickup(
                           pickLat:widget.pickLat,
                           pickLng:  widget.pickLng,
                           stops:  widget.stopLocations
                       ),
                       'vehicleData': authController.vehicleData!=null && authController.vehicleData!.data!=null ? authController.vehicleData!.data![selectIndex].toJson():null, // assuming Data has a toJson() method
                       'totalFare': (cachedFaresAndRates?[selectIndex]['totalFare'] ?? 0),
                     };

                     authController.bookingNow(
                         distance: widget.distance,
                         expectedTime: widget.expectedTime,
                         amount: (cachedFaresAndRates?[selectIndex]['totalFare'] ?? 0).toStringAsFixed(0),
                         categoryId: "",
                         categoryName: "",
                         discount: "0",
                         discountPercentage: "0",
                         dropAddress: lastStopLocation["address"],
                         dropAddressHeading: "",
                         dropLat: lastStopLocation["lat"].toString(),
                         dropLong: lastStopLocation["lng"].toString(),
                         paymentType: selectedPayment,
                         pickupAddress: widget.pickAddress,
                         pickupHeading: "",
                         pickupLat: widget.pickLat.toString(),
                         pickupLong: widget.pickLng.toString(),
                         rate: (cachedFaresAndRates?[selectIndex]['randomRate'] ?? 0).toString(),
                         receiverContactNumber: lastSendMobile, receiverName: lastSenderName, stopAddress: lastStopLocation["address"], stopCharge: "",
                         totalAmount: (cachedFaresAndRates?[selectIndex]['totalFare'] ?? 0).toStringAsFixed(0), totalDistance: calculateDistanceWithPickup(
                         pickLat:widget.pickLat,
                         pickLng:  widget.pickLng,
                         stops:  widget.stopLocations
                     ).toStringAsFixed(0), vehicleId: authController.vehicleData!.data![selectIndex].id??"", vehicleImg: authController.vehicleData!.data![selectIndex].fileName??"",
                         vehicleName: authController.vehicleData!.data![selectIndex].name??"");
                     _startTimer();
                     print(bookingData);


                    // Get.to(ReviewBooking(data: bookingData,));
                   },
                   child: Container(height: 45,
                   width: double.infinity,
                     alignment: Alignment.center,
                     margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(4),
                       color: AppColors.secondaryGradient
                     ),
                     child:authController!.isBookingProcess ? SpinKitThreeBounce(color: Colors.white): Text("Process With ${authController.vehicleData!=null && authController.vehicleData!.data!=null ? authController.vehicleData!.data![selectIndex].name!:""}",style: TextStyle(fontSize: 16,color: Colors.white),),
                   ),
                 ),
               ),

               IconButton(onPressed: (){
                 showNoteBottomSheet(context);

               }, icon: CircleAvatar(
                   backgroundColor: AppColors.secondaryGradient,
                   child: Icon(Icons.note_alt_outlined,color: Colors.white,))),
             ],
           ),
               ),
       );},
    );
  }

  void showNoteBottomSheet(BuildContext context) {


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Write your information here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Note can't be empty";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String note = _noteController.text.trim();
                      Navigator.pop(context); // Close BottomSheet
                      // ✅ Save logic here
                      print("Note Saved: $note");
                      // Save to DB / Provider / SharedPreferences etc.
                    }
                  },

                  label: Text("Submit",style: TextStyle(fontSize: 14,color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: AppColors.secondaryGradient,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),

                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPaymentBottomSheet(BuildContext context,  refresh) {


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {



            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Payment Options",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // ✅ Discount Switch (Only if discount available)
                  // if (discountPercentage > 0)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text("Apply ${discountPercentage.toInt()}% Discount"),
                  //       Switch(
                  //         value: isDiscountApplied,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             isDiscountApplied = value;
                  //
                  //             refresh((){});
                  //           });
                  //         },
                  //       )
                  //     ],
                  //   ),

                  // ✅ Final Amount
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text("Total Amount:", style: TextStyle(fontSize: 16)),
                  //     Text(
                  //       "${discountPercentage.toStringAsFixed(2)} %",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: isDiscountApplied ? Colors.green : Colors.black,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  //
                  // SizedBox(height: 20),

                  // ✅ Payment Method Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ChoiceChip(
                        label: Text("Cash"),
                        selected: selectedPayment == "Cash",
                        onSelected: (_) {
                          setState(() => selectedPayment = "Cash");
                        },
                      ),

                      SizedBox(width: 20,),
                      ChoiceChip(
                        label: Text("Online"),
                        selected: selectedPayment == "Online",
                        onSelected: (_) {
                          setState(() => selectedPayment = "Online");
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // ✅ Save Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      print("Selected Payment: $selectedPayment");
                      // print("Discount Applied: $isDiscountApplied");
                      // print("Final Amount: ₹${discountPercentage.toStringAsFixed(2)}");

                      setState((){});
                      // Call your backend/save function here
                    },
                    child: Text("Submit",style: TextStyle(fontSize: 14,color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: AppColors.secondaryGradient,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),

                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildBottomSheet(AuthController authController) {
    return Container(

      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress indicator
          authController.driver==null?  LinearProgressIndicator(
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 4,
          ):SizedBox(),
          const SizedBox(height: 20),

          // Driver info (shown when found)
          if (authController.driver==null || authController.driver!.driverDetails==null) ...[
            const Text(
              'Finding you a driver',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please wait while we connect you with the nearest available driver',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: _progress),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.red,
                      ),
                    ),
                    AnimatedScale(
                      scale: 1 + (1 - value) * 0.05, // slight scale effect
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _format(_remaining),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // const CircularProgressIndicator(),
            const SizedBox(height: 20),
          ] else ...[
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      '${authController.driver!.driverDetails!.firstName}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 5),
                        const Text('4.5 (320 Rides)'),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(Icons.directions_car, color: Colors.amber, size: 16),
                        const SizedBox(width: 5),
                         Text('${authController.driver!.driverDetails!.vehicleNumber??""}'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      AppContants.makePhoneCall(authController.driver!.driverDetails!.contactNumber??"");

                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.phone),
                        ),
                        const SizedBox(height: 5),
                        const Text('Call'),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.message),
                      ),
                      const SizedBox(height: 5),
                       Text('Message'),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.directions_car),
                      ),
                      const SizedBox(height: 5),
                       Text('${authController.driver!.driverDetails!.categoryName}'),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.monitor_weight_outlined),
                      ),
                      const SizedBox(height: 5),
                      Text('${authController.driver!.driverDetails!.weightValue} Kg'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Cancel/Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _driverAccepted ? AppColors.secondaryGradient : Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if(authController.driver!=null){
                  Driver driver = Driver(name: authController.driver!.driverDetails!.firstName!, vehicleType: authController.driver!.driverDetails!.vehicleType!, vehicleName: authController.driver!.driverDetails!.vehicleNumber??"", mobileNumber: authController.driver!.driverDetails!.contactNumber??"",id: authController.driver!.driverDetails!.id??"");
                  authController.getBookingDetails(bookingID: authController.newBookingID,driver: driver,driverLat: authController.driver!.driverDetails!.lat!,driverLng: authController.driver!.driverDetails!.long!);
                }
                else {
                  AppContants.showNoteBottomSheet(context,authController,authController.newBookingID,false,null);
                 // authController.cancelOrder(bookingID: authController.newBookingID,reason: "Timing Issue",comment: "Not Good Service");
                }
              },
              child: authController.isBookingDetails  ? Center(child: CircularProgressIndicator(color: AppColors.primaryGradient,),): Text(
                authController.driver!=null ? 'Track Order' : 'Cancel Ride',
                style: const TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
