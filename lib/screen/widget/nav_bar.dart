import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/screen/home/order_list.dart';
import '../../auth/loginView.dart';
import '../../util/appColors.dart';
import '../../util/route_helper.dart';
import '../home/WalletView.dart';
import '../payment/payment_list.dart';
import '../sideMenu_item/contact_us.dart';
import '../sideMenu_item/faq_list_screen.dart';
import '../sideMenu_item/privacy.dart';
import '../sideMenu_item/profile_view.dart';
import '../sideMenu_item/terms_condition.dart';

Locale locale = const Locale('en', 'US');
class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  updateLanguage(String gg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("app_language", gg);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Drawer(
         backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName:  Get.find<AuthController>().isLoggedIn() ? Text(authController.getUserName()!,
          style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            height: 1
          ),) :
              Text('User',
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15
                ),),
              accountEmail: Get.find<AuthController>().isLoggedIn() ? Text(authController.getUserEmail()!,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  height: 1
                ),):
              Text(''),
              currentAccountPicture: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 26,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.cover,
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'assets/images/profile-bg3.jpg',)),
              ),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,

              leading:   Image.asset('assets/images/home.jpeg',
                  height: 18,
                  width: 20),
              title: Text(
                'Home'.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
              onTap: () => Get.back(),
            ),
            Get.find<AuthController>().isLoggedIn() ?
            Divider(
              color: Colors.grey,
              thickness: .2,) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              leading:   Image.asset('assets/images/profile.jpeg',
                  height: 18,
                  width: 20),
              title: Text('Profile'.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              onTap: () => Get.to(ProfileView()),
            ) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            Divider(
              color: Colors.grey,
              thickness: .2,) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              leading:   Image.asset('assets/images/orders.jpeg',
                  height: 18,
                  width: 20),
              title: Text('My Order'.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              onTap: () => Get.to(OrderList()),
            ) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            Divider(
              color: Colors.grey,
              thickness: .2,) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              leading:   Image.asset('assets/images/wallet.png',
                  color: Colors.black,
                  height: 18,
                  width: 20),
              title: Text('Wallet'.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              onTap: () => Get.to(WalletView()),
            ) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            Divider(
              color: Colors.grey,
              thickness: .2,) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              leading:  Image.asset('assets/images/payment-method.png',
                  color: Colors.black,
                  height: 18,
                  width: 20),
              title: Text('Payments'.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              onTap: () => Get.to(PaymentList()),
            ) : SizedBox.shrink(),

            Divider(
              color: Colors.grey,
              thickness: .2,),
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              leading: Image.asset('assets/images/languages.png',
                  color: Colors.black,
                  height: 18,
                  width: 20),
              title: Text('Language'.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffDCDCDC)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: RadioListTile(
                                      title: Text('हिन्दी'.tr),
                                      activeColor: const Color(0xff014E70),
                                      value: "Hindi",
                                      groupValue: authController.selectedLanguage.value,
                                      onChanged: (value) {
                                        locale = const Locale('hi', 'IN');
                                        authController.selectedLanguage.value = value!;
                                        updateLanguage("Hindi");
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
                                        color: AppColors.secondaryGradient,
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
            ),
            Divider(
              color: Colors.grey,
              thickness: .2,),
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              leading: Image.asset('assets/images/faq.png',
                  color: Colors.black,
                  height: 18,
                  width: 20),
              title: Text('FAQ'.tr,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              onTap: () => Get.to(FrequentlyAskedQuestionsScreen()),
            ),
            Divider(
              color: Colors.grey,
              thickness: .2,),
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              leading:  Image.asset('assets/images/customer-service.png',
                  color: Colors.black,
                  height: 18,
                  width: 20),
              title: Text('Contact Us'.tr,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              onTap: () => Get.to(ContactUsPage()),
            ),
            Divider(
              color: Colors.grey,
              thickness: .2,),
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              leading:  Image.asset('assets/images/pri.png',
                  color: Colors.black,
                  height: 18,
                  width: 20),
              title: Text('Privacy Policy'.tr,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              onTap: () => Get.to(PrivacyPolicyPage()),
            ),
            Divider(
              color: Colors.grey,
              thickness: .2,),
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              leading:  Image.asset('assets/images/file.png',
                  color: Colors.black,
                  height: 18,
                  width: 18),
              title: Text('Terms And Conditions'.tr,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              onTap: () => Get.to(TermsAndCondition()),
            ),
            Divider(
              color: Colors.grey,
              thickness: .2,),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              title: Text('Logout'.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              leading: Image.asset('assets/images/logout.png',
                color: Colors.red,
                height: 16,
                width: 16),
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();

                // ✅ Clear all stored preferences
                await prefs.clear();
                Get.to(RouteHelper.login);
              },
            ) :  ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              title: Text('Login',
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              leading:  Image.asset('assets/images/logout.png',
                  color: Colors.black,
                  height: 16,
                  width: 16),
              onTap: () {
                Get.to(LoginView());
              },
            ),
            Get.find<AuthController>().isLoggedIn() ?
            Divider(
              color: Colors.grey,
              thickness: .2,) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              dense: true,
              title: Text('Delete Account'.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                ),),
              leading: Image.asset('assets/images/trash.png',
              color: Colors.red,
              height: 20,
              width: 20),
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text(
                        'Delete Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Are you sure you want to delete your account?',
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {

                            authController.disableCustomr();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            )  : SizedBox(),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}