import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../controller/authController.dart';
import '../model/booking_details_response.dart';
import '../model/booking_list_response.dart';
import '../screen/home/homeview.dart';
import '../util/appContants.dart';
import '../util/custom_snackbar.dart';


class ChatController extends GetxController {

  io.Socket? socket;
  Future<void> connectToServer() async {
    if (socket?.connected == true) {
      log("Already connected");
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(AppContants.token) ?? '';

    if (token.isEmpty) {
      log("❌ Token missing");
      return;
    }

    socket?.disconnect();
    socket?.dispose();

    socket = io.io('ws://triptoll.in:3000', {
      "transports": ["websocket"],
      "autoConnect": false,
      "reconnection": true,
      "reconnectionAttempts": 10,
      "reconnectionDelay": 2000,
      "reconnectionDelayMax": 10000,
      "extraHeaders": {"authorization": token}
    });
    print("Server response background idddd: ${ pref.getString(AppContants.userID)}");
    String? tokenDevice;



    if(Platform.isAndroid)
    {
      tokenDevice =  await FirebaseMessaging.instance.getToken();
    }
    else
    {
      tokenDevice = await FirebaseMessaging.instance.getAPNSToken();
    }

    socket!.emitWithAck('registerCustomerDevice', {
      'customer_id': pref.getString(AppContants.userID),
      'device_token': tokenDevice,
    },ack: (response) {
      if (kDebugMode) {
        print("Device Server response background123456: $response");
         }
      });
    socket!.on("activeBooking", (data) {
      if (kDebugMode) {
        print("📡 activeBooking status: $data");
      }

      final auth = Get.find<AuthController>();

      try {
        auth.getAllBookingLoading = true;
        auth.update();

        if (data != null && data is Map<String, dynamic>) {

          auth.latestBookingListResponse = [];

          final orders = data['orders'] ?? data['booking'];

          if (orders != null && orders is List && orders.isNotEmpty) {

            auth.latestBookingListResponse = orders
                .map((e) => Orders.fromJson(e))
                .toList();

            auth.bookingDetailsResponse =
                BookingDetailsResponse.fromJson(orders[0]);
          }
        }

        auth.getAllBookingLoading = false;
        auth.update();

      } catch (e) {
        auth.getAllBookingLoading = false;
        auth.update();
        print("❌ Parsing error: $e");
      }
    });
    socket!.on("customerActiveBookings", (data) {
      if (kDebugMode) {
        print("📡 customerActiveBookings status: $data");
      }

      final auth = Get.find<AuthController>();

      try {
        auth.getAllBookingLoading = true;
        auth.update();

        if (data != null && data is Map<String, dynamic>) {

          auth.latestBookingListResponse = [];

          final orders = data['data'] ?? data['data'];

          if (orders != null && orders is List && orders.isNotEmpty) {

            auth.latestBookingListResponse = orders
                .map((e) => Orders.fromJson(e))
                .toList();

            auth.bookingDetailsResponse =
                BookingDetailsResponse.fromJson(orders[0]);

            final status = auth.bookingDetailsResponse?.orderStatus
                ?.toString()
                .toLowerCase() ?? "";

            print("STATUS VALUE: $status");

            if (status == "delivered") {
              print("✅ Order Completed/Paid → Redirecting Home");
                Get.offAll(() => HomePage());
            }
          }
        }

        auth.getAllBookingLoading = false;
        auth.update();

      } catch (e) {
        auth.getAllBookingLoading = false;
        auth.update();
        print("❌ Parsing error: $e");
      }
    });
    socket!.onReconnectFailed((_) {
      log("❌ Reconnection Failed after 10 attempts");

      showCustomSnackBar(
        "Network issue. Please login again.",
        getXSnackBar: true,
        isError: true,
      );

      Get.find<AuthController>().logoutUser();

      socket?.clearListeners();
      socket?.disconnect();
      socket?.dispose();
      socket = null;
    });
    socket!.onDisconnect((_) {
      log('❌ Disconnected');
    });

    socket!.onConnectError((data) {
      log("❌ Connect Error: $data");
    });

    socket!.onError((data) {
      log("❌ Error: $data");
    });

    socket!.onReconnect((_)  {
      log("🔁 Reconnected");
      connectToServer();
    });

    socket!.connect();
  }
  Future<void> reconnectWithNewToken() async {
    print("🔄 Reconnecting with new token...");
    connectToServer();
  }
  @override
  void onInit() {
    connectToServer();
    super.onInit();
  }

  @override
  void onClose() {
    socket?.disconnect();
    socket?.dispose();
    super.onClose();
  }
}