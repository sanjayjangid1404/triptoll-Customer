import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../controller/authController.dart';
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

    socket!.onConnect((_) async {
      log('✅ Connected with server');
      showCustomSnackBar('✅ Connected with server',isError: false,getXSnackBar: true);
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