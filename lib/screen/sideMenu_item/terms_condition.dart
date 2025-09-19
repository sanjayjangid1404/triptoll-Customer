import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({super.key});

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<TermsAndCondition> {
  String htmlContent = "";
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    loadHtml();
  }

  Future<void> loadHtml() async {
    final String fileText = await rootBundle.loadString("assets/terms_and_condition.html");
    setState(() {
      htmlContent = fileText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Terms & Conditions",style: TextStyle(color: Colors.black),),

      ),
      body: htmlContent.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Html(
            data: htmlContent,
            style: {
              "p": Style(fontSize: FontSize(16), lineHeight: LineHeight(1.6)),
              "li": Style(fontSize: FontSize(16)),
              "strong": Style(fontWeight: FontWeight.bold),
            },
              onLinkTap: (url, attributes, element) {
                if (url != null) {
                  final isPhone = RegExp(r'^\+?\d+$').hasMatch(url);
                  final launchUrlStr = isPhone ? 'tel:$url' : url;
                  _launchURL(launchUrlStr);
                }
              }
          ),
        ),
      ),
    );
  }
}
