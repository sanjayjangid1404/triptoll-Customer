import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triptoll/auth/loginView.dart';
import 'package:triptoll/screen/home/homeview.dart';
import 'package:triptoll/screen/landing_page.dart';
import 'package:triptoll/util/appContants.dart';
import 'package:triptoll/util/route_helper.dart';
import 'controller/authController.dart';
import 'util/get_di.dart' as di;
import 'package:triptoll/util/appImage.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();





  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);


  await di.init();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();

    }
  });
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  /* await FaceCamera.initialize();
  await Firebase.initializeApp();*/
  runApp( MyApp());
}

class MyApp extends StatefulWidget{


  @override
  State<StatefulWidget> createState() =>_MyApp();

}

class _MyApp extends State<MyApp> {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AppContants.getToken();
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    var initialzationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,);
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid,iOS: initialzationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        if (kDebugMode) {
          print("onMessage: ${notification.title}/${notification.body}/${notification.titleLocKey}");
          print("onMessage type: ${message.data['type']}/${message.data}");
        }



        // Check if 'type' key exists in message data

        flutterLocalNotificationsPlugin.show(
          notification.hashCode, // id
          notification.title,    // title
          notification.body,     // body
          NotificationDetails(   // notification details
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: "", // optional data
        );




      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {


    });

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return GetMaterialApp(
      title: '',
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          platform: TargetPlatform.iOS,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent,surfaceTintColor: Colors.transparent,dragHandleColor: Colors.transparent,shadowColor: Colors.transparent,)
      ),
      getPages: RouteHelper.routes,
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: AppImage.splashLogo,
        nextScreen: Get.find<AuthController>().isLoggedIn() ? HomePage() : LoginView(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}
