import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/controller/authController.dart';

import '../util/appColors.dart';
import '../util/appContants.dart';
import '../util/appImage.dart';
import '../util/app_fonts.dart';
import '../util/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController phoneCt = TextEditingController();
  TextEditingController fNameCt = TextEditingController();
  TextEditingController lNameCt = TextEditingController();
  TextEditingController emailCt = TextEditingController();
  TextEditingController passwordCt = TextEditingController();
  TextEditingController otpCt = TextEditingController();
  bool _obscureText = true;
  bool isVerify = false;
  bool verificationCompeted = false;
  String OTP = "";

  bool isLoading = false;
  String apiResponse = "";
  Future<void> sendOtp() async {
    setState(() {
      isLoading = true;
      apiResponse = "";
    });

    String apiUrl =
        "${AppContants.baseURl}${AppContants.sendDriverOTPURL}";
    print(apiUrl);
    print({
      "contact_number": phoneCt.text,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "contact_number": phoneCt.text,
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);


        setState(() {
          OTP = data["otp_code"].toString();
          apiResponse = data.toString();
          isVerify = true;
          print(OTP);
        });
      } else {
        setState(() {
          apiResponse = "Error: ${response.statusCode}";
          isVerify = false;
        });
      }
    } catch (e) {
      setState(() {
        apiResponse = "Exception: $e";
      });
    }

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColors.primaryGradient,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Sign Up",style: TextStyle(fontSize: 18,color: Colors.white),),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80,),

              //logo
              Center(child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset(AppImage.logoWithName,height: 200,),
              )),

              SizedBox(height: 25,),

              Center(
                child: Text(
                  'Create Your',
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
                  'Account',
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

              SizedBox(height: 30,),

              //userNAme


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: fNameCt,
                  style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                  keyboardType: TextInputType.text,

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
                    hintText: "First Name",
                    hintStyle: TextStyle(
                      color: Color(0xFF868686),
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: lNameCt,
                  style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                  keyboardType: TextInputType.text,

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
                    hintText: "Last Name",
                    hintStyle: TextStyle(
                      color: Color(0xFF868686),
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: phoneCt,
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

                    suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Navigate to signup screen

                              if(phoneCt.text.isNotEmpty && phoneCt.text.length ==10) {
                                sendOtp();
                              }
                              else{
                                showCustomSnackBar("Enter valid OTP");
                              }
                            },
                            child:  Text(
                              "Get OTP",
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
                        ),
                      ],
                    ),

                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjust the vertical padding
                    hintText: "Mobile Number",
                    hintStyle: TextStyle(
                      color: Color(0xFF868686),
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),

             isVerify ?  SizedBox(height: 10,):SizedBox(),

              isVerify ?  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: otpCt,
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
                    hintText: "OTP",
                    hintStyle: TextStyle(
                      color: Color(0xFF868686),
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ):SizedBox(),
              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: emailCt,
                  style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                  keyboardType: TextInputType.text,

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
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Color(0xFF868686),
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: passwordCt,
                  obscureText: _obscureText,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: AppFonts.poppinsRegular,
                  ),
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Color(0xFF868686),
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),



              SizedBox(height: 30,),

              //action Button
              InkWell(
                onTap: (){
                  // Get.offAllNamed(RouteHelper.getHomeView());


                  if(fNameCt.text.isEmpty){
                    showCustomSnackBar("Enter first name", getXSnackBar: false,isError: true);
                  }else if(lNameCt.text.isEmpty){
                    showCustomSnackBar("Enter last name", getXSnackBar: false,isError: true);
                  }
                  else if(phoneCt.text.isEmpty && phoneCt.text.length !=10)
                  {
                    showCustomSnackBar("Invalid mobile no.", getXSnackBar: false,isError: true);
                  }
                  else if(emailCt.text.isEmpty )
                  {
                    showCustomSnackBar("Email email", getXSnackBar: false,isError: true);
                  }
                  else if(!isVerify){
                    showCustomSnackBar("Please verify mobile", getXSnackBar: false,isError: true);
                  }
                  else if(otpCt.text.isEmpty || otpCt.text.trim() !=OTP){
                    showCustomSnackBar("Enter valid otp", getXSnackBar: false,isError: true);
                  }


                  else
                  {


                    authController.createCustomer({
                      "first_name":fNameCt.text,
                      "last_name":lNameCt.text,
                      "email":emailCt.text,
                      "contact_number":phoneCt.text,
                      "password":passwordCt.text,
                    });

                    //authController.loginFunction(emailCt.text, passwordCt.text);

                    //  Get.to(VerificationScreen());
                  }

                },
                child:authController.isRegistration ? Center(child: CircularProgressIndicator(color: AppColors.primaryGradient,),): Container(

                  height: 40,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
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
                  child:/*authController!.isLoading ? SpinKitThreeBounce(color: Colors.white):*/ Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Continue'.toUpperCase(),
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
                  const Text(
                    "Back To ",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to signup screen
                      Get.back();
                    },
                    child:  Text(
                      "Sign In",
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
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}
