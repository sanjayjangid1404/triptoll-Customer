import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_place/google_place.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/screen/home/booking_info.dart';
import 'package:triptoll/screen/home/pick_location.dart';
import 'package:triptoll/screen/home/userTraking_view.dart';
import 'package:triptoll/util/appColors.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:triptoll/util/appContants.dart';
import 'package:triptoll/util/appImage.dart';
import 'package:triptoll/util/custom_snackbar.dart';

import '../../model/booking_list_response.dart';
import '../widget/nav_bar.dart';
import 'feedback_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController pickController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController houseNoCt = TextEditingController();
  TextEditingController senderName = TextEditingController();
  TextEditingController sendMobile = TextEditingController();
  String currentAddress = "";
  int select = -1;
  double? pickupLat;
  double? pickupLng;
  int activeIndex = 0;
  slider.CarouselSliderController controller = slider.CarouselSliderController();

  final List<String> imageList = [
    'assets/images/slider12.png',
    'assets/images/slider13.png',
    'assets/images/slider14.png',

  ];

  double? dropLat;
  double? dropLng;

  LatLng? currentLocation;
  GoogleMapController? _mapController;
   Set<Marker> markers = {};


  // 🔸 Jaipur fallback location



  Timer? _timer;

  void startBookingRefresh() {
    _timer?.cancel(); // Cancel previous timer if exists
    WidgetsBinding.instance.addPostFrameCallback((_) {


      Get.find<AuthController>().latestBooking(status: "all",limit: "1",offset: "10");

      setState(() {

      });

    });
    _timer = Timer.periodic(const Duration(seconds: 10), (_) =>  Get.find<AuthController>().latestBooking(status: "all",limit: "1",offset: "10"));
  }

  void stopBookingRefresh() {
    _timer?.cancel();
    _timer = null;
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {



      startBookingRefresh();
      _getCurrentLocation();
      Get.snackbar(
        "Booking",
        "Click on Delivery button to proceed booking",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 10),
      );
      setState(() {

      });

    });
  }

  @override
  void dispose() {
    stopBookingRefresh(); // Stop when widget is disposed
    super.dispose();
  }

  void _setPosition(LatLng position) {
    setState(() {
      currentLocation = position;
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // ✅ green marker
        ),
      );
    });
  }
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

        // ✅ Add green marker for Jaipur
        markers = {
          Marker(
            markerId: const MarkerId("default_location"),
            position: LatLng(defaultLat, defaultLng),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          )
        };
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
        currentAddress = "${place.name}";

        // ✅ Add green marker for current location
        markers = {
          Marker(
            markerId: const MarkerId("current_location"),
            position: LatLng(pickupLat!, pickupLng!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          )
        };
      });
    } catch (e) {
      setDefaultLocation();
    }
  }





  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            "${place.name}, ${place.subLocality}, ${place.locality}, ${place.country}";
        setState(() {
          pickController.text = address;
        });
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
  }

  Future<void> _getCurrentLocation2() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      _getAddressFromLatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(currentLocation!),
    );


  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (auhController) =>
       Scaffold(
        key: _scaffoldKey,
        backgroundColor:Colors.white,
        extendBodyBehindAppBar: true,

        appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.4),
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.all(2.0),
            //     child: Image.asset(AppImage.splashLogo),
            //   ),
            //
            //   SizedBox(width: 10,)
            // ],
            leading: IconButton(onPressed: (){

              _scaffoldKey.currentState?.openDrawer();
            },
                icon: CircleAvatar(
                    backgroundColor: AppColors.primaryGradient,
                    child: ImageIcon(AssetImage(AppImage.menuImage,),color: Colors.white,))),
            title:Padding(
              padding: const EdgeInsets.only(left: 0.0,right: 8,top: 0),
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationPickerTypeAheadPage(isPick: true,title: "Pick Location",)),
                  );

                  if (result != null) {


                    print("Selected Lat: ${result['lat']}");
                    print("Selected Lng: ${result['lng']}");
                    print("Selected Address: ${result['address']}");

                    setState(() {
                      pickupLng = result['lng'];
                      pickupLat = result['lat'];
                      pickController.text = result['address'];
                    });
                  }

                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

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
                            Icon(Icons.search,color: AppColors.primaryGradient,)
                          ],
                        ),
                        Text(pickController.text,maxLines: 2,style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6)),),
                      ],
                    ))

                  ],
                ),
              ),
            ),
        ),
        drawer: NavBar(),

        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: AppColors.secondaryGradient.withOpacity(0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.6,
          
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    currentLocation == null
                        ? const Center(child: CircularProgressIndicator())
                        : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: currentLocation ?? const LatLng(0, 0), // fallback for null
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("moving_marker"),
                          position: currentLocation ?? const LatLng(0, 0),
          
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                          anchor: const Offset(0.5, 0.5), // Center the marker
                        ),
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      onMapCreated: (controller) {
                        _mapController = controller;
                        // Optional: Animate to current location when map loads
                        if (currentLocation != null) {
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLng(currentLocation!),
                          );
                        }
                      },
                      onCameraMove: (CameraPosition position) {
                        // Update marker position smoothly during movement
                        setState(() {
                          currentLocation = position.target;
                        });
                      },
                      onCameraIdle: () {
                        // Final position after movement stops
                        if (currentLocation != null) {
                          setState(() {
                            pickupLat = currentLocation!.latitude;
                            pickupLng = currentLocation!.longitude;
                          });
                          _getAddressFromLatLng(pickupLat!, pickupLng!);
                        }
                      },
                    ),
                    Positioned(
                      bottom: 50,
                      right: 20,
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
                      bottom: 0, // distance from bottom
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    select = 0;
                                  });

                                  Get.to(LocationPickerTypeAheadPage(isPick: false,pickLng: pickupLng,pickLat: pickupLat,pickAddress: pickController.text,title: "Drop Location",));
                                },
                                child: Container(
                                //  margin: EdgeInsets.only(right: 15),

                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(AppImage.parcelImage,width: 25,),
                                      SizedBox(width: 4,),
                                      Text("Delivery",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ),
                              ),
                              /*Expanded(
                                  flex:1,
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        select = 1;
                                      });
                                      Get.to(LocationPickerTypeAheadPage(isPick: false,pickLng: pickupLng,pickLat: pickupLat,pickAddress: pickController.text,title: "Drop Location",));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 15),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: 5),
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(AppImage.logisticImage,width: 25,),
                                          SizedBox(width: 4,),
                                          Text("Taxi",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    )
                                  ))*/
                            ],
                          ),
                        ),
                      ),
                    ),
          
                    /*Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 8,top: 25),
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
                              pickupLng = result['lng'];
                              pickupLat = result['lat'];
                              pickController.text = result['address'];
                            });
                          }
          
                        },
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white
                          ),
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
                                  Text(pickController.text,maxLines: 2,),
                                ],
                              ))
          
                            ],
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Current Location
          
          
                       /* Row(
                          children: [
                            Text("Hello",style: TextStyle(fontSize: 22,color: AppColors.primaryGradient),),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text("${auhController.getUserName()}",style: TextStyle(fontSize: 22,color: AppColors.secondaryGradient),),
                            ),
          
                          ],
                        ),*/
          
                        const SizedBox(height: 0),
          
                        // Pickup Location
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
          
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
          
                              slider. CarouselSlider.builder(
                                carouselController: controller,
                                itemCount: imageList.length,
          
                                itemBuilder: (context, index, realIndex) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(imageList[index], fit: BoxFit.contain,width: double.infinity,),
                                  );
                                },
                                options: slider.CarouselOptions(
                                  height: 185,
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) => setState(() => activeIndex = index),
                                ),
                              ),
          
                              const SizedBox(height: 16),
                              Center(
                                child: AnimatedSmoothIndicator(
                                  activeIndex: activeIndex,
                                  count: imageList.length,
                                  effect:  ExpandingDotsEffect(
                                    activeDotColor: AppColors.primaryGradient,
                                    dotHeight: 5,
                                    dotWidth: 5,
                                  ),
                                  onDotClicked: (index) => controller.animateToPage(index),
                                ),
                              ),
          
                              /*const SizedBox(height: 8),
                              Padding(
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
                                        pickupLng = result['lng'];
                                        pickupLat = result['lat'];
                                        pickController.text = result['address'];
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
                                          Text(pickController.text,maxLines: 2,),
                                        ],
                                      ))
          
                                    ],
                                  ),
                                ),
                              ),
                          */
          
                              //SizedBox(height: 20,),
          
          
          
                              SizedBox(height: 20,),
          
                          //    const SizedBox(height: 24),
          
                              // Drop Location
          
          
          
                            //  const SizedBox(height: 8),
                             /* Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    // TODO: Navigate to forget password screen
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LocationPickerTypeAheadPage()),
                                    );
          
                                    if (result != null) {
          
          
                                      print("Selected Lat: ${result['lat']}");
                                      print("Selected Lng: ${result['lng']}");
                                      print("Selected Address: ${result['address']}");
          
                                      setState(() {
                                        dropLng = result['lng'];
                                        dropLat = result['lat'];
                                        dropController.text = result['address'];
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
                                          Text(dropController.text,maxLines: 2,),
                                        ],
                                      ))
          
                                    ],
                                  ),
                                ),
                              ),
          
          
                              SizedBox(height: 10,),*/
          
          
          
          
          
                              // SizedBox(height: 20,),
                              //
                              // Row(
                              //   children: [
                              //     Expanded(
                              //         flex:1,
                              //         child: InkWell(
                              //           onTap: (){
                              //             setState(() {
                              //               select = 0;
                              //             });
                              //           },
                              //           child: Container(
                              //             margin: EdgeInsets.symmetric(horizontal: 15),
                              //             alignment: Alignment.center,
                              //             padding: EdgeInsets.symmetric(vertical: 6),
                              //             decoration: BoxDecoration(
                              //               borderRadius: BorderRadius.circular(4),
                              //               border: Border.all(
                              //                 color: select ==0 ? AppColors.primaryGradient:Colors.grey,
                              //                 width: 0.8
                              //               )
                              //             ),
                              //             child: Row(
                              //               mainAxisAlignment: MainAxisAlignment.center,
                              //               children: [
                              //                 ImageIcon(AssetImage(AppImage.parcelImage),color: select ==0 ? AppColors.secondaryGradient:Colors.grey,),
                              //                 SizedBox(width: 4,),
                              //                 Text("Parcel",style: TextStyle(fontSize: 14,color: Colors.black),)
                              //               ],
                              //             ),
                              //           ),
                              //         )),
                              //     Expanded(
                              //         flex:1,
                              //         child: InkWell(
                              //           onTap: (){
                              //             setState(() {
                              //               select = 1;
                              //             });
                              //           },
                              //           child: Container(
                              //             margin: EdgeInsets.symmetric(horizontal: 15),
                              //             alignment: Alignment.center,
                              //             padding: EdgeInsets.symmetric(vertical: 6),
                              //             decoration: BoxDecoration(
                              //                 borderRadius: BorderRadius.circular(4),
                              //                 border: Border.all(
                              //                     color: select ==1 ? AppColors.primaryGradient:Colors.grey,
                              //                     width: 0.8
                              //                 )
                              //             ),
                              //             child: Row(
                              //               mainAxisAlignment: MainAxisAlignment.center,
                              //               children: [
                              //                 ImageIcon(AssetImage(AppImage.logisticImage),color: select ==1 ? AppColors.secondaryGradient:Colors.grey,),
                              //                 SizedBox(width: 4,),
                              //                 Text("Transport",style: TextStyle(fontSize: 14,color: Colors.black),)
                              //               ],
                              //             ),
                              //           ),
                              //         ))
                              //   ],
                              // ),
                             /* const SizedBox(height: 32),
          
                              InkWell(
                                onTap: (){
                                  if(pickController.text.isEmpty){
                                    showCustomSnackBar("Select Pick Location");
                                  }
                                  else if(dropController.text.isEmpty){
                                    showCustomSnackBar("Select drop Location");
                                  }else {
                                   // Get.to(LocationPickerTypeAheadPage());
                                    Get.to(BookingInfo(dropAddress: dropController.text,dropLat: dropLat!,dropLng: dropLng!,pickAddress: pickController.text,pickLat: pickupLat!,pickLng: pickupLng!));
          
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.secondaryGradient
                                  ),
                                  child: Text("Next",style: TextStyle(fontSize: 18,color: Colors.white),),
                                ),
                              )*/
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
         bottomSheet:auhController.latestBookingListResponse!=null && auhController.latestBookingListResponse!.isNotEmpty &&  auhController.latestBookingListResponse![0]!.orderStatus.toString().toLowerCase() !="paid" && auhController.latestBookingListResponse![0]!.orderStatus.toString().toLowerCase() !="cancelled" ?
         Container(
           padding: const EdgeInsets.only(top: 20),
           // Space for the drag handle
           margin: EdgeInsets.symmetric(horizontal: 10),

           decoration:  BoxDecoration(
             color: Colors.white,
             border: Border.all(color: AppColors.primaryGradient),
             borderRadius: BorderRadius.only(
               topLeft: Radius.circular(20),
               topRight: Radius.circular(20),
             ),
           ),
           child: DraggableScrollableSheet(
             expand: false,
             shouldCloseOnMinExtent: false,

             initialChildSize: 0.2, // Initial height (40% of screen)
             minChildSize: 0.2, // Minimum height when dragged down
             maxChildSize: 0.6, // Maximum height when dragged up
             builder: (context, scrollController) {
               return SingleChildScrollView(
                 controller: scrollController,
                 child: ConstrainedBox(
                     constraints: BoxConstraints(
                       minHeight: MediaQuery.of(context).size.height * 0.2, // Match minChildSize
                     ),child: Container(


                   padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),



                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.only(topRight: Radius.circular(6),topLeft: Radius.circular(6)),

                     color:Colors.white,
                     boxShadow: [
                       BoxShadow(
                         color: AppColors.primaryGradient.withOpacity(0.1), // Very light grey
                         blurRadius: 20.0,
                         spreadRadius: 8.0,
                         offset: Offset(0, 5),),
                       BoxShadow(
                         color: AppColors.secondaryGradient.withOpacity(0.9), // Inner white glow
                         blurRadius: 10.0,
                         spreadRadius: -5.0, // Negative spread for inner effect
                         offset: Offset(0, 0),
                       ),
                     ],

                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                         child: Align(
                             alignment: Alignment.centerLeft,
                             child: Text("Current Order",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                       ),

                       ListView.builder(
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         itemCount: auhController.latestBookingListResponse!.length,
                         itemBuilder: (context, index) {
                         return Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             SizedBox(height: 10,),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 4),
                               child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Icon(Icons.location_on_outlined,color: Colors.green,size: 25,),
                                   SizedBox(width: 5,),
                                   Expanded(child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [

                                       Text(auhController.latestBookingListResponse![index]!.pickupAddress!,maxLines: 2,style: TextStyle(fontSize: 13),),
                                     ],
                                   ))

                                 ],
                               ),
                             ),

                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 0.0),
                               child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Icon(Icons.location_on_outlined,color: Colors.red,size: 25,),
                                   SizedBox(width: 5,),
                                   Expanded(child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [

                                       Text(auhController.latestBookingListResponse![index]!.dropAddress!,maxLines: 2,style: TextStyle(fontSize: 13),),
                                     ],
                                   ))

                                 ],
                               ),
                             ),

                             auhController.latestBookingListResponse![index]!.driverId!=null && auhController.latestBookingListResponse![index]!.driverId!.isNotEmpty ?

                                 InkWell(
                                   onTap: (){
                                     Get.find<AuthController>().getBookingDriver(bookingID:auhController.latestBookingListResponse![index]!.id.toString(),isCall: true);
                                   },
                                   child: Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                                     child: Container(
                                       width:double.infinity,
                                         height:35,
                                         alignment:Alignment.center,

                                         decoration:BoxDecoration(
                                           color: AppColors.secondaryGradient,
                                           borderRadius: BorderRadius.circular(10)
                                         ),
                                         child: Text(
                                           auhController.latestBookingListResponse![0]!.orderStatus.toString().toLowerCase() !="delivered" ?   "Track Order" :
                                           "Pay ${AppContants.rupessSystem} ${ auhController.latestBookingListResponse![0]!.totalAmount}",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),)),
                                   ),
                                 )
                              :
                             Row(
                               mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 InkWell(
                                   onTap: (){
                                     // Get.find<AuthController>().getBookingDriver(bookingID:auhController.latestBookingListResponse![index]!.id.toString(),isCall: true);
                                   },
                                   child: Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                     child: Text("No Driver Assign",style: TextStyle(fontSize: 18,color: AppColors.primaryGradient,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                                   ),
                                 )
                               ],
                             ),
                             SizedBox(height: 10,),
                           ],
                         );
                       },)
                     ],
                   ),
                 )),
               );
             },
           ),

         ):SizedBox(),
      ),
    );
  }

}

