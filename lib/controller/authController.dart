import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
import '../model/check_ticket_limit_model.dart';
import '../model/city_responce.dart';
import '../model/faq_model.dart';
import '../model/faq_response_model.dart';
import '../model/getLastFiveDropLocations_model.dart';
import '../model/get_reorder_model.dart';
import '../model/my_order_model.dart';
import '../model/notification_model.dart';
import '../model/subCategoryVehicle.dart';
import '../model/vehicle_data.dart';
import '../model/wallet_responce_model.dart';
import '../repo/auth_repo.dart';
import '../screen/home/userTraking_view.dart';
import '../socket/socket_connect_file.dart';
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
  // List<Orders?> bookingListResponse = [];
  Rx<MyOrdersModel> bookingListResponse = MyOrdersModel().obs;
  List<Orders?> latestBookingListResponse = [];
  List<FaqModel?> faqLIstResponse = [];
  VehicleData? vehicleData = VehicleData();
  bool isDeepLinkHandled = false;
  int? getIndex;
  List<String>banners = ["https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FLifetime-Family-Plan-offer-slider.1c6725bf.webp&w=3840&q=75",
    "https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FFree-Car-Care-Kit.46a9b3ee.webp&w=3840&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FTitanium-Family-Plan.d35e75e6.webp&w=3840&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FPlatinum-Family-Plan.2eb81b06.webp&w=3840&q=75"];
  int currentIndex = 0;
  bool isVehicle = false;
  String newBookingID = "";
  RxString selectedLanguage = "English".obs;

  String _email = '';
  String get verificationCode => _verificationCode;
  String get email => _email;

  File? get image =>_image;

  List<FaqDriverResponse>faqDriverResponse = [];
  RxBool isDataLoading = false.obs;
  Rx<CheckTicketLimitModel> checkTicketLimitModel = CheckTicketLimitModel().obs;
  Future<void> checkTicket(body) async {
    Response response = await authRepo.checkTicketLimits(body);
    if (response.statusCode == 200) {
      checkTicketLimitModel.value = CheckTicketLimitModel.fromJson(response.body);

    }
    else {
    }
    update();
  }
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

      // Get.back();
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
    // latestBooking(status: "all", limit: "1", offset: "10");

    // Then refresh every 10 seconds
    // _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    //   latestBooking(status: "all", limit: "1", offset: "10");
    // });
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
        authRepo.saveUserId(response.body['id'].toString());
        authRepo.saveCityId(response.body['city_id'].toString());
        authRepo.saveFName(response.body['first_name']);
        print('sddsd${response.body['first_name']}');
        print('sddsd${response.body['last_name']}');
        print('sddsd${response.body['contact_number']}');
        authRepo.saveLName(response.body['last_name']);

        // if(response.body["success"]) {
        //   showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: false);
        // }
        // Get.offAllNamed(RouteHelper.getHomeView());
        Get.back();

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

  Future<void>loginFunctionNew(String phoneNumber,String otp)
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

    Response response = await authRepo.loginVerifyOtp(phone: phoneNumber,otp:
    otp,token: token);

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
        authRepo.saveUserId(response.body['id'].toString());
        authRepo.saveCityId(response.body['city_id'].toString());
        authRepo.saveFName(response.body['first_name']);
        print('sddsd${response.body['first_name']}');
        print('sddsd${response.body['last_name']}');
        print('sddsd${response.body['contact_number']}');
        authRepo.saveLName(response.body['last_name']);
        final socketController = Get.find<ChatController>();
        socketController.reconnectWithNewToken();

        // if(response.body["success"]) {
        //   showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: false);
        // }
        // Get.offAllNamed(RouteHelper.getHomeView());
        Get.back();

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

  Future<void> getNotificationHistory(body) async {
    // update();
    Response response = await authRepo.notificationHistory(body);
    if (response.statusCode == 200) {

      notificationHistoryModel.value = NotificationHistoryModel.fromJson(response.body);
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    // update();
  }
  Rx<NotificationHistoryModel> notificationHistoryModel = NotificationHistoryModel().obs;
  bool isUploading = false;
  List<CityResponse> cityResponse = [];
  Future<void> getCity() async {
    isUploading = true;


    Response response = await authRepo.getCity();
    cityResponse = [];

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      for (int i = 0; i < response.body.length; i++) {
        cityResponse.add(CityResponse.fromJson(response.body[i]));
      }


      update();
    }
    else {


    }

    isUploading = false;
    update();
  }
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
  Future<void>bookingMultipleNow({
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
    String? scheduleDate,
    String? scheduleTime,
    String? senderPhone,
    String? senderNameText,
    String? pickupOtp,
    required List<Map<String, dynamic>> stopLocations,
  })
  async {

    isBookingProcess = true;
    isShowDriver = false;

    update();
    print(getUserDeviceID());





    Response response = await authRepo.bookMultiple(
        distance: distance,
        expectedTime: expectedTime,
        amount: amount,
        pickupOtp: pickupOtp,
        categoryId: categoryId,
        categoryName: categoryName,
        cusId: getUserID()??"",
        discount: discount,
        discountPercentage: discountPercentage,
        dropAddress: dropAddress,
        dropAddressHeading: dropAddressHeading,
        dropLat: dropLat,
        dropLong: dropLong,
        paymentType: paymentType,
        pickupAddress: pickupAddress,
        pickupHeading: pickupHeading,
        pickupLat: pickupLat,
        pickupLong: pickupLong,
        rate: rate,
        receiverContactNumber: receiverContactNumber,
        receiverName: receiverName,
        senderContactNumber: senderPhone.toString(),
        senderName: senderNameText.toString(),
        stopAddress: stopAddress,
        stopCharge: stopCharge,
        totalAmount: totalAmount,
        totalDistance: totalDistance,
        vehicleId: vehicleId,
        vehicleImg: vehicleImg,
        vehicleName: vehicleName,
        stopLocations: stopLocations,scheduleTime: scheduleTime,scheduleDate: scheduleDate,
        senderNameText:senderNameText,senderPhone : senderPhone
    );

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {
      isShowDriver = true;

      // showCustomSnackBar("Booking Process", isError: false);
      showCustomSnackBar(response.body["message"].toString(), isError: false);

      String newId = response.body["id"].toString();

      // सिर्फ तब update करना है जब नई ID आए
      if (activeBookingID != newId) {
        activeBookingID = newId;
        newBookingID = newId;
        notifyDriver(newBookingID);
      }

      // सिर्फ activeBookingID वाली call ही चलानी है
      getBookingDriver(bookingID: activeBookingID);

      // latestBooking(status: "all", limit: "1", offset: "10");

      update();
    }
    else {


      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isBookingProcess = false;
    update();



  }

  List<WalletResponse>walletResponseList = [];
  Future<void> getWalletHistory() async {
    isLoading = true;

    update();
    print(getUserDeviceID());

    walletResponseList = [];

    Response response = await authRepo.getWalletHistory(userID: getUserID());

    //  LoginResponse? loginResponse;

    if (response.statusCode == 200 || response.statusCode == 400) {
      for (int i = 0; i < response.body.length; i++) {
        walletResponseList.add(WalletResponse.fromJson(response.body[i]));
      }
    }
    else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
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
        if (response.body['first_name'] != null && response.body['first_name'].toString().isNotEmpty) {
          authRepo.saveFName(response.body['first_name']);
        }
        if (response.body['last_name'] != null && response.body['last_name'].toString().isNotEmpty) {
          authRepo.saveLName(response.body['last_name']);
        }
        authRepo.saveUserEmail(response.body['email']??"");
        authRepo.saveUserPhone(response.body['contact_number']);
        // authRepo.saveUserPassword(password);
        authRepo.saveUserId(response.body['id'].toString());
        authRepo.saveCityId(response.body['city_id'].toString());
        // if(response.body["success"]) {
        //   showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: false);
        // }
        // Get.offAllNamed(RouteHelper.getHomeView());
        Get.back();
        Get.back();
      }

      update();
    }
    else {




      ApiChecker.checkApi(response);




    }

    isRegistration = false;
    update();



  }
  Future<void>createCustomerNew(body) async {

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


    Response response = await authRepo.createCustomerNew(body);

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
        if (response.body['first_name'] != null && response.body['first_name'].toString().isNotEmpty) {
          authRepo.saveFName(response.body['first_name']);
        }
        if (response.body['last_name'] != null && response.body['last_name'].toString().isNotEmpty) {
          authRepo.saveLName(response.body['last_name']);
        }
        authRepo.saveUserEmail(response.body['email']??"");
        authRepo.saveUserPhone(response.body['contact_number']);
        // authRepo.saveUserPassword(password);
        authRepo.saveUserId(response.body['id'].toString());
        authRepo.saveCityId(response.body['city_id'].toString());
        // if(response.body["success"]) {
        //   showCustomSnackBar(response.body["message"], getXSnackBar: false,isError: false);
        // }
        // Get.offAllNamed(RouteHelper.getHomeView());
        Get.back();
        Get.back();
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
          text: 'Transaction Completed Successfully!'.tr,
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
  bool isSuccess = false;
  Future<void>orderPaymentWithWallet(String id,String driverID,String key,String status,BuildContext context,String orderID,String discountAmount,String totalAmount,String amount)
  async {

    isVehicle = true;

    update();
    print(getUserDeviceID());
    subCategoryVehicle = null;



    Response response = await authRepo.orderPaymentWallet(id: id,status: status,driverID: driverID,key: key,orderID: orderID,discountAmount: discountAmount,amount: amount,totalAmount: totalAmount);

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {
      isSuccess = true;
      final chatController = Get.find<ChatController>();
      final payload = {
        "booking_id":id.toString(),
        "status": "paid"
      };

      print("📤 Sending Payload: $payload");
      chatController.socket?.emitWithAck("updateStatus", {
        "booking_id":  id.toString(),
        "status": "paid"
      },
          ack: (response) {
            print("ACK Response: $response");

            if (response != null && response["status"] == true) {
              print("✅ Status updated successfully");
            } else {
              print("❌ Failed to update status");
            }
          });
      chatController.socket?.emitWithAck("completeTrip", {
        "booking_id":id.toString(),
        "driver_id":driverID.toString()
      },
          ack: (response) {
            print("endTripSocket: $response");
          }
      );
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Payment Completed Successfully!'.tr,
          onConfirmBtnTap: (){
            Get.back();
          }
      );
      update();
    }
    else {
      isSuccess = false;

      // dynamic data = jsonDecode(response.body);

      ApiChecker.checkApi(response);




    }

    isVehicle = false;
    update();



  }
  Future<void>addWalletPaymentFun({String? amount, String? transitionId, required BuildContext context})
  async {

    isVehicle = true;

    update();
    print(getUserDeviceID());
    subCategoryVehicle = null;



    Response response = await authRepo.addWalletPayment(customerID: getUserID(),amount: amount,trnId: transitionId);

  //  LoginResponse? loginResponse;

    if(response.statusCode==200 || response.statusCode ==400)
    {

      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Transaction Completed Successfully!'.tr,
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
    print('data is new}');
    Response response = await authRepo.getAllVehicle();



    if(response.statusCode==200 || response.statusCode ==400)
    {
      isShowDriver = false;

      vehicleData = VehicleData.fromJson(response.body);
      isVehicle = false;
      print('data is new${response.body}');
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

    if(response.statusCode==200 || response.statusCode ==400)
    {


      bookingListResponse.value = MyOrdersModel.fromJson(response.body);

      print('adfdsf${ response.body.toString()}');
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

  // Future<void>latestBooking({String? status,String? limit,String? offset})
  // async {
  //
  //   getAllBookingLoading = true;
  //
  //   update();
  //   print(getUserDeviceID());
  //
  //   if(getUserID()!=null && getUserID()!.isNotEmpty){
  //     Response response = await authRepo.getRunningBooking(status: status,limit: limit,offset: offset,userID: getUserID());
  //
  //
  //
  //     latestBookingListResponse = [];
  //     if(response.statusCode==200 || response.statusCode ==400)
  //     {
  //
  //
  //       if(response.body["orders"]!=null) {
  //         for (int i = 0; i < response.body["orders"].length; i++) {
  //           latestBookingListResponse.add(Orders.fromJson(response.body["orders"][i]));
  //         }
  //       }
  //
  //       // getAllBookingLoading = false;
  //       update();
  //     }
  //     else {
  //
  //
  //       // dynamic data = jsonDecode(response.body);
  //
  //       ApiChecker.checkApi(response);
  //
  //
  //
  //
  //     }
  //
  //     getAllBookingLoading = false;
  //     update();
  //
  //   }
  //
  //  // vehicleData = null;
  //
  //
  //
  // }

  String pickupAddressMultiLocation = '';
  String pickupAddressMultiLocationLat = '';
  String pickupAddressMultiLocationLng = '';
  String pickupAddressMultiLocationCity = '';
  GetLastFiveDropLocationsModel getLastFiveDropLocationsModel = GetLastFiveDropLocationsModel();

  Future<void>getLastFiveDrop({String? userId})
  async {

    getAllBookingLoading = true;

    update();
    print(getUserDeviceID());

    if(getUserID()!=null && getUserID()!.isNotEmpty){
      Response response = await authRepo.getLastFiveDropLocations(userID: getUserID());

      if(response.statusCode==200 || response.statusCode ==400)
      {

        getLastFiveDropLocationsModel = GetLastFiveDropLocationsModel.fromJson(response.body);
        update();
      }
      else {
        ApiChecker.checkApi(response);
      }
      update();
    }
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

      final socketController = Get.find<ChatController>();
      if (socketController.socket?.connected == true) {

        socketController.socket?.emitWithAck(
          "cancelBooking", {
            "booking_id" : bookingID ?? "0",
          },
          ack: (response) {
            if (kDebugMode) {
              print("Server response uccess: custoemr  : $response");
            }

            if (response == null) {
              if (kDebugMode) {
                print("❌ No response from server");
              }
              return;
            }

            if (response["status"] == "success") {
              if (kDebugMode) {
                // showCustomSnackBar('${response["message"]}',isError: false,getXSnackBar: true);
                print("✅ Success: customer  ${response["message"]}");
              }
              final payload = {
                "booking_id": bookingID ?? "0",
              };
              if (kDebugMode) {
                print("Cancel order adsds: $payload");
              }
            } else {
              if (kDebugMode) {
                print("❌ Error: ${response["message"]}");
              }
            }
          },
        );
      }
      if(isOrder!){
        getAllBooking(status: "all",limit: "100");
        showCustomSnackBar(response.body['message'].toString(),isError: false,getXSnackBar: true);
        // Get.back();
      }
      else {
        getAllBooking(status: "all",limit: "100");
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

  // Future<void>cancelOrderHome({String? bookingID,String? reason,String? comment,bool? isOrder})
  // async {
  //
  //
  //   update();
  //   print(getUserDeviceID());
  //
  //  // vehicleData = null;
  //   Response response = await authRepo.cancelOrder(bookingID: bookingID,userID: getUserDeviceID(),comment: comment,reason: reason);
  //
  //
  //
  //
  //   if(response.statusCode==200 || response.statusCode ==400)
  //   {
  //
  //    // getAllBookingLoading = false;
  //
  //     if(isOrder!){
  //       getAllBooking(status: "all",limit: "10");
  //       // Get.back();
  //     }
  //     else {
  //       // Get.offAll(HomePage());
  //     }
  //
  //     update();
  //   }
  //   else {
  //
  //
  //     // dynamic data = jsonDecode(response.body);
  //
  //     ApiChecker.checkApi(response);
  //
  //
  //
  //
  //   }
  //
  //   getAllBookingLoading = false;
  //   update();
  //
  //
  //
  // }

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


      bookingDetailsResponse = BookingDetailsResponse.fromJson(response.body[0]);

      if(driverLat!=null && driverLat!.isNotEmpty && driverLng!=null && driverLng!.isNotEmpty && bookingDetailsResponse!=null){



        print("driverLat!=>$driverLat!");
        print("driverLng!=>$driverLng!");
        print("driverLng!=>${bookingDetailsResponse!.startTrip}!");
        print("driverLng!=>${bookingDetailsResponse!.paymentStatus}!");
        if(bookingDetailsResponse!.startTrip.toString().toLowerCase() == "yes"){
          final drop = bookingDetailsResponse!.dropoffs![0];
          Get.to(UserTrackingScreen(
              driver: driver!,
              bookingID: bookingDetailsResponse!,
              bookingIdNew: bookingID!,
              bookingLocation: LatLng(double.parse(drop.lat.toString()),
                  double.parse(drop.lng.toString())),
              driverInitialLocation: LatLng(double.parse(driverLat),
                  double.parse(driverLng))));
        }
        else {
          final drop = bookingDetailsResponse!.dropoffs![0];
          Get.to(UserTrackingScreen(
              driver: driver!,
              bookingID: bookingDetailsResponse!,
              bookingIdNew: bookingID!,
              bookingLocation: LatLng(double.parse(drop.lat.toString()),
                  double.parse(drop.lng.toString())),
              driverInitialLocation: LatLng(double.parse(driverLat),
                  double.parse(driverLng))));
        }
        // if(bookingDetailsResponse!.orderStatus.toString().toLowerCase() == "delivered"){
        //   Get.offAllNamed(RouteHelper.getHomeView());
        // }


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

  Rx<GetReorderDataModel> getReorderDataModel = GetReorderDataModel().obs;
  Future<void>getBookingDetailsReorder({String? bookingID}) async {


    Response response = await authRepo.getBookingDetails(bookingID: bookingID,userID: getUserID());



    print('::::::::::${response.body.toString()}');
    if(response.statusCode==200 || response.statusCode ==400)
    {
      getReorderDataModel.value = GetReorderDataModel.fromJson(response.body[0]);
    }
    else {
      getReorderDataModel.value = GetReorderDataModel.fromJson(response.body[0]);
      ApiChecker.checkApi(response);
    }
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

      detailsResponse = BookingDetailsResponse.fromJson(response.body[0]);

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

  Future<void>disableCustomr()
  async {


    // vehicleData = null;
    Response response = await authRepo.disableCustomr(userID: getUserID());


    Get.back();

    if(response.statusCode==200 || response.statusCode ==400)
    {
      logoutUser();
      update();
    }
    else {


      update();
      ApiChecker.checkApi(response);


    }
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

  Future<void> getBookingDriverHome({String? bookingID, bool? isCall = false,driverID}) async {
    // अगर ये bookingID अब active नहीं है तो return कर दो
    // if (activeBookingID != null && bookingID != activeBookingID) {
    //   print("Skipping old bookingID: $bookingID");
    //   return;
    // }

    isBookingDetails = true;
    update();
    driver = null;

    Response response = await authRepo.getBookingDriverHome(customerID: driverID);

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
 String? getCityID()
  {
    return authRepo.sharedPreferences.getString(AppContants.cityID);
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
  String? getFName()
  {
    return authRepo.sharedPreferences.getString(AppContants.fName);
  }
  String? getLName()
  {
    return authRepo.sharedPreferences.getString(AppContants.lName);
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
    Get.offAllNamed(RouteHelper.login);
  }




}