import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/screen/home/pick_location.dart';
import 'package:triptoll/screen/home/schedule_delivery_pickup.dart';
// import 'package:triptoll/screen/home/whatsapp_sharelocation.dart';
import 'package:triptoll/util/appColors.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:triptoll/util/appContants.dart';
import 'package:triptoll/util/appImage.dart';
// import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/nav_bar.dart';
import 'notification_screen.dart';

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

  // late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  String currentAddress = "";
  String currentAddress1 = "";
  String currentAddress2 = "";
  String currentAddress3 = "";
  int select = -1;
  double? pickupLat;
  double? pickupLng;
  int activeIndex = 0;


  // void initDeepLinks() async {
  //   _appLinks = AppLinks();
  //   final Uri? initialUri = await _appLinks.getInitialLink();
  //   if (initialUri != null) {
  //     handleUri(initialUri);
  //   }
  //   _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
  //     handleUri(uri);
  //   });
  // }

  // void handleUri(Uri uri) {
  //
  //   print("Full URI: $uri");
  //
  //   double? latitude;
  //   double? longitude;
  //
  //   if (uri.scheme == 'geo') {
  //     final coords = uri.path.split(',');
  //     latitude = double.tryParse(coords[0]);
  //     longitude = double.tryParse(coords[1]);
  //   }
  //
  //   else if (uri.queryParameters.containsKey('q')) {
  //     final coords = uri.queryParameters['q']!.split(',');
  //     latitude = double.tryParse(coords[0]);
  //     longitude = double.tryParse(coords[1]);
  //   }
  //
  //   print("Latitude: $latitude");
  //   print("Longitude: $longitude");
  //
  //   if (latitude != null && longitude != null) {
  //     Get.to(()=> LocationSelectionScreen(lat: latitude,long: longitude,));
  //   }
  // }

  Future<void> logUpdateError(String message) async {
    try {
      await FirebaseFirestore.instance
          .collection("in_app_update_error")
          .add({
        "message": message,
        "time": FieldValue.serverTimestamp(),
        "platform": "android",
      });
    } catch (_) {

    }
  }
  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {

        await InAppUpdate.performImmediateUpdate();
      }

    } catch (e) {
      await logUpdateError(e.toString());
    }
  }
  slider.CarouselSliderController controller = slider.CarouselSliderController();

  final List<String> imageList = [
    'assets/images/bike_slide.jpeg',
    'assets/images/eriksha_slide.jpeg',
    'assets/images/3temo_slide.jpeg',
    'assets/images/tata_ace.jpeg',
    'assets/images/truck.jpeg'
  ];

  double? dropLat;
  double? dropLng;
  AuthController authController = Get.find<AuthController>();
  LatLng? currentLocation;
  GoogleMapController? _mapController;
  Set<Marker> markers = {};


  // 🔸 Jaipur fallback location
  static const String _packageName = "customers.triptoll.in";

  Future<void> _openPlayStore() async {
    final Uri playStoreUrl = Uri.parse(
      "https://play.google.com/store/apps/details?id=$_packageName",
    );

    if (!await launchUrl(
      playStoreUrl,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Play Store open nahi ho paya";
    }
  }



  Timer? _timer;
  checkLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? lang = sharedPreferences.getString("app_language");

    if (lang == null || lang == "English") {
      Get.updateLocale(const Locale('en', 'US'));
      authController.selectedLanguage.value = "English";
    } else if (lang == "தமிழ்" || lang == "Tamil") {
      Get.updateLocale(const Locale('ta', 'IN'));
      authController.selectedLanguage.value = 'தமிழ்';
    }  else if (lang == "हिन्दी" ||lang == "Hindi") {
      Get.updateLocale(const Locale('hi', 'IN'));
      authController.selectedLanguage.value = "Hindi";
    }
    else if (lang == "తెలుగు" || lang == "Telugu") {
      Get.updateLocale(const Locale('te', 'IN'));
      authController.selectedLanguage.value = 'తెలుగు';
    } else if (lang == "বাংলা" || lang == "Bengali") {
      Get.updateLocale(const Locale('bn', 'IN'));
      authController.selectedLanguage.value = 'বাংলা';
    } else {
      // Default fallback
      Get.updateLocale(const Locale('en', 'US'));
      authController.selectedLanguage.value = "English";
    }
  }

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
    await _getAddressFromLatLng(pickupLat!, pickupLng! );
  }
  AppUpdateInfo? _updateInfo;
  void showCancelDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Do you really want to cancel this order?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.find<AuthController>().cancelOrder(
                            bookingID: bookingId,
                            reason: "cancel by customer",
                            comment: "cancelled",
                            isOrder: true,
                          );
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Yes, Cancel',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                          ),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    // initDeepLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdate();
      _setCurrentLocation();
      authController.isBookingProcess = false;
      checkLanguage();
      authController.getDriverFAQ();
      authController.checkTicket({
        "driver_id":authController.getUserID().toString(),
        "user_type":"customer"
      });

      startBookingRefresh();
      _getCurrentLocation();
      Get.snackbar(
        "Booking",
        "Click on schedule delivery button to proceed booking",
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
    stopBookingRefresh();
    _linkSubscription?.cancel();
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
        currentAddress1 = "${place.subLocality}";
        currentAddress2 = "${place.locality}";
        currentAddress3 = "${place.administrativeArea}";

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


  DateTime? selectedDateTimeIos;

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
              // backgroundColor: Colors.white.withOpacity(0.4),
              backgroundColor: Colors.white,
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
                      MaterialPageRoute(builder: (context) => LocationPickerTypeAheadPage(isPick: true,title: "Pick Location",isShare: false,)),
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
                              Text(
                                'Pickup Location'.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.search,color: AppColors.primaryGradient,),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Get.to(const NotificationScreen());
                                    },
                                    child: Icon(Icons.notifications_active,color: AppColors.primaryGradient,),
                                  ),
                                ],
                              ),
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

                        // Positioned(
                        //   bottom: 0, // distance from bottom
                        //   left: 0,
                        //   right: 0,
                        //   child: SizedBox(
                        //     height: 60,
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           InkWell(
                        //             onTap: (){
                        //               setState(() {
                        //                 select = 0;
                        //               });
                        //
                        //               Get.to(LocationPickerTypeAheadPage(isPick: false,pickLng: pickupLng,pickLat: pickupLat,pickAddress: pickController.text,title: "Drop Location",));
                        //             },
                        //             child: Container(
                        //             //  margin: EdgeInsets.only(right: 15),
                        //
                        //               alignment: Alignment.center,
                        //               padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(15),
                        //                 color: Colors.white,
                        //                 boxShadow: [
                        //                   BoxShadow(
                        //                     color: Colors.black.withOpacity(0.35),
                        //                     blurRadius: 1,
                        //                     spreadRadius: 1,
                        //                     // offset: Offset(-2, -2), // 👉 ye shadow bottom-right mein dikh raha hai
                        //                   ),
                        //                   BoxShadow(
                        //                     color: Colors.white.withOpacity(0.8),
                        //                     blurRadius: 1,
                        //                     spreadRadius: 1,
                        //                     // offset: Offset(-2, -2), // 👉 ye shadow top-left mein light effect de raha hai
                        //                   ),
                        //                 ],
                        //               ),
                        //               child: Row(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   Image.asset(AppImage.parcelImage,width: 25,),
                        //                   SizedBox(width: 4,),
                        //                   Text("Delivery",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),)
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //           /*Expanded(
                        //               flex:1,
                        //               child: InkWell(
                        //                 onTap: (){
                        //                   setState(() {
                        //                     select = 1;
                        //                   });
                        //                   Get.to(LocationPickerTypeAheadPage(isPick: false,pickLng: pickupLng,pickLat: pickupLat,pickAddress: pickController.text,title: "Drop Location",));
                        //                 },
                        //                 child: Container(
                        //                   margin: EdgeInsets.only(right: 15),
                        //                   alignment: Alignment.center,
                        //                   padding: EdgeInsets.symmetric(vertical: 5),
                        //                   decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.circular(15),
                        //                     color: Colors.white,
                        //                     boxShadow: [
                        //                       BoxShadow(
                        //                         color: Colors.black.withOpacity(0.35),
                        //                         blurRadius: 1,
                        //                         spreadRadius: 1,
                        //                         // offset: Offset(-2, -2), // 👉 ye shadow bottom-right mein dikh raha hai
                        //                       ),
                        //                       BoxShadow(
                        //                         color: Colors.white.withOpacity(0.8),
                        //                         blurRadius: 1,
                        //                         spreadRadius: 1,
                        //                         // offset: Offset(-2, -2), // 👉 ye shadow top-left mein light effect de raha hai
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   child: Row(
                        //                     mainAxisAlignment: MainAxisAlignment.center,
                        //                     children: [
                        //                       Image.asset(AppImage.logisticImage,width: 25,),
                        //                       SizedBox(width: 4,),
                        //                       Text("Taxi",style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),)
                        //                     ],
                        //                   ),
                        //                 )
                        //               ))*/
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),

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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // InkWell(
                                  //   onTap: (){
                                  //     setState(() {
                                  //       select = 0;
                                  //     });
                                  //
                                  //     Get.to(
                                  //       ScheduleDeliveryPickUpScreen(
                                  //         isShare: false,
                                  //         isPick: true,
                                  //         pickLng: pickupLng,
                                  //         pickLat: pickupLat,
                                  //         houseNumber: currentAddress.toString(),
                                  //         street: currentAddress.toString(),
                                  //         city: currentAddress.toString(),
                                  //         pickAddress: pickController.text,
                                  //         title: "PickUp Location",
                                  //       ),
                                  //     );
                                  //     // Get.to(LocationPickerTypeAheadPage(isShare: false,isPick: false,
                                  //     //   pickLng: pickupLng,pickLat: pickupLat,
                                  //     //   houseNumber: currentAddress.toString(),
                                  //     //   street: currentAddress1.toString(),
                                  //     //   city: currentAddress2.toString(),
                                  //     //   pickAddress: pickController.text,
                                  //     //   title: "Drop Location",));
                                  //   },
                                  //   child: Container(
                                  //     alignment: Alignment.center,
                                  //     padding: EdgeInsets.symmetric(vertical: 7,horizontal: 15),
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(8),
                                  //       color: Colors.white,
                                  //       boxShadow: [
                                  //         BoxShadow(
                                  //           color: Colors.black.withOpacity(0.35),
                                  //           blurRadius: 1,
                                  //           spreadRadius: 1,
                                  //           // offset: Offset(-2, -2), // 👉 ye shadow bottom-right mein dikh raha hai
                                  //         ),
                                  //         BoxShadow(
                                  //           color: Colors.white.withOpacity(0.8),
                                  //           blurRadius: 1,
                                  //           spreadRadius: 1,
                                  //           // offset: Offset(-2, -2), // 👉 ye shadow top-left mein light effect de raha hai
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: [
                                  //         Image.asset(AppImage.parcelImage,width: 25,),
                                  //         SizedBox(width: 4,),
                                  //         Text("Delivery".tr,style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),)
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        select = 0;
                                      });

                                      DateTime? selectedDate = DateTime.now();
                                      TimeOfDay? selectedTime;

                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                        ),
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setModalState) {
                                              return Container(
                                                padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 12,
                                                  bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 20,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                ),
                                                child: SafeArea(
                                                  top: false,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          width: 40,
                                                          height: 4,
                                                          margin: const EdgeInsets.only(bottom: 14),
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey.shade300,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                      ),

                                                      /// 🔹 Title
                                                      const Center(
                                                        child: Text(
                                                          "Delivery",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(height: 20),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            selectedDateTimeIos = null;
                                                          });
                                                          DateTime? picked = await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime.now(),
                                                            lastDate: DateTime.now().add(const Duration(days: 1)), // 🔒 max tomorrow
                                                            builder: (context, child) {
                                                              return Theme(
                                                                data: Theme.of(context).copyWith(
                                                                  colorScheme: const ColorScheme.light(
                                                                    primary: Colors.black,
                                                                    onPrimary: Colors.white,
                                                                    onSurface: Colors.black,
                                                                  ),
                                                                  dialogBackgroundColor: Colors.white,
                                                                ),
                                                                child: child!,
                                                              );
                                                            },
                                                          );

                                                          if (picked != null) {
                                                            setModalState(() {
                                                              selectedDate = picked;
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: Colors.grey.shade300),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              const Icon(Icons.calendar_today, size: 18),
                                                              const SizedBox(width: 10),
                                                              Text(
                                                                selectedDate == null
                                                                    ? "Select Date"
                                                                    : DateFormat('dd MMM yyyy').format(selectedDate!),
                                                                style: const TextStyle(fontSize: 14),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 12),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if(selectedDate == null){
                                                            Get.snackbar(
                                                                "Error",
                                                                "Please select date first",
                                                                backgroundColor: Colors.red,
                                                                colorText: Colors.white
                                                            );
                                                            return;
                                                          }
                                                          else {
                                                            showCupertinoModalPopup(
                                                              context: context,
                                                              builder: (_) {
                                                                DateTime now = DateTime.now();

                                                                DateTime selectedDay = selectedDate ?? now;

                                                                DateTime minTimeToday = now.add(const Duration(minutes: 30));

                                                                DateTime tempDateTime = selectedDateTimeIos ??
                                                                    DateTime(
                                                                      selectedDay.year,
                                                                      selectedDay.month,
                                                                      selectedDay.day,
                                                                      minTimeToday.hour,
                                                                      minTimeToday.minute,
                                                                    );

                                                                bool isToday = isSameDay(selectedDay, now);

                                                                return Container(
                                                                  height: 300,
                                                                  color: Colors.white,
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        alignment: Alignment.centerRight,
                                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                        child: CupertinoButton(
                                                                          padding: EdgeInsets.zero,
                                                                          onPressed: () {
                                                                            setModalState(() {
                                                                              selectedDateTimeIos = tempDateTime;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: const Text(
                                                                            "Done",
                                                                            style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: CupertinoColors.activeBlue,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: CupertinoDatePicker(
                                                                          mode: CupertinoDatePickerMode.time,
                                                                          use24hFormat: false,
                                                                          initialDateTime: tempDateTime,
                                                                          minimumDate: isToday
                                                                              ? DateTime(
                                                                            selectedDay.year,
                                                                            selectedDay.month,
                                                                            selectedDay.day,
                                                                            minTimeToday.hour,
                                                                            minTimeToday.minute,
                                                                          )
                                                                              : null,

                                                                          onDateTimeChanged: (DateTime newTime) {
                                                                            HapticFeedback.selectionClick();

                                                                            tempDateTime = DateTime(
                                                                              selectedDay.year,
                                                                              selectedDay.month,
                                                                              selectedDay.day,
                                                                              newTime.hour,
                                                                              newTime.minute,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );

                                                          }
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: Colors.grey.shade300),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              const Icon(Icons.access_time, size: 18),
                                                              const SizedBox(width: 10),
                                                              Text(
                                                                selectedDateTimeIos == null
                                                                    ? "Select Time"
                                                                    : TimeOfDay.fromDateTime(selectedDateTimeIos!).format(context),
                                                                style: const TextStyle(fontSize: 14),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 14),
                                                      Text('* You can schedule your delivery within the next 24 hours only.'.tr,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500
                                                        ),
                                                      ),
                                                      const SizedBox(height: 24),

                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:ElevatedButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.grey,
                                                                padding: EdgeInsets.symmetric(vertical: 12),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                              ),

                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 12),
                                                          Expanded(
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                if (selectedDate == null || selectedDateTimeIos == null) {
                                                                  Get.snackbar(
                                                                      "Error",
                                                                      "Please select date & time",
                                                                      backgroundColor: Colors.red,
                                                                      colorText: Colors.white
                                                                  );
                                                                  return;
                                                                }

                                                                final selectedDateTime = DateTime(
                                                                  selectedDate!.year,
                                                                  selectedDate!.month,
                                                                  selectedDate!.day,
                                                                  selectedDateTimeIos!.hour,
                                                                  selectedDateTimeIos!.minute,
                                                                );

                                                                final now = DateTime.now();
                                                                final maxTime = now.add(const Duration(hours: 24));

                                                                if (selectedDateTime.isBefore(now)) {
                                                                  Get.snackbar(
                                                                      "Invalid Time",
                                                                      "Please select a future time",
                                                                      backgroundColor: Colors.red,
                                                                      colorText: Colors.white
                                                                  );
                                                                  return;
                                                                }
                                                                if (selectedDateTime.isAfter(maxTime)) {
                                                                  Get.snackbar(
                                                                      "Invalid Schedule",
                                                                      "You can schedule only within next 24 hours",
                                                                      backgroundColor: Colors.red,
                                                                      colorText: Colors.white
                                                                  );
                                                                  return;
                                                                }
                                                                final Duration difference = selectedDateTime.difference(now);

                                                                final int hours = difference.inHours;
                                                                final int minutes = difference.inMinutes.remainder(60);

                                                                // 🔹 PRINT
                                                                print("Scheduled After: $hours hours $minutes minutes");
                                                                Get.back();

                                                                String formattedTime =
                                                                    '${selectedDateTimeIos!.hour.toString().padLeft(2, '0')}:${selectedDateTimeIos!.minute.toString().padLeft(2, '0')}';
                                                                String onlyDate =
                                                                DateFormat('yyyy-MM-dd').format(selectedDate!);

                                                                Get.to(ScheduleDeliveryPickUpScreen(
                                                                  isShare: true,
                                                                  isPick: true,
                                                                  pickLng: pickupLng,
                                                                  pickLat: pickupLat,
                                                                  houseNumber: currentAddress.toString(),
                                                                  street: currentAddress.toString(),
                                                                  city: currentAddress.toString(),
                                                                  pickAddress: pickController.text,
                                                                  title: "PickUp Location",
                                                                  date: onlyDate,
                                                                  time: formattedTime,
                                                                ),
                                                                );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.blue,
                                                                padding: EdgeInsets.symmetric(vertical: 12),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                              ),

                                                              child: const Text(
                                                                "Confirm",
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: 7,horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.35),
                                            blurRadius: 1,
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.8),
                                            blurRadius: 1,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(AppImage.scheduleDelivery,width: 25,),
                                          SizedBox(width: 4,),
                                          Text("Delivery".tr,style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

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
                                        child: Image.asset(
                                          imageList[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      );
                                    },
                                    options: slider.CarouselOptions(
                                      height: 200,
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
            bottomSheet: Get.find<AuthController>().isLoggedIn() &&
                auhController.latestBookingListResponse!=null && auhController.latestBookingListResponse!.isNotEmpty &&  auhController.latestBookingListResponse![0]!.orderStatus.toString().toLowerCase() !="paid" && auhController.latestBookingListResponse![0]!.orderStatus.toString().toLowerCase() !="cancelled" ?
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
                                child: Text("Current Order".tr,style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: auhController.latestBookingListResponse.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(auhController.latestBookingListResponse[index]!.vehicleCategory.toString(),
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 13),),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_on_outlined,color: Colors.green,size: 25,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(auhController
                                                  .latestBookingListResponse[index]!
                                                  .pickup!.address.toString(),
                                                maxLines: 2,
                                                style: TextStyle(fontSize: 13),),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (auhController.latestBookingListResponse[index]!.dropoffs != null && auhController.latestBookingListResponse[index]!.dropoffs!.isNotEmpty)
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount:auhController.latestBookingListResponse[index]!.dropoffs!.length,
                                                itemBuilder: (context, dropIndex) {
                                                  final drop = auhController.latestBookingListResponse[index]!.dropoffs![dropIndex];
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Icon(Icons.location_on_outlined, color: Colors.red, size: 25),
                                                        const SizedBox(width: 5),
                                                        Expanded(
                                                          child: Text(
                                                            drop.address ?? "No drop address",
                                                            maxLines: 2,
                                                            style: const TextStyle(fontSize: 13),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ))

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  auhController.latestBookingListResponse![index]!.driverId!=null && auhController.latestBookingListResponse![index]!.driverId!.isNotEmpty ?
                                  SizedBox.shrink() :
                                  Text('A driver will be assigned to you shortly. Please wait.',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black
                                    ),
                                  ),
                                  if (authController.latestBookingListResponse[index]?.orderStatus == 'new' ||
                                      authController.latestBookingListResponse[index]?.orderStatus == 'scheduled')
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: InkWell(
                                        onTap: () {
                                          showCancelDialog(
                                            context,
                                            authController.latestBookingListResponse[index]!.id.toString(),
                                          );
                                        },
                                        child: Container(
                                          width: Get.width,
                                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            border: Border.all(color: Colors.red),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  auhController.latestBookingListResponse[index]!.driverId!=null && auhController.latestBookingListResponse![index]!.driverId!.isNotEmpty ?

                                  InkWell(
                                    onTap: (){
                                      Get.find<AuthController>().getBookingDriverHome(driverID:auhController.latestBookingListResponse[index]!.driverId.toString(),isCall: true,
                                          bookingID: auhController.latestBookingListResponse[index]!.id.toString());
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
                                            auhController.latestBookingListResponse![index]!.orderStatus.toString().toLowerCase() !="delivered" ?   "Track Order" :
                                            "${'Pay'.tr} ${AppContants.rupessSystem} ${ auhController.latestBookingListResponse![index]!.totalAmount}",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),)),
                                    ),
                                  )
                                      :
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                  //     InkWell(
                                  //       onTap: (){
                                  //         // Get.find<AuthController>().getBookingDriver(bookingID:auhController.latestBookingListResponse![index]!.id.toString(),isCall: true);
                                  //       },
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  //         child: Text("No Driver Assign".tr,style: TextStyle(fontSize: 18,color: AppColors.primaryGradient,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  SizedBox(),
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
