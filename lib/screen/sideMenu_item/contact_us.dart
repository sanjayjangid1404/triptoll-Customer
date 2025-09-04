import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/util/appColors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/authController.dart';
import '../../model/faq_response_model.dart';
import '../../util/custom_snackbar.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  AuthController authController = Get.find<AuthController>();
  String? selectedFaqId;
  FaqDriverResponse? selectedFaq;
  Key _dropdownKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    authController.getDriverFAQ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryGradient,
        title: const Text(
          'Contact Support', style: TextStyle(color: Colors.white),),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            const Column(
              children: [
                Icon(Icons.headset_mic, size: 60, color: Colors.blue),
                SizedBox(height: 15),
                Text(
                  'How can we help you?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Our team is always here to assist you with any questions or concerns',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Contact Options Cards
            // _buildContactCard(
            //   icon: Icons.phone,
            //   title: "Call Support",
            //   subtitle: "Speak directly with our support team",
            //   color: Colors.green,
            //   onTap: () => _launchUrl('tel:+918818003344'),
            // ),
            // const SizedBox(height: 15),
            //
            // _buildContactCard(
            //   icon: Icons.chat,
            //   title: "WhatsApp Chat",
            //   subtitle: "Chat with us on WhatsApp",
            //   color: Colors.green,
            //   onTap: () => _launchUrl('https://wa.me/918818003344'),
            // ),
            // const SizedBox(height: 15),
            //
            // _buildContactCard(
            //   icon: Icons.email,
            //   title: "Email Us",
            //   subtitle: "Send us an email and we'll respond promptly",
            //   color: Colors.blue,
            //   onTap: () => _launchUrl('mailto:info@triptoll.in'),
            // ),


            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.language, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        "Company Website:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 34.0),
                    child: GestureDetector(
                      onTap: () {
                        // Handle website tap
                      },
                      child: Text(
                        "https://triptoll.in/",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[600],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Triptoll was founded in Aug 2024. we are a trusted and reliable logistics delivery service provider, dedicated to making your relocation experience smooth, efficient, and stress-free. ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Triptoll Help Desk",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 16),

                Obx(() {
                  return authController.isDataLoading.value == true ?
                    Container(
                    key: _dropdownKey,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedFaqId,
                      isExpanded: true,
                      underline: SizedBox(),
                      hint: Text("Choose a question"),
                      items: authController.faqDriverResponse.map((
                          FaqDriverResponse item) {
                        return DropdownMenuItem<String>(
                          value: item.id.toString(),
                          child: Text(item.title ?? ""),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue != null) {
                            selectedFaqId = newValue;
                            selectedFaq = authController.faqDriverResponse
                                .firstWhere((element) =>
                            element.id == newValue);
                          } else {
                            selectedFaq = null;
                          }
                        });
                      },
                    ),
                  ) : SizedBox.shrink();
                }),
              ],
            ),
            SizedBox(height: 32),
            // Submit Button
            _buildSubmitButton(),
            const SizedBox(height: 30),

            // Additional Information
            const Text(
              'Other Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.access_time, "Mon-Sat: 9:00 AM - 6:00 PM"),
            _buildInfoRow(Icons.location_on,
                "Delhi NCR, Jaipur, Mumbai, Chandigarh, Ahmedabad"),
            _buildInfoRow(Icons.language, "https://triptoll.in/"),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 22),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle submit action


          if (selectedFaqId != null) {
            authController.ticketRez({
              "driver_id":authController.getUserID().toString(),
              "faq_id":selectedFaqId.toString(),
              "user_type":"customer"

            });
          }
          else {
            showCustomSnackBar("select faq");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Text(
          "SUBMIT",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
