

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../api/api_client.dart';
import '../util/appContants.dart';

class AuthRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

 /* Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(
        ApiController.REGISTER_URI, signUpBody.toJson());
  }*/

  Future<Response> login({String? phone,String? password,String? token}) async {
    return await apiClient.postData(
        AppContants.loginUrl,{"contact_number":phone!,"password":password!,"token":token});
  }

  Future<Response> getCategoryTYPE() async {
    return await apiClient.getData(
        AppContants.getAllCategory);
  }

  Future<Response> getAllVehicle() async {
    return await apiClient.getData(
        AppContants.getAllVehicle);
  }

  Future<Response> createCustomer(body) async {
    return await apiClient.postMultipartData(
        AppContants.createCustomerURL,body,[]);
  }

  Future<Response> forgetPassword(body) async {
    return await apiClient.postData(
        AppContants.forgetPasswordURL,body);
  }

  Future<Response> updatePassword(body) async {
    return await apiClient.postData(
        AppContants.updatePasswordURL,body);
  }

  Future<Response> checkPayment({String? bookingID}) async {
    return await apiClient.postData(
        AppContants.checkPaymentURL,{"booking_id":bookingID});
  }Future<Response> cancelOrder({String? bookingID,String? userID,String? reason,String? comment}) async {
    return await apiClient.postData(
        AppContants.cancelOrderURL,{"booking_id":bookingID,/*"cus_id":userID,"reason":reason,"additional_comment":comment*/});
  }

  Future<Response> getAllBooking({String? status,String? limit,String? offset,String? userID}) async {
    return await apiClient.getData(
        "${AppContants.getAllBookingURL}?status=$status&limit=$limit&user_id=$userID&user_type=customer");
  }

  Future<Response> getRunningBooking({String? status,String? limit,String? offset,String? userID}) async {
    return await apiClient.postData(
        AppContants.runningBookingURL,{
          "customer_id":userID!
    });
  }

  Future<Response> getBookingDetails({String? bookingID,String? userID}) async {
    return await apiClient.getData(
        "${AppContants.getBookingDetails}/$bookingID?user_type=customer&user_id=$userID");
  }

  Future<Response> getBookingDriver({String? bookingID}) async {
    return await apiClient.getData(
        "${AppContants.driverDetailsURL}?booking_id=$bookingID");
  }

  Future<Response> getCategorySub(String id) async {
    return await apiClient.getData(
        AppContants.categoryVehicleURL+id);
  }

  Future<Response> notifyDriver(String id) async {
    return await apiClient.postData(
        AppContants.notifyDriverURL,{
          "booking_id":id
    });
  }

  Future<Response> orderPayment({String? id,String? driverID,String? key,String? status,String? orderID}) async {
    return await apiClient.postData(
        AppContants.orderPaymentURL,{
          "booking_id":id,
          "driver_id":driverID,
          "razorpay_payment_id":key,
          "payment_status":status,
          "order_id":orderID,
    });
  }

  Future<Response> bookNow({
    required String amount,
    required String categoryId,
    required String categoryName,
    required String cusId,
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
    required String senderContactNumber,
    required String senderName,
    required String stopAddress,
    required String stopCharge,
    required String totalAmount,
    required String totalDistance,
    required String vehicleId,
    required String vehicleImg,
    required String vehicleName,
  }) async {
    final body = {
      "amount": amount,
      "category_id": vehicleId,
      "category_name": categoryName,
      "cus_id": cusId,
      "discount": discount,
      "discount_percentage": discountPercentage,
      "drop_address": dropAddress,
      "drop_address_heading": dropAddressHeading,
      "drop_lat": dropLat,
      "drop_long": dropLong,
      "payment_type": paymentType,
      "pickup_address": pickupAddress,
      "pickup_heading": pickupHeading,
      "pickup_lat": pickupLat,
      "pickup_long": pickupLong,
      "rate": rate,
      "receiver_contact_number": receiverContactNumber,
      "receiver_name": receiverName,
      "sender_contact_number": senderContactNumber,
      "sender_name": senderName,
      "stop_address": stopAddress,
      "stop_charge": stopCharge,
      "total_amount": totalAmount,
      "total_distance": totalDistance,
      "vehicle_id": vehicleId,
      "vehicle_img": vehicleImg,
      "vehicle_name": vehicleName,
    };

    return await apiClient.postData(AppContants.saveBookingURl, body);
  }





  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(
        token);
    return await sharedPreferences.setString(AppContants.token, token);
  }



  Future<bool>saveUserId(String id)
  async{
    return await sharedPreferences.setString(AppContants.userID, id);
  }

  Future<bool>saveUserName(String name)
  async{
    return await sharedPreferences.setString(AppContants.userName, name);
  }

  Future<bool>saveUserEmail(String name)
  async{
    return await sharedPreferences.setString(AppContants.userEmail, name);
  }

  Future<bool>saveUserPhone(String name)
  async{
    return await sharedPreferences.setString(AppContants.userPhone, name);
  }


  Future<bool>saveUserDeviceId(String token)
  async{
    return await sharedPreferences.setString(AppContants.userDeviceID, token);
  }
  Future<bool>saveUserPassword(String password)
  async{
    return await sharedPreferences.setString(AppContants.userPassword, password);
  }


  bool isLoggedIn() {
    return sharedPreferences.getString(AppContants.token)!=null && sharedPreferences.getString(AppContants.token)!.isNotEmpty? true:false;
  }
 /* Future<Response> updateToken() async {
    String _deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
      NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
      }
    } else {
      _deviceToken = await _saveDeviceToken();
    }
    if (!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    }
    return await apiClient.postData(AppConstants.TOKEN_URI,
        {"_method": "put", "cm_firebase_token": _deviceToken});
  }*/

  bool clearSharedData() {

    sharedPreferences.remove(AppContants.token);
    apiClient.token = null;
    apiClient.updateHeader("");
    return true;
  }
}