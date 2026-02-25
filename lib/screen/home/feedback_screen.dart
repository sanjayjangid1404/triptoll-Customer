import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:triptoll/screen/home/homeview.dart';

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
    if (_rating == 0 ) {
     Get.snackbar('Rating'.tr, 'Please provide rating'.tr,);
      return;
    }else {
      authController.feedBackFun(userID: authController.getUserID(),
          rating: _rating.toString(),
          feedback: _contactController.text.trim(),
          driverId: authController.driver!.driverDetails!.id.toString(),
          bookingId: widget.bookingID.id.toString());
          Get.offAll(()=> HomePage());

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Icon(Icons.arrow_back_ios,
              color: Colors.black,
              weight: 20,),
            )
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.topRight,
            child:  TextButton(
              onPressed: Get.back,
              child:  Text('Skip'.tr,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16, fontWeight: FontWeight.w500,
                    color: AppColors.secondaryGradient),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      const SizedBox(height: 10),

                      /// 👍 THUMBS UP ICON
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.thumb_up,
                          size: 45,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// TITLE
                      Text(
                        "How was your experience?".tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// SUBTITLE
                      Text(
                        "Your feedback helps us improve our service for you.".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// STAR RATING
                      RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemPadding: EdgeInsets.symmetric(horizontal: 5),
                        itemCount: 5,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Color(0xFFFFC107),
                        ),
                        unratedColor: Colors.grey.shade300,
                        glow: false,
                        itemSize: 40,
                        onRatingUpdate: (rating) => setState(() => _rating = rating),
                      ),

                      const SizedBox(height: 8),

                      /// TERRIBLE - EXCELLENT TEXT
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Terrible".tr,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              "Excellent".tr,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// WRITE REVIEW TITLE
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Write a review (Optional)".tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// TEXTFIELD
                      TextField(
                        controller: _contactController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Tell us what you enjoyed or how we can improve...".tr,
                          hintStyle: TextStyle(
                            fontSize: 13,
                            fontFamily: "Poppins",
                            color: Colors.grey.shade500,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const Spacer(),

                      /// ✅ BUTTON INSIDE BODY
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            AppColors.secondaryGradient,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _submit,
                          child: const Text(
                            "Submit Review",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
