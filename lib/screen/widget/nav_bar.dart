import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/screen/home/order_list.dart';
import '../../auth/loginView.dart';
import '../../util/appColors.dart';
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
              accountName:  Get.find<AuthController>().isLoggedIn() ? Text(authController.getUserName()!) :
              Text('User'),
              accountEmail: Get.find<AuthController>().isLoggedIn() ? Text(authController.getUserEmail()!) :
              Text(''),
              currentAccountPicture: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
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
              leading: Icon(Icons.home_outlined),
              title: Text('Home'.tr),
              onTap: () => Get.back(),
            ),
            Get.find<AuthController>().isLoggedIn() ?
            Divider(
              color: Colors.grey,
              thickness: .2,) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.person_2_outlined),
              title: Text('Profile'.tr),
              onTap: () => Get.to(ProfileView()),
            ) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            Divider(
              color: Colors.grey,
              thickness: .2,) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.file_present_outlined),
              title: Text('My Order'.tr),
              onTap: () => Get.to(OrderList()),
            ) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            Divider(
              color: Colors.grey,
              thickness: .2,) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.wallet),
              title: Text('Wallet'.tr),
              onTap: () => Get.to(WalletView()),
            ) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            Divider(
              color: Colors.grey,
              thickness: .2,) : SizedBox.shrink(),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.payment_outlined),
              title: Text('Payments'.tr),
              onTap: () => Get.to(PaymentList()),
            ) : SizedBox.shrink(),

            Divider(
              color: Colors.grey,
              thickness: .2,),
            ListTile(
              visualDensity: VisualDensity.compact,
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
              leading: Icon(Icons.info_outline),
              title: Text('FAQ'.tr),
              onTap: () => Get.to(FrequentlyAskedQuestionsScreen()),
            ),
            Divider(
              color: Colors.grey,
              thickness: .2,),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.contact_page_outlined),
              title: Text('Contact Us'.tr),
              onTap: () => Get.to(ContactUsPage()),
            ),
            Divider(
              color: Colors.grey,
              thickness: .2,),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.policy_outlined),
              title: Text('Privacy Policy'.tr),
              onTap: () => Get.to(PrivacyPolicyPage()),
            ),
            Divider(
              color: Colors.grey,
              thickness: .2,),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.policy_outlined),
              title: Text('Terms And Conditions'.tr),
              onTap: () => Get.to(TermsAndCondition()),
            ),
            Divider(
              color: Colors.grey,
              thickness: .2,),
            Get.find<AuthController>().isLoggedIn() ?
            ListTile(
              visualDensity: VisualDensity.compact,
              title: Text('Logout'.tr),
              leading: Icon(Icons.login_outlined,color: Colors.red),
              onTap: () => authController.logoutUser(),
            ) :  ListTile(
              visualDensity: VisualDensity.compact,
              title: Text('Login'),
              leading: Icon(Icons.login_outlined),
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
              title: Text('Delete Account'.tr),
              leading: Icon(Icons.delete,color: Colors.red,),
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