import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../controller/authController.dart';
import '../../model/booking_details_response.dart';
import '../../util/appColors.dart';

class FeedbackBottomSheet extends StatefulWidget {
   FeedbackBottomSheet({super.key, required this.bookingID,});
   BookingDetailsResponse bookingID;
  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  double _rating = 0;
  final _contactController = TextEditingController();

  AuthController authController = Get.find<AuthController>();
  void _submit() {
    if (_rating == 0 || _contactController.text.isEmpty) {
     Get.snackbar('Rating', 'Please provide rating',);
      return;
    }else {
      authController.feedBackFun(userID: authController.getUserID(),
          rating: _rating.toString(),
          feedback: _contactController.text.trim(),
          driverId: authController.driver!.driverDetails!.id.toString(),
          bookingId: widget.bookingID.id.toString());
      Navigator.pop(context);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child:  TextButton(
                onPressed: Get.back,
               child:  Text('Skip',
                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,
                     color: AppColors.secondaryGradient),
               ),
              ),
            ),
            const Text(
              'Rating For Driver',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
                height: 20),
            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                glow: false,
                unratedColor: Colors.grey,
                onRatingUpdate: (rating) => setState(() => _rating = rating),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write review here (Optional)',
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey
                )
              ),
              keyboardType: TextInputType.text,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGradient,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  _submit();
                },
                child: Text("Submit", style: TextStyle(fontSize: 18,color: Colors.white)),
              )
            ),
          ],
        ),
      ),
    );
  }
}
