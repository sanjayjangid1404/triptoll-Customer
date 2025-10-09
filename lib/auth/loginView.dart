

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triptoll/auth/SignUp.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/screen/home/homeview.dart';

import '../screen/widget/nav_bar.dart';
import '../util/appColors.dart';
import '../util/appContants.dart';
import '../util/appImage.dart';
import '../util/app_fonts.dart';
import '../util/custom_snackbar.dart';
import 'forgot.dart';






class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  TextEditingController emailCt = TextEditingController(text: "");
  TextEditingController passwordCt = TextEditingController(text: "");
  bool passwordVisible = false;
  bool _obscureText = true;
  updateLanguage(String gg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("app_language", gg);
  }
  checkLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? lang = sharedPreferences.getString("app_language");

    if (lang == null || lang == "English") {
      Get.updateLocale(const Locale('en', 'US'));
      // authController.selectedLanguage.value = "English";
    } else if (lang == "தமிழ்" || lang == "Tamil") {
      Get.updateLocale(const Locale('ta', 'IN'));
      // authController.selectedLanguage.value = 'தமிழ்';
    } else if (lang == "తెలుగు" || lang == "Telugu") {
      Get.updateLocale(const Locale('te', 'IN'));
      // authController.selectedLanguage.value = 'తెలుగు';
    } else if (lang == "বাংলা" || lang == "Bengali") {
      Get.updateLocale(const Locale('bn', 'IN'));
      // authController.selectedLanguage.value = 'বাংলা';
    } else {
      // Default fallback
      Get.updateLocale(const Locale('en', 'US'));
      // authController.selectedLanguage.value = "English";
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLanguage();
    SharedPreferences.getInstance().then((sharedPreferences) {

    });
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: SafeArea(
          child:  SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                    child: Obx(() {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: const Color(0xffDCDCDC)),
                                                    borderRadius: BorderRadius.circular(15)),
                                                child: RadioListTile(
                                                  title: Text('English'.tr),
                                                  activeColor: const Color(0xff014E70),
                                                  value: "English",
                                                  groupValue: authController.selectedLanguage.value,
                                                  onChanged: (value) {
                                                    locale = const Locale('en', 'US');
                                                    authController.selectedLanguage.value = value!;
                                                    updateLanguage("English");
                                                    setState(() {});
                                                  },
                                                )),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: const Color(0xffDCDCDC)),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: RadioListTile(
                                                title: Text('தமிழ்'.tr),
                                                activeColor: const Color(0xff014E70),
                                                value: "தமிழ்",
                                                groupValue: authController.selectedLanguage.value,
                                                onChanged: (value) {
                                                  locale = const Locale('ta', 'IN');
                                                  authController.selectedLanguage.value = value!;
                                                  updateLanguage("தமிழ்");
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: const Color(0xffDCDCDC)),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: RadioListTile(
                                                title: Text('বাংলা'.tr),
                                                activeColor: const Color(0xff014E70),
                                                value: "বাংলা",
                                                groupValue: authController.selectedLanguage.value,
                                                onChanged: (value) {
                                                  locale = const Locale('bn', 'BD');
                                                  authController.selectedLanguage.value = value!;
                                                  updateLanguage("বাংলা");
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: const Color(0xffDCDCDC)),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: RadioListTile(
                                                title: Text('తెలుగు'.tr),
                                                activeColor: const Color(0xff014E70),
                                                value: "తెలుగు",
                                                groupValue: authController.selectedLanguage.value,
                                                onChanged: (value) {
                                                  locale = const Locale('te', 'IN');
                                                  authController.selectedLanguage.value = value!;
                                                  updateLanguage("తెలుగు");
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),

                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          // Padding(
                                          //     padding: const EdgeInsets.only(left: 20, right: 20),
                                          //     child: Container(
                                          //         decoration: BoxDecoration(
                                          //             border: Border.all(color: const Color(0xffDCDCDC)),
                                          //             borderRadius: BorderRadius.circular(15)),
                                          //         child: RadioListTile(
                                          //           title: const Text('Several languages'),
                                          //           activeColor: const Color(0xff014E70),
                                          //           value: "Several languages",
                                          //           groupValue: language.value,
                                          //           onChanged: (value) {
                                          //             print(selectedLAnguage.value.toString());
                                          //             setState(() {
                                          //               language.value = value!;
                                          //             });
                                          //           },
                                          //         ))),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.updateLocale(locale);
                                              Get.back();
                                            },
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                                child: Container(
                                                  height: 56,
                                                  width: MediaQuery.sizeOf(context).width,
                                                  color: Color(0xFFEC6C0C),
                                                  child: Center(
                                                    child: Text(
                                                      'Apply'.tr,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }));
                              });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.language,),
                            Text('Language'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 80,),

                    //logo
                    Center(child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Image.asset(AppImage.logoWithName,height: 200,),
                    )),

                    SizedBox(height: 25,),

                    Center(
                      child: Text(
                        'Login Your'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryGradient,
                          fontSize: 24,
                          fontFamily: AppFonts.poppinsRegular,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Account'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryGradient,
                          fontSize: 24,
                          fontFamily: AppFonts.poppinsRegular,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                    // SizedBox(height: 8,),
                    // Center(
                    //   child: Text(
                    //     'Well Send Your a 6 Digit OTP on Your Mobile Number For Verification',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       color: Colors.black.withOpacity(0.4),
                    //       fontSize: 14,
                    //       fontFamily: AppFonts.poppinsRegular,
                    //
                    //       height: 0,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 30,),

                    //userNAme


                    TextField(
                      controller: emailCt,
                      style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counter: SizedBox(),
                        border: OutlineInputBorder(



                          borderRadius: BorderRadius.circular(4),
                        ),
                        fillColor: Color(0xFFC11F1F),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),

                          borderRadius: BorderRadius.circular(4),
                      ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),

                          borderRadius: BorderRadius.circular(4),
                        ),

                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjust the vertical padding
                        hintText: "Mobile Number".tr,
                        hintStyle: TextStyle(
                          color: Color(0xFF868686),
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),

                    SizedBox(height: 15,),

                    TextField(
                      controller: passwordCt,
                      obscureText: _obscureText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        hintText: "Password".tr,
                        hintStyle: const TextStyle(
                          color: Color(0xFF868686),
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Navigate to forget password screen
                          Get.to(Forgot());
                          print("Forget Password tapped");
                        },
                        child: Text(
                          "Forgot Password?".tr,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.secondaryGradient,
                              // decoration: TextDecoration.underline,
                              // decorationColor: AppColors.primaryGradient
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 30,),

                    //action Button
                    InkWell(
                      onTap: (){
                       // Get.offAllNamed(RouteHelper.getHomeView());

                        if(emailCt.text.isEmpty && emailCt.text.length !=10)
                          {
                            showCustomSnackBar("Invalid mobile no.".tr, getXSnackBar: false,isError: true);
                          }
                        else if(passwordCt.text.isEmpty){
                          showCustomSnackBar("Enter password".tr);
                        }

                        else
                        {

                          authController.loginFunction(emailCt.text, passwordCt.text);



                       //  Get.to(VerificationScreen());
                        }

                      },
                      child: Container(

                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        //padding: const EdgeInsets.symmetric(vertical: 17),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: AppColors.primaryGradient,
                          /*gradient: LinearGradient(
                            begin: Alignment(1.00, 0.00),
                            end: Alignment(-1, 0),
                            colors: [ AppColors.primaryGradient,AppColors.secondaryGradient],
                          ),*/
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppContants.btnRadius),
                          ),
                        ),
                        child:authController!.isLoading ? SpinKitThreeBounce(color: Colors.white): Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Login'.toUpperCase().tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.60,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                height: 0,
                                letterSpacing: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),


                    // Don't Have An Account? Signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                          "Don't have an account? ".tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Navigate to signup screen
                            Get.to(Signup());
                          },
                          child:  Text(
                            "Signup".tr,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.secondaryGradient,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              decorationColor: AppColors.primaryGradient
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24,),




                  ],
                ),
              ),
            )

        ),
      ),
    );
  }
}
