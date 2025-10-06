import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/screen/home/order_list.dart';
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
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(authController.getUserName()!),
              accountEmail: Text(authController.getUserEmail()!),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avtor.png',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text('Home'.tr),
              onTap: () => Get.back(),
            ),

            ListTile(
              leading: Icon(Icons.person_2_outlined),
              title: Text('Profile'.tr),
              onTap: () => Get.to(ProfileView()),
            ),
            ListTile(
              leading: Icon(Icons.file_present_outlined),
              title: Text('My Order'.tr),
              onTap: () => Get.to(OrderList()),
            ),
            ListTile(
              leading: Icon(Icons.wallet),
              title: Text('Wallet'.tr),
              onTap: () => Get.to(WalletView()),
            ),
            ListTile(
              leading: Icon(Icons.payment_outlined),
              title: Text('Payments'.tr),
              onTap: () => Get.to(PaymentList()),
            ),

            Divider(),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'.tr),
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
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('FAQ'.tr),
              onTap: () => Get.to(FrequentlyAskedQuestionsScreen()),
            ),
            ListTile(
              leading: Icon(Icons.contact_page_outlined),
              title: Text('Contact Us'.tr),
              onTap: () => Get.to(ContactUsPage()),
            ),
            ListTile(
              leading: Icon(Icons.policy_outlined),
              title: Text('Privacy Policy'.tr),
              onTap: () => Get.to(PrivacyPolicyPage()),
            ),

            ListTile(
              leading: Icon(Icons.policy_outlined),
              title: Text('Terms And Conditions'.tr),
              onTap: () => Get.to(TermsAndCondition()),
            ),
            // ListTile(
            //   leading: Icon(Icons.policy_outlined),
            //   title: Text('About Us'),
            //   onTap: () => null,
            // ),
            Divider(),
            // ListTile(
            //   title: Text('Refer & Earn'),
            //   leading: Icon(Icons.share_outlined),
            //   onTap: () => null,
            // ),

            ListTile(
              title: Text('Logout'.tr),
              leading: Icon(Icons.login_outlined),
              onTap: () => authController.logoutUser(),
            ),
          ],
        ),
      ),
    );
  }
}