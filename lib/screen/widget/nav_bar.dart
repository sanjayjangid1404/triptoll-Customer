import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/screen/home/order_list.dart';

import '../payment/payment_list.dart';
import '../sideMenu_item/contact_us.dart';
import '../sideMenu_item/profile_view.dart';

class NavBar extends StatelessWidget {
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
              title: Text('Home'),
              onTap: () => Get.back(),
            ),

            ListTile(
              leading: Icon(Icons.person_2_outlined),
              title: Text('Profile'),
              onTap: () => Get.to(ProfileView()),
            ),
            ListTile(
              leading: Icon(Icons.file_present_outlined),
              title: Text('My Order'),
              onTap: () => Get.to(OrderList()),
            ),
            ListTile(
              leading: Icon(Icons.payment_outlined),
              title: Text('Payments'),
              onTap: () => Get.to(PaymentList()),
            ),

            Divider(),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('FAQ'),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.contact_page_outlined),
              title: Text('Contact Us'),
              onTap: () => Get.to(ContactUsPage()),
            ),
            ListTile(
              leading: Icon(Icons.policy_outlined),
              title: Text('Privacy Policy'),
              onTap: () => null,
            ),

            ListTile(
              leading: Icon(Icons.policy_outlined),
              title: Text('Terms And Conditions'),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.policy_outlined),
              title: Text('About Us'),
              onTap: () => null,
            ),
            Divider(),
            ListTile(
              title: Text('Refer & Earn'),
              leading: Icon(Icons.share_outlined),
              onTap: () => null,
            ),

            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.login_outlined),
              onTap: () => authController.logoutUser(),
            ),
          ],
        ),
      ),
    );
  }
}