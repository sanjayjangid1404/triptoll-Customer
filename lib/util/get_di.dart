

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../controller/authController.dart';

import '../repo/auth_repo.dart';
import 'appContants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();

    Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppContants.baseURl, sharedPreferences: Get.find()));

  Get.lazyPut(() => AuthController(authRepo: Get.find()));

  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

/*  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: ApiController.baseURL, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => FeedRepo(apiClient: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => PageRepo(apiClient: Get.find()));
  Get.lazyPut(() => SearchRepo(apiClient: Get.find()));
  Get.lazyPut(() => ParkRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProfileRepo(apiClient: Get.find()));
  Get.lazyPut(() => PostRepo(apiClient: Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient: Get.find()));

  // Controller

  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => PageController2(authRepo: Get.find()));
  Get.lazyPut(() => FeedController(authRepo: Get.find()));
  Get.lazyPut(() => ProfileController(authRepo: Get.find()));
  Get.lazyPut(() => SearchControllerData(authRepo: Get.find()));
  Get.lazyPut(() => PostController(authRepo: Get.find()));
  Get.lazyPut(() => DashBoardController(authRepo: Get.find()));
  Get.lazyPut(() => ParkController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(authRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));*/


  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  return languages;
}