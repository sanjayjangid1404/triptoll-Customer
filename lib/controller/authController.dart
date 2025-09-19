import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triptoll/auth/loginView.dart';
import 'package:triptoll/model/booking_details_response.dart';
import 'package:triptoll/model/booking_list_response.dart';
import 'package:triptoll/model/bookingdriver_response.dart';
import 'package:triptoll/screen/home/homeview.dart';

import '../api/api_checker.dart';

import '../model/category_type_response.dart';
import '../model/faq_model.dart';
import '../model/faq_response_model.dart';
import '../model/subCategoryVehicle.dart';
import '../model/vehicle_data.dart';
import '../repo/auth_repo.dart';
import '../screen/home/userTraking_view.dart';
import '../util/appContants.dart';
import '../util/custom_snackbar.dart';
import '../util/route_helper.dart';


class AuthController extends GetxController implements GetxService
{

  AuthRepo authRepo;

  AuthController({required this.authRepo});
  bool isLoading = false;
  bool isBookingProcess = false;
  bool isShowDriver = false;
  File? _image;
  String _verificationCode = '';
  CategoryTypeResponse? categoryTypeResponse = CategoryTypeResponse();
  SubCategoryVehicle? subCategoryVehicle = SubCategoryVehicle();
  BookingDetailsResponse? bookingDetailsResponse = BookingDetailsResponse();
  List<BookingListResponse?> bookingListResponse = [];
  List<BookingListResponse?> latestBookingListResponse = [];
  List<FaqModel?> faqLIstResponse = [];
  VehicleData? vehicleData = VehicleData();
  int? getIndex;
  List<String>banners = ["https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FLifetime-Family-Plan-offer-slider.1c6725bf.webp&w=3840&q=75",
    "https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FFree-Car-Care-Kit.46a9b3ee.webp&w=3840&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FTitanium-Family-Plan.d35e75e6.webp&w=3840&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FPlatinum-Family-Plan.2eb81b06.webp&w=3840&q=75"];
  int currentIndex = 0;
  bool isVehicle = false;
  String newBookingID = "";


  String _email = '';
  String get verificationCode => _verificationCode;
  String get email => _email;

  File? get image =>_image;

  List<FaqDriverResponse>faqDriverResponse = [];
  RxBool isDataLoading = false.obs;
  Future<void>getDriverFAQ()
  async {

    // isUploading = true;





    Response response = await authRepo.driverFAQ();
    faqDriverResponse = [];

    //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {


      for(int i=0; i<response.body.length; i++){
        faqDriverResponse.add(FaqDriverResponse.fromJson(response.body[i]));
        isDataLoading.value = true;
      }


      update();









    }
    else {


    }

    // isUploading = false;
    // Globs.hideHUD();
    update();



  }
  Future<void>ticketRez(body)
  async {

    Response response = await authRepo.ticketRez(body);

    //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {

      showCustomSnackBar("Ticket raise successfully",isError: false);

      Get.back();
    }
    else {


    }

    update();



  }



  @override
  void onInit() {
  //  startBookingRefresh();
    super.onInit();
  }

  Timer? _timer;

  void startBookingRefresh() {
    // Cancel any existing timer to avoid duplicates
    _timer?.cancel();

    // Fetch immediately first
    latestBooking(status: "all", limit: "1", offset: "10");

    // Then refresh every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      latestBooking(status: "all", limit: "1", offset: "10");
    });
  }

  void stopBookingRefresh() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onClose() {
   // stopBookingRefresh(); // Cancel timer when controller is disposed
    super.onClose();
  }
  updateGetIndex(int index){
    getIndex = index;
    update();
  }
  void setCurrentIndex(int index, bool notify) {
    currentIndex = index;
    if(notify) {
      update();
    }
  }
  Future<void>loginFunction(String email,String password)
  async {

    isLoading = true;

    update();
    print(getUserDeviceID());

    String? token;



    if(Platform.isAndroid)
    {
      token =  await FirebaseMessaging.instance.getToken();
    }
    else
    {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }

    Response response = await authRepo.login(phone: email,password:
    password,token: token);

  //  LoginResponse? loginResponse;

    if(response.statusCode== 200 || response.statusCode ==400)
    {
      if(response.body["status"].toString() == "false"){
        showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: true);
      }else{
        showCustomSnackBar(response.body["msg"], getXSnackBar: false,isError: false);
        // loginResponse = LoginResponse.fromJson(response.body);
        // _lResponse = LoginResponse.fromJson(response.body);
        authRepo.saveUserToken(response.body['token']);
        authRepo.saveUserName(response.body['name']);
        authRepo.saveUserEmail(response.body['email']);
        authRepo.saveUserPhone(response.body['contact_number']);
        // authRepo.saveUserPassword(password);
        authRepo.saveUserId(response.body['id'].toString());
        // if(response.body["success"]) {
        //   showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: false);
        // }
        Get.offAllNamed(RouteHelper.getHomeView());


        _image = null;
      }

    }
    else {
      showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: true);
      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isLoading = false;
    update();



  }


  Future<void>getCategoryType()
  async {

    isLoading = true;

    update();
    print(getUserDeviceID());

    categoryTypeResponse = null;
    newBookingID = "";



    Response response = await authRepo.getCategoryTYPE();

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {

      isShowDriver = false;
      categoryTypeResponse = CategoryTypeResponse.fromJson(response.body);

      if(categoryTypeResponse!=null && categoryTypeResponse!.data!=null && categoryTypeResponse!.data!.isNotEmpty){
        getCategoryVehicle(categoryTypeResponse!.data![0].id.toString());


      }


      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isLoading = false;
    update();



  }

  String? activeBookingID;
  Future<void>bookingNow({
    required String amount,
    required String categoryId,
    required String categoryName,
    required String expectedTime,
    required String discount,
    required String discountPercentage,
    required String dropAddress,
    required String dropAddressHeading,
    required String dropLat,
    required String dropLong,
    required String paymentType,
    required String pickupAddress,
    required String pickupHeading,
    required String pickupLat,
    required String pickupLong,
    required String rate,
    required String receiverContactNumber,
    required String receiverName,

    required String stopAddress,
    required String stopCharge,
    required String totalAmount,
    required String totalDistance,
    required String vehicleId,
    required String vehicleImg,
    required String vehicleName,
    required String distance,
  })
  async {

    isBookingProcess = true;
    isShowDriver = false;

    update();
    print(getUserDeviceID());





    Response response = await authRepo.bookNow(distance: distance,expectedTime: expectedTime,amount: amount, categoryId: categoryId, categoryName: categoryName, cusId: getUserID()??"", discount: discount, discountPercentage: discountPercentage, dropAddress: dropAddress, dropAddressHeading: dropAddressHeading, dropLat: dropLat, dropLong: dropLong, paymentType: paymentType, pickupAddress: pickupAddress, pickupHeading: pickupHeading, pickupLat: pickupLat, pickupLong: pickupLong, rate: rate, receiverContactNumber: receiverContactNumber, receiverName: receiverName, senderContactNumber: getUserPhone()??"", senderName: getUserName()??"", stopAddress: stopAddress, stopCharge: stopCharge, totalAmount: totalAmount, totalDistance: totalDistance, vehicleId: vehicleId, vehicleImg: vehicleImg, vehicleName: vehicleName);

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {
      isShowDriver = true;

      showCustomSnackBar("Booking Process", isError: false);

      String newId = response.body["id"].toString();

      // सिर्फ तब update करना है जब नई ID आए
      if (activeBookingID != newId) {
        activeBookingID = newId;
        newBookingID = newId;
        notifyDriver(newBookingID);
      }

      // सिर्फ activeBookingID वाली call ही चलानी है
      getBookingDriver(bookingID: activeBookingID);



      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isBookingProcess = false;
    update();



  }

  Future<void>getCategoryVehicle(String id)
  async {

    isVehicle = true;

    update();
    print(getUserDeviceID());
    subCategoryVehicle = null;



    Response response = await authRepo.getCategorySub(id);

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {

      subCategoryVehicle = SubCategoryVehicle.fromJson(response.body);

      isVehicle = false;
      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isVehicle = false;
    update();



  }

  Future<void>notifyDriver(String id)
  async {

    isVehicle = true;

    update();
    print(getUserDeviceID());
    subCategoryVehicle = null;



    Response response = await authRepo.notifyDriver(id);

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {

      subCategoryVehicle = SubCategoryVehicle.fromJson(response.body);

      isVehicle = false;
      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isVehicle = false;
    update();



  }

  bool isRegistration = false;
  Future<void>createCustomer(body)
  async {

    isRegistration = true;

    update();

    String? token;



    if(Platform.isAndroid)
    {
      token =  await FirebaseMessaging.instance.getToken();
    }
    else
    {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }

    body.addAll({
      "device_token":token.toString()
    });


    Response response = await authRepo.createCustomer(body);

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {
      if(response.body["status"].toString() == "false"){
        showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: true);
      }else{
        showCustomSnackBar(response.body["msg"], getXSnackBar: false,isError: false);
        // loginResponse = LoginResponse.fromJson(response.body);
        // _lResponse = LoginResponse.fromJson(response.body);
        authRepo.saveUserToken(response.body['token']);
        authRepo.saveUserName(response.body['name']);
        authRepo.saveUserEmail(response.body['email']??"");
        authRepo.saveUserPhone(response.body['contact_number']);
        // authRepo.saveUserPassword(password);
        authRepo.saveUserId(response.body['id'].toString());
        // if(response.body["success"]) {
        //   showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: false);
        // }
        Get.offAllNamed(RouteHelper.getHomeView());
      }

      update();
    }
    else {




      ApiChecker.checkApi(response);




    }

    isRegistration = false;
    update();



  }

  Future<void>updatePassword(body)
  async {

    isRegistration = true;

    update();



    Response response = await authRepo.updatePassword(body);

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {

      showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: false);


      Get.offAll(LoginView());

      update();
    }
    else {




      ApiChecker.checkApi(response);




    }

    isRegistration = false;
    update();



  }

  Future<dynamic>forgetPassword(body)
  async {

    isRegistration = true;

    update();

    String? token;


    Response response = await authRepo.forgetPassword(body);

  //  LoginResponse? loginResponse;

    print(response.body);

    if(response.statusCode==200 || response.statusCode ==400)
    {


      update();
      isRegistration = false;
      return response.body;

    }
    else {




      ApiChecker.checkApi(response);
      isRegistration = false;
      update();

      return null;

    }





  }
  Future<dynamic>feedBackFun({rating, feedback, driverId, bookingId, userID}) async {

    update();
    Response response = await authRepo.feedBackDriver(userID: userID,bookingId: bookingId,driverId: driverId,feedback: feedback,rating:rating );

    print(response.body);

    if(response.statusCode==200 || response.statusCode ==400)
    {
      update();
      showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: true);
      return response.body;

    }
    else {
      ApiChecker.checkApi(response);
      isRegistration = false;
      update();

      return null;

    }





  }

  Future<void>orderPayment(String id,String driverID,String key,String status,BuildContext context,String orderID)
  async {

    isVehicle = true;

    update();
    print(getUserDeviceID());
    subCategoryVehicle = null;



    Response response = await authRepo.orderPayment(id: id,status: status,driverID: driverID,key: key,orderID: orderID);

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {

      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Transaction Completed Successfully!',
          onConfirmBtnTap: (){
            Get.offAll(HomePage());
          }
      );

      // subCategoryVehicle = SubCategoryVehicle.fromJson(response.body);
      //
      // isVehicle = false;
      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isVehicle = false;
    update();



  }

  List<Map<String, double>>? cachedFaresAndRates = [];
  Future<void>getAllVehicleData()
  async {

    isVehicle = true;

    update();
    print(getUserDeviceID());



    vehicleData = null;
    newBookingID ='';
    Response response = await authRepo.getAllVehicle();



    if(response.statusCode==200 || response.statusCode ==400)
    {
      isShowDriver = false;

      vehicleData = VehicleData.fromJson(response.body);

      isVehicle = false;
      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isVehicle = false;
    update();



  }


  bool getAllBookingLoading = false;


  Future<void>getAllBooking({String? status,String? limit,String? offset})
  async {

    getAllBookingLoading = true;

    update();
    print(getUserDeviceID());



   // vehicleData = null;
    Response response = await authRepo.getAllBooking(status: status,limit: limit,offset: offset,userID: getUserID());



    bookingListResponse = [];
    if(response.statusCode==200 || response.statusCode ==400)
    {


      for(int i=0; i<response.body.length; i++){
        bookingListResponse.add( BookingListResponse.fromJson(response.body[i]));
      }



     // getAllBookingLoading = false;
      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    getAllBookingLoading = false;
    update();



  }

  Future<void>latestBooking({String? status,String? limit,String? offset})
  async {

    getAllBookingLoading = true;

    update();
    print(getUserDeviceID());

    if(getUserID()!=null && getUserID()!.isNotEmpty){
      Response response = await authRepo.getRunningBooking(status: status,limit: limit,offset: offset,userID: getUserID());



      latestBookingListResponse = [];
      if(response.statusCode==200 || response.statusCode ==400)
      {


        if(response.body["orders"]!=null) {
          for (int i = 0; i < response.body["orders"].length; i++) {
            latestBookingListResponse.add(
                BookingListResponse.fromJson(response.body["orders"][i]));
          }
        }

        // getAllBookingLoading = false;
        update();
      }
      else {


        // dynamic data = jsonDecode(response.body);

        ApiChecker.checkApi(response);




      }

      getAllBookingLoading = false;
      update();

    }

   // vehicleData = null;



  }

  Future<void>checkPayment({String? status})
  async {


    update();
    print(getUserDeviceID());

   // vehicleData = null;
    Response response = await authRepo.checkPayment(bookingID: status);




    if(response.statusCode==200 || response.statusCode ==400)
    {

     // getAllBookingLoading = false;
      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    getAllBookingLoading = false;
    update();



  }

  Future<void>cancelOrder({String? bookingID,String? reason,String? comment,bool? isOrder})
  async {


    update();
    print(getUserDeviceID());

   // vehicleData = null;
    Response response = await authRepo.cancelOrder(bookingID: bookingID,userID: getUserDeviceID(),comment: comment,reason: reason);




    if(response.statusCode==200 || response.statusCode ==400)
    {

     // getAllBookingLoading = false;

      if(isOrder!){
        getAllBooking(status: "all",limit: "10");
        Get.back();
      }
      else {
        Get.offAll(HomePage());
      }

      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    getAllBookingLoading = false;
    update();



  }

  bool isBookingDetails = false;
  Future<void>getBookingDetails({String? bookingID,String? driverLat,String? driverLng,Driver? driver})
  async {

    isBookingDetails = true;

    update();
    print(getUserDeviceID());
    bookingDetailsResponse = null;



   // vehicleData = null;
    Response response = await authRepo.getBookingDetails(bookingID: bookingID,userID: getUserID());



    print('::::::::::${response.body.toString()}');
    if(response.statusCode==200 || response.statusCode ==400)
    {


      bookingDetailsResponse = BookingDetailsResponse.fromJson(response.body);

      if(driverLat!=null && driverLat!.isNotEmpty && driverLng!=null && driverLng!.isNotEmpty && bookingDetailsResponse!=null){



        print("driverLat!=>$driverLat!");
        print("driverLng!=>$driverLng!");
        print("driverLng!=>${bookingDetailsResponse!.startTrip}!");
        if(bookingDetailsResponse!.startTrip.toString().toLowerCase() == "yes"){
          Get.to(UserTrackingScreen(
              driver: driver!,
              bookingID: bookingDetailsResponse!,
              bookingIdNew: bookingID!,
              bookingLocation: LatLng(double.parse(bookingDetailsResponse!.dropLat!), double.parse(bookingDetailsResponse!.dropLong!)), driverInitialLocation: LatLng(double.parse(driverLat), double.parse(driverLng))));
        }
        else {
          Get.to(UserTrackingScreen(
              driver: driver!,
              bookingID: bookingDetailsResponse!,
              bookingIdNew: bookingID!,
              bookingLocation: LatLng(double.parse(bookingDetailsResponse!.pickupLat!), double.parse(bookingDetailsResponse!.pickupLong!)), driverInitialLocation: LatLng(double.parse(driverLat), double.parse(driverLng))));
        }


      }


     // getAllBookingLoading = false;
      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isBookingDetails = false;
    update();



  }



  BookingDetailsResponse? detailsResponse = BookingDetailsResponse();
  Future<void>checkBookingComplete({String? bookingID})
  async {

    bool isComplete = false;

    update();
    print(getUserDeviceID());



    print("bookingID=>$bookingID");

    // vehicleData = null;
    Response response = await authRepo.getBookingDetails(bookingID: bookingID,userID: getUserID());




    if(response.statusCode==200 || response.statusCode ==400)
    {

      detailsResponse = null;

      detailsResponse = BookingDetailsResponse.fromJson(response.body);

      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      isComplete = false;

      update();
      ApiChecker.checkApi(response);




    }

    isBookingDetails = false;
    update();




  }
  BookingdriverResponse? driver = BookingdriverResponse();
  FaqModel? faqModel = FaqModel();
  LatLng? driverCurrentLocation;

  Future<void> getBookingDriver({String? bookingID, bool? isCall = false}) async {
    // अगर ये bookingID अब active नहीं है तो return कर दो
    if (activeBookingID != null && bookingID != activeBookingID) {
      print("Skipping old bookingID: $bookingID");
      return;
    }

    isBookingDetails = true;
    update();
    driver = null;

    Response response = await authRepo.getBookingDriver(bookingID: bookingID);

    if (response.statusCode == 200 || response.statusCode == 400) {
      if (response.body["status"]) {
        driver = BookingdriverResponse.fromJson(response.body);

        if (isCall!) {
          Driver driver2 = Driver(
            name: driver!.driverDetails!.firstName!,
            vehicleType: driver!.driverDetails!.vehicleType!,
            vehicleName: driver!.driverDetails!.vehicleNumber ?? "",
            mobileNumber: driver!.driverDetails!.contactNumber ?? "",
            id: driver!.driverDetails!.id ?? "",
          );


          driverCurrentLocation = LatLng(double.parse(driver!.driverDetails!.lat.toString()),double.parse(driver!.driverDetails!.long.toString()));
          update();
          getBookingDetails(
            bookingID: bookingID,
            driverLng: driver!.driverDetails!.long,
            driverLat: driver!.driverDetails!.lat,
            driver: driver2,
          );
        }
      } else {
        // सिर्फ active booking पर ही दोबारा call करना
        if (bookingID == activeBookingID) {
          getBookingDriver(bookingID: bookingID);
        }
      }

      update();
    } else if (response.statusCode == 404) {
      if (bookingID == activeBookingID) {
        getBookingDriver(bookingID: bookingID);
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isBookingDetails = false;
    update();
  }

  Future<void>getFaqListFunction() async {

    update();
    Response response = await authRepo.getFaqList();



    faqLIstResponse = [];
    if(response.statusCode==200 || response.statusCode ==400)
    {


      for(int i=0; i<response.body.length; i++){
        faqLIstResponse.add( FaqModel.fromJson(response.body[i]));
      }

      update();
    }
    else {

      ApiChecker.checkApi(response);

    }
    update();
  }







  Future<void>updateImage(var image)async
  {
    _image = image;

    update();
  }


  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();

    // Pick image from the front camera
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,

    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }

    update();
  }


  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String? getUserID()
  {
    return authRepo.sharedPreferences.getString(AppContants.userID);
  }

  String? getUserDeviceID()
  {
    return authRepo.sharedPreferences.getString(AppContants.userDeviceID);
  }

  String? getUserPassword()
  {
    return authRepo.sharedPreferences.getString(AppContants.userPassword);
  }

  String? getUserName()
  {
    return authRepo.sharedPreferences.getString(AppContants.userName);
  }

  String? getUserEmail()
  {
    return authRepo.sharedPreferences.getString(AppContants.userEmail);
  }

  String? getUserPhone()
  {
    return authRepo.sharedPreferences.getString(AppContants.userPhone);
  }

  Future<void> logoutUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // ✅ Clear all stored preferences
    await prefs.clear();

    // ✅ Optional: navigate to login or splash screen
    Get.offAndToNamed(RouteHelper.login);
  }




}