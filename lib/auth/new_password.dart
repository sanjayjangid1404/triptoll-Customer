import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/controller/authController.dart';

import '../util/appColors.dart';
import '../util/appImage.dart';

class NewPasswordPage extends StatefulWidget {
  final String mobileNumber;
  final String id;

  const NewPasswordPage({super.key, required this.mobileNumber,required this.id});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _submitNewPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Implement your password reset API call here

      Get.find<AuthController>().updatePassword({
        "id":widget.id,
        "password":_passwordController.text.trim(),
        "user_type" : "customer",
      });
      // Future.delayed(const Duration(seconds: 2), () {
      //   Navigator.popUntil(context, (route) => route.isFirst);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Password changed successfully!')),
      //   );
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColors.secondaryGradient,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("New Password".tr,style: TextStyle(fontSize: 18,color: Colors.white),),

        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 40,),

                  //logo
                  Center(child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Image.asset(AppImage.logoWithName,height: 200,),
                  )),

                  SizedBox(height: 25,),
                  Center(
                    child: Text(
                      'Create New Password'.tr,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Your new password must be different from previous used passwords'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // New Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'New Password'.tr,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password'.tr;
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters'.tr;
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password'.tr,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child:authController.isRegistration ? Center(child: CircularProgressIndicator(color: AppColors.primaryGradient,),):
                    ElevatedButton(
                      onPressed: _submitNewPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryGradient,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          :  Text('RESET PASSWORD'.tr,style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}