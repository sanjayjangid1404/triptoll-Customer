import 'package:flutter/material.dart';
import 'package:triptoll/util/appColors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryGradient,
        title: const Text('Contact Support',style: TextStyle(color: Colors.white),),
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
            _buildContactCard(
              icon: Icons.phone,
              title: "Call Support",
              subtitle: "Speak directly with our support team",
              color: Colors.green,
              onTap: () => _launchUrl('tel:+918818003344'),
            ),
            const SizedBox(height: 15),

            _buildContactCard(
              icon: Icons.chat,
              title: "WhatsApp Chat",
              subtitle: "Chat with us on WhatsApp",
              color: Colors.green,
              onTap: () => _launchUrl('https://wa.me/918818003344'),
            ),
            const SizedBox(height: 15),

            _buildContactCard(
              icon: Icons.email,
              title: "Email Us",
              subtitle: "Send us an email and we'll respond promptly",
              color: Colors.blue,
              onTap: () => _launchUrl('mailto:info@triptoll.in'),
            ),
            const SizedBox(height: 30),

            // Additional Information
            const Text(
              'Other Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildInfoRow(Icons.access_time, "Mon-Sat: 9:00 AM - 6:00 PM"),
            _buildInfoRow(Icons.location_on, "Delhi NCR, Jaipur, Mumbai, Chandigarh, Ahmedabad"),
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
}