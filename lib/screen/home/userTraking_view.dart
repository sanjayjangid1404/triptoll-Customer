import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
import 'feedback_screen.dart';

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
  AuthController authController = Get.find<AuthController>();
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

  void showWalletPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [

              /// Main Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF1E5BFF),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// Wallet Icon
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E5BFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),

                            /// Title + Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "WALLET",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Pay with wallet & get 10%\nOFF every payment",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E5BFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.info_outline,
                                size: 18, color: Colors.black54),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Discount applied automatically at checkout. ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        (double.parse(widget.bookingID.totalAmount.toString()) <= totalAmount && totalAmount != 0.00) ?
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E5BFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              isChecked = true;
                              originalAmount = double.parse(widget.bookingID.totalAmount.toString());
                              discountedAmount = isChecked
                                  ? originalAmount - (originalAmount * 0.10)
                                  : originalAmount;
                              discountedPercentage = (originalAmount * 10) / 100;
                              print('discount percantage ${discountedPercentage.toString()}');
                              setState(() {

                              });
                            },
                            child: const Text(
                              "Pay With Wallet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ) :
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E5BFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Recharge Wallet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),
                      ],
                    ),

                    /// Best Value Badge
                    Positioned(
                      top: -6,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF8A00),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Best Value",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -15,
                right: -15,
                child: GestureDetector(
                  onTap: () {
                   Get.back();
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1E5BFF),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Color(0xFF1E5BFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
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
      Get.find<AuthController>().getWalletHistory();
      showWalletPopup(context);
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
    _currentDriverLocation = authController.driverCurrentLocation?? widget.driverInitialLocation;

    if(Get.find<AuthController>().detailsResponse!=null) {
      _addMarkers();
    }
  }



  @override
  void dispose() {
    _razorpay.clear();
    _isTracking = false;
    _trackingController.stopTrackingUpdates();
    super.dispose();
  }
  void _addMarkers() {


    print("_currentDriverLocation=>${authController.driverCurrentLocation?? widget.driverInitialLocation}");
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
            position: authController.driverCurrentLocation?? widget.driverInitialLocation!,
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
            position: authController.driverCurrentLocation?? widget.driverInitialLocation!!,
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
  bool isChecked = false;
  double discountedAmount = 0.0;
  double discountedPercentage = 0.0;
  double originalAmount  = 0.0;
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) =>  FeedbackBottomSheet(bookingID: widget.bookingID,),
    );
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

  void _openRazorpayPayment(String id,amount) {

    var options = {
      'key': 'rzp_live_RAJBCQWCkgqpEb',
      'amount': amount, // Convert to paise
      'name': 'Triptoll',
      'description': 'Booking Payment',
      'order_id': id, // custom 8 digit order id
      'prefill': {
        'contact': widget.bookingID.pickup!.contactNumber??"123123123",
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

  Future<String?> createRazorpayOrderId({required int amount}) async {
    const String keyId = 'rzp_live_RAJBCQWCkgqpEb';
    const String keySecret = 'DfWgvxPob2CSxM147onlshnF';

    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$keyId:$keySecret'));

    final url = Uri.parse('https://api.razorpay.com/v1/orders');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth,
      },
      body: jsonEncode({
        "amount": amount,
        "currency": "INR",
        "receipt": "receipt_${DateTime.now().millisecondsSinceEpoch}"
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("data=>$data");

      if(data["id"]!=null){
        _openRazorpayPayment(data['id'].toString(),amount);
      }
      return data['id']; // <-- This is the order_id
    } else {
      print("Failed to create order: ${response.statusCode} ${response.body}");
      return null;
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
        authController.driverCurrentLocation?? widget.driverInitialLocation!,
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
  double totalAmount = 0;
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
          if (authController.walletResponseList.isNotEmpty) {
            totalAmount = authController.walletResponseList
                .map((e) {
              double amount = double.tryParse(e.walletAmount ?? "0") ?? 0;
              return (e.trnType?.toLowerCase() == "debit") ? -amount : amount;
            })
                .reduce((a, b) => a + b);
          }

          if(authController.detailsResponse!=null){
            _addMarkers();
            // _initializeLocations();
            // _startTracking();
          }
          originalAmount = double.parse(widget.bookingID.totalAmount.toString());

          return Scaffold(
              appBar: AppBar(
                leading: IconButton(onPressed: (){

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false, // Remove all previous routes
                  );
                }, icon: Icon(Icons.arrow_back_ios)),
                title: Text("Live Tracking".tr),
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
                                            '${widget.bookingID.name} || ${widget.bookingID!.weight} ${widget.bookingID!.weightType}',
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
                                    widget.bookingID.pickup != null ?
                                    Text(widget.bookingID.pickup!.address??"",maxLines: 2,style: TextStyle(fontSize: 13),) :
                                        SizedBox.shrink()

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
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.bookingID.dropoffs != null ?
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: widget.bookingID.dropoffs!.length,
                                        itemBuilder: (context, dropIndex) {
                                          final drop =  widget.bookingID.dropoffs![dropIndex];
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
                                      ) :
                                    SizedBox.shrink(),

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (double.parse(widget.bookingID.totalAmount.toString()) <= totalAmount && totalAmount != 0.00) ?
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Row(
                  children: [
                    Checkbox(
                      visualDensity: VisualDensity.compact,
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                          originalAmount = double.parse(widget.bookingID.totalAmount.toString());
                          discountedAmount = isChecked
                              ? originalAmount - (originalAmount * 0.10)
                              : originalAmount;
                          discountedPercentage = (originalAmount * 10) / 100;
                          print('discount percantage ${discountedPercentage.toString()}');
                        });
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Wallet Amount".tr,
                          style: TextStyle(fontSize: 16,fontWeight: ui.FontWeight.w500),
                        ),
                        Text(
                          "₹${totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                                ),
                ) : SizedBox.shrink(),
                  InkWell(
                    onTap: (){
                      String randomNumber = "";
                      final random = Random();
                      int number = 10000000 + random.nextInt(90000000);
                      setState(() {
                        randomNumber = number.toString();
                      });
                      isChecked == false ?
                      createRazorpayOrderId(amount: (double.parse(widget.bookingID.totalAmount.toString()) * 100).round()) :
                      Get.find<AuthController>().orderPaymentWithWallet(
                          widget.bookingID!.id.toString(),
                          widget.bookingID!.driverId.toString(),
                          randomNumber.toString(),""
                          "success",
                          context,
                          customOrderId,
                          discountedPercentage.toString(),
                          widget.bookingID.totalAmount.toString(),
                          widget.bookingID.amount.toString()
                          );
                      },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.secondaryGradient,
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: isChecked
                            ? Row(
                          key: ValueKey("discounted"),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${AppContants.rupessSystem} ${originalAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${AppContants.rupessSystem} ${discountedAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "(10% OFF)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.yellow,
                              ),
                            ),
                          ],
                        )
                            : Text(
                          "${'Pay'.tr} ${AppContants.rupessSystem} ${originalAmount.toStringAsFixed(2)}",
                          key: ValueKey("original"),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ):
              InkWell(
                onTap: (){


                  authController.getBookingDriverHome(driverID: widget.bookingID.driverId.toString(),isCall: false,
                      bookingID: widget.bookingID.id.toString());
                  _initializeLocations();

                  _startTracking();
                  },
                child: Container(height: 45,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.secondaryGradient
                  ),
                  child: Text("Track Your Parcel".tr,style: TextStyle(fontSize: 16,color: Colors.white),),
                ),
              )

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