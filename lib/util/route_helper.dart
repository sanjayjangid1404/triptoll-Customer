import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:triptoll/screen/home/homeview.dart';

import '../auth/loginView.dart';




class RouteHelper  {

  static final FluroRouter router = FluroRouter();

  static const String initial = '/';
  static String splash = '/splash';
  static String login = '/login';
  static String registration = '/signUp';
  static String verificationScreen = '/verificationScreen';
  static String forgetPassword = '/forgetPassword';
  static String resetPasswordView = '/resetPasswordView';
  static String homeView = '/homeView';
  static String drawerMenu = '/drawerMenu';
  static String editProfile = '/editProfile';
  static String reloadBalance = '/reloadBalance';
  static String transationHistory = '/transationHistory';
  static String orderDetails = '/orderDetails';
  static String notificationView = '/notificationView';
  static String vendorView = '/vendorView';
  static String cartView = '/cartView';
  static String canteenScreen = '/canteenScreen';
  static String changePasswordView = '/changePasswordView';
  static String qrCodeScreen = '/qrCodeScreen';
  static String faceVerification = '/faceVerification';



  static String getLoginRoute() => login;
  static String getCanteenScreen() => canteenScreen;
  static String getSignUp() => registration;




 /* static String getAddHomeListing(String type) {


    return "$addHomeListing&type=$type";
  }*/




  static String getSplashRoute() => splash;
  static String getForgetPassword() => forgetPassword;
  static String getInitialRoute() => initial;
  static String getResetPasswordView() => resetPasswordView;
  static String getDrawerMenu() => drawerMenu;
  static String getHomeView() => homeView;
  static String getEditProfile() => editProfile;
  static String getReloadBalance() => reloadBalance;
  static String getTransationHistory(int index) => "$transationHistory?index=$index";
  static String getOrderDetails() => orderDetails;
  static String getNotificationView() => notificationView;
  static String getVendorView() => vendorView;
  static String getCartView() => cartView;
  static String getChangePasswordView() =>changePasswordView;
  static String getQrCodeScreen() =>qrCodeScreen;
  static String getFaceVerification() =>faceVerification;
  static String getVerificationScreenRoute(String number,String type) => "$verificationScreen?number=$number&type=$type";


  static List<GetPage> routes = [

    GetPage(name: login, page: () => const LoginView()),
    GetPage(name: homeView, page: () => const HomePage()),
  ];





}