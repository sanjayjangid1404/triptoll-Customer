import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> logOtpError({
  required String enteredOtp,
  required String apiOtp,
  required String phone,
}) async {
  try {
    await FirebaseFirestore.instance.collection('otp_errors').add({
      'enteredOtp': enteredOtp,
      'apiOtp': apiOtp, // production me mask kar dena
      'phone': phone,
      'timestamp': FieldValue.serverTimestamp(),
      'platform': 'flutter',
    });
  } catch (e) {
    print("Firestore log failed: $e");
  }
}