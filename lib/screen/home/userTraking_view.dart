
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:triptoll/model/booking_details_response.dart';
import 'package:triptoll/screen/home/homeview.dart';
import 'package:triptoll/util/appColors.dart';

import 'package:http/http.dart' as http;
import 'package:triptoll/util/appImage.dart';
import '../../controller/authController.dart';
import '../../util/appContants.dart';

class UserTrackingScreen extends StatefulWidget {
  final LatLng bookingLocation;
  final LatLng driverInitialLocation;
  final Driver driver;
   BookingDetailsResponse bookingID;
   String bookingIdNew;

   UserTrackingScreen({
    Key? key,
    required this.bookingLocation,
    required this.driverInitialLocation,
    required this.driver,
    required this.bookingID,
    required this.bookingIdNew,
  }) : super(key: key);

  @override
  _UserTrackingScreenState createState() => _UserTrackingScreenState();
}

class _UserTrackingScreenState extends State<UserTrackingScreen> {
  late GoogleMapController _mapController;
  LatLng? _currentUserLocation;
  LatLng? _currentDriverLocation;
  String customOrderId  = "";
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  late Razorpay _razorpay;
  bool _isTracking = false;
  bool isComplete = false;
  final TrackingController _trackingController = Get.put(TrackingController());
  BitmapDescriptor? _driverIcon;
  int call = 0;


  Future<void> _loadCustomMarker() async {
    _driverIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)), // Adjust size as needed
      AppImage.driverMrkIMage,
    );
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {


      print(jsonEncode(widget.bookingID!));

      print("${widget.driverInitialLocation}");
      customOrderId = generateOrderId();

      setState(() {

      });


      _trackingController.startTrackingUpdates(widget.bookingIdNew.toString());

      _loadCustomMarker();




      if(Get.find<AuthController>().detailsResponse!=null){
        _initializeLocations();
        _startTracking();
      }
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);



      setState(() {

      });

    });


  }

  void _initializeLocations() {
    _currentDriverLocation = widget.driverInitialLocation;

    if(Get.find<AuthController>().detailsResponse!=null) {
      _addMarkers();
    }
  }

  Future<BitmapDescriptor> _loadCustomMarker2() async {
    final ByteData data = await rootBundle.load('assets/images/driver_mark.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: 48); // Resize to 48px width
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ByteData? resizedBytes = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedBytes!.buffer.asUint8List());
  }

  @override
  void dispose() {
    _razorpay.clear();
    _isTracking = false;
    _trackingController.stopTrackingUpdates();
    super.dispose();
  }
  void _addMarkers() {

    if(Get.find<AuthController>().detailsResponse!.startTrip.toString() == "no"){
      _markers = {
        Marker(
          markerId: MarkerId('booking_location'),
          position: LatLng(double.parse(Get.find<AuthController>().detailsResponse!.pickupLat??"0"), double.parse(Get.find<AuthController>().detailsResponse!.pickupLong??"0")),
          infoWindow: InfoWindow(title: 'Pick Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),Marker(
          markerId: MarkerId('drop_location'),
          position: LatLng(double.parse(Get.find<AuthController>().detailsResponse!.dropLat??"0"), double.parse(Get.find<AuthController>().detailsResponse!.dropLong??"0")),
          infoWindow: InfoWindow(title: 'Drop Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        if (_currentDriverLocation != null)
          Marker(
            markerId: const MarkerId('driver_location'),
            position: _currentDriverLocation!,
            infoWindow: const InfoWindow(title: 'Driver'),
            icon: _driverIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange), // Fallback to default if custom icon fails
          ),

      };
    }
    else {
      _markers = {
       Marker(
          markerId: MarkerId('drop_location'),
         position: LatLng(double.parse(Get.find<AuthController>().detailsResponse!.dropLat??"0"), double.parse(Get.find<AuthController>().detailsResponse!.dropLong??"0")),
          infoWindow: InfoWindow(title: 'Drop Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        if (_currentDriverLocation != null)
          Marker(
            markerId: const MarkerId('driver_location'),
            position: _currentDriverLocation!,
            infoWindow: const InfoWindow(title: 'Driver'),
            icon: _driverIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange), // Fallback to default if custom icon fails
          ),

      };
    }

    // if(mounted){
    //   setState(() {
    //     call = 1;
    //   });
    // }

  }

  void isCompleted()async{

   // isComplete = await Get.find<AuthController>().checkBookingComplete(bookingID: widget.bookingID.id.toString());
    setState(() {

    });
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    // Payment success logic
    //Get.snackbar('Success', 'Payment ID: ${response.paymentId}');
    print("✅ Payment Successful!");
    print("Payment ID: ${response.paymentId}");
    print("Order ID: ${response.orderId}");
    print("Signature: ${response.signature}");
    print("Signature: ${response.signature}");

    Get.find<AuthController>().orderPayment(widget.bookingID!.id.toString(),widget.bookingID!.driverId.toString(),response.paymentId.toString(),"success",context,customOrderId);

    // Navigate to success screen or process booking
    // Get.to(ReviewBooking(data: bookingData));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failure logic
  //  Get.snackbar('Error', 'Code: ${response.code} | Message: ${response.message}');
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Transaction Fail',
        onConfirmBtnTap: (){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false, // Remove all previous routes
          );
        }
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet logic
    Get.snackbar('External Wallet', '${response.walletName}');
  }
  String generateOrderId() {
    var random = Random();
    return (10000000 + random.nextInt(90000000)).toString(); // 8 digit random
  }

  void _openRazorpayPayment() {

    var options = {
      'key': 'rzp_live_oG0h8ePD7JSECO',
      'amount': (double.parse(widget.bookingID.totalAmount.toString()) * 100).round(), // Convert to paise
      'name': 'Triptoll',
      'description': 'Booking Payment',
      'order_id': customOrderId, // custom 8 digit order id
      'prefill': {
        'contact': '${widget.bookingID!.contactNumber??"123123123"}',
        'email': 'tritoll@gmail.com'
      },
      'theme': {
        'color': '#FF6B6B' // Your app theme color
      }
    };

    try {
      _razorpay.open(options);

    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _startTracking() async {


    // Get user's current location
    await _updateUserLocation();

    // Simulate driver movement (replace with real API calls)
    _simulateDriverMovement();

    // Update route between driver and booking location
    _updateRoute();
  }

  Future<void> _updateUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentUserLocation = LatLng(position.latitude, position.longitude);
        _addMarkers();
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }


  void _simulateDriverMovement() {
    // In a real app, you would get driver location updates from your backend
    const duration = Duration(seconds: 5);


  }

  Future<void> _updateRoute() async {
    if (_currentDriverLocation == null || widget.bookingLocation == null) {
      print('Missing location data - driver: $_currentDriverLocation, booking: ${widget.bookingLocation}');
      return;
    }

    try {
      print('Fetching route between $_currentDriverLocation and ${widget.bookingLocation}');
      final route = await _getRouteBetweenPoints(
        _currentDriverLocation!,
        widget.bookingLocation!,
      );

      // Validate API response
      if (route == null || route['routes'] == null || route['routes'].isEmpty) {
        throw Exception('No routes found in response');
      }

      final overviewPolyline = route['routes'][0]['overview_polyline'];
      if (overviewPolyline == null) {
        throw Exception('No overview_polyline in route');
      }

      final polylinePoints = overviewPolyline['points'];
      if (polylinePoints == null || polylinePoints.isEmpty) {
        throw Exception('Empty polyline points');
      }

      print('Received polyline points: ${polylinePoints.length} characters');

      // Decode the polyline
      final points = PolylinePoints().decodePolyline(polylinePoints);
      print('Decoded ${points.length} points');

      if (points.isEmpty) {
        throw Exception('No points after decoding');
      }

      final polylineCoordinates = points.map((point) =>
          LatLng(point.latitude, point.longitude)
      ).toList();

      setState(() {
        _polylines = {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
            geodesic: true,
          ),
        };
      });
    } catch (e) {
      print('Error getting route: $e');
      // Fallback to straight line
      setState(() {
        _polylines = {
          Polyline(
            polylineId: PolylineId('route'),
            points: [_currentDriverLocation!, widget.bookingLocation!],
            color: Colors.red,
            width: 3,
            geodesic: true,
          ),
        };
      });
    }
  }

  Future<Map<String, dynamic>> _getRouteBetweenPoints(LatLng origin, LatLng destination) async {
    const apiKey = 'AIzaSyAddnEWMk05vtngwZAc13ub52nY2OIRmWk';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
            'origin=${origin.latitude},${origin.longitude}&'
            'destination=${destination.latitude},${destination.longitude}&'
            'mode=driving&key=$apiKey'
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load directions');
    }
  }

  void _showArrivalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Driver Arrived"),
        content: Text("Your driver has reached the booking location."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false, // Disables default back navigation
      onPopInvoked: (bool didPop) async {
        if (didPop) return; // Already handled

        // Navigate to HomePage and clear the stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false, // Remove all previous routes
        );
      },

      child: GetBuilder<AuthController>(
        builder: (authController) {

          widget.bookingID = authController.detailsResponse??widget.bookingID;


          if(authController.detailsResponse!=null){
            _addMarkers();
            // _initializeLocations();
            // _startTracking();
          }


          return Scaffold(
              appBar: AppBar(
                leading: IconButton(onPressed: (){

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false, // Remove all previous routes
                  );
                }, icon: Icon(Icons.arrow_back_ios)),
                title: Text("Live Tracking"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        isCompleted();
                      });
                    },
                  ),
                ],
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: widget.bookingLocation,
                      zoom: 15,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (controller) => _mapController = controller,
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),

                    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex:2,
                              child:  const CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
                              ),),
                            Expanded(
                                flex:7,
                                child:  Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        '${widget.driver!.name}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${widget.bookingID!.categoryName} || ${widget.bookingID!.weight} ${widget.bookingID!.weightType}',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.grey),
                                          ),

                                          Text(
                                            '${widget.driver!.vehicleName}',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.grey),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                )),

                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: (){
                                    AppContants.makePhoneCall(widget.driver!.mobileNumber??"");
                                  },
                                  child: CircleAvatar(backgroundColor: AppColors.secondaryGradient,
                                    child: Icon(Icons.call_outlined,color: Colors.white,),
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
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
                                Icon(Icons.location_on_outlined,color: Colors.green,size: 25,),
                                SizedBox(width: 5,),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(widget.bookingID!.pickupAddress??"",maxLines: 2,style: TextStyle(fontSize: 13),),
                                  ],
                                ))

                              ],
                            ),
                          ),
                        ),

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
                                Icon(Icons.location_on_outlined,color: Colors.red,size: 25,),
                                SizedBox(width: 5,),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(widget.bookingID!.dropAddress??"",maxLines: 2,style: TextStyle(fontSize: 13),),
                                  ],
                                ))

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              bottomSheet:authController.detailsResponse!=null &&  authController.detailsResponse!.orderStatus.toString().toLowerCase() == "delivered"
            ?
              InkWell(
                onTap: _openRazorpayPayment,
                child: Container(height: 45,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.secondaryGradient
                  ),
                  child: Text("Pay ${AppContants.rupessSystem} ${widget.bookingID.totalAmount}",style: TextStyle(fontSize: 16,color: Colors.white),),
                ),
              ):SizedBox()

          );
            },
      ),
    );
  }


}

class Driver {
  final String name;
  final String id;
  final String vehicleType;
  final String vehicleName;
  final String mobileNumber;

  Driver({
    required this.name,
    required this.id,
    required this.vehicleType,
    required this.vehicleName,
    required this.mobileNumber,
  });
}

class TrackingController extends GetxController {
  Timer? _refreshTimer;

  // Start auto-refresh
  void startTrackingUpdates(String bookingID) {
    _refreshTimer?.cancel(); // Cancel if already running
    Get.find<AuthController>().checkBookingComplete(bookingID: bookingID); // Fetch immediately first
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 10), // Every 10 sec
          (_) => Get.find<AuthController>().checkBookingComplete(bookingID: bookingID),
    );
  }

  // Stop auto-refresh
  void stopTrackingUpdates() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  // Fetch booking details (replace with actual API call)


  @override
  void onClose() {
    stopTrackingUpdates(); // Cleanup when controller is disposed
    super.onClose();
  }
}