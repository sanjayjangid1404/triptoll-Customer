import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/controller/authController.dart';

import '../../model/vehicle_data.dart';
import '../../util/appColors.dart';
import '../../util/appContants.dart';
import 'package:http/http.dart' as http;

class ReviewBooking extends StatefulWidget {
  final Map<String, dynamic> data;
  const ReviewBooking({super.key,required this.data});

  @override
  State<ReviewBooking> createState() => _ReviewBookingState();
}

class _ReviewBookingState extends State<ReviewBooking> {

  double discountPercentage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchDiscount();

    setState(() {

    });
  }
  Future<String?> fetchDiscountPercentage() async {
    final url = Uri.parse('${AppContants.baseURl}Home/contactUsInfo');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List contacts = data['contact'];

        // Find the item with type "discount"
        final discountItem = contacts.firstWhere(
              (item) => item['type'] == 'discount',
          orElse: () => null,
        );

        if (discountItem != null) {
          return discountItem['description']; // e.g., "10"
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return null; // In case of error or not found
  }

  void fetchDiscount() async {
    final discount = await fetchDiscountPercentage();
    if (discount != null) {
      setState(() {
        discountPercentage = double.tryParse(discount) ?? 0;
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    final String pickAddress = widget.data['pickAddress'];
    final String dropAddress = widget.data['dropAddress'];
    final String sendName = widget.data['sendName'];
    final String sendMobile = widget.data['sendMobile'];
    final String sendNo = widget.data['sendNo'];
    final double pickLat = widget.data['pickLat'];
    final double pickLng = widget.data['pickLng'];
    final double dropLat = widget.data['dropLat'];
    final double dropLng = widget.data['dropLng'];
    final double distanceInKm = widget.data['distanceInKm'];
    final double rate = widget.data['rate'];
    final double totalFare = widget.data['totalFare'];
    final vehicleData = Data.fromJson(widget.data['vehicleData']); // your custom model

    final double discountAmount = (totalFare * discountPercentage) / 100;
    final double netFare = totalFare - discountAmount;
    final double totalAmount = totalFare - discountAmount;

    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: AppColors.primaryGradient,
          title: Text("Review Booking",style: TextStyle(color: Colors.white),),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(

                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex:3,
                        child: Image.network("${AppContants.imageURL}uploaded_files/category_img/${vehicleData.fileName}",height: 70,)),
                    Expanded(
                        flex:7,
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(vehicleData.name!,style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w700),),
                           // Text("3 Wheeler",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w400),),
                            Text("${vehicleData.maxLoad!} Kg",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w400),),

                           // Text("${AppContants.rupessSystem}400",style: TextStyle(fontSize: 18,color: AppColors.primaryGradient,fontWeight: FontWeight.w700),),
                          ],
                        ))


                  ],
                ),

              ),

              SizedBox(height: 20,),

              Text("Amount Details",style: TextStyle(fontSize: 24,color: AppColors.secondaryGradient),),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Amount",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                    Text("${AppContants.rupessSystem}${totalFare.toStringAsFixed(0)}",style: TextStyle(fontSize: 16,color: Colors.black),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Discount($discountPercentage%)",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                    Text("${AppContants.rupessSystem} ${discountAmount.toStringAsFixed(0)}",style: TextStyle(fontSize: 16,color: Colors.black),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Net Fare",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                    Text("${AppContants.rupessSystem} ${netFare.toStringAsFixed(0)}",style: TextStyle(fontSize: 16,color: Colors.black),),
                  ],
                ),
              ),

             /* Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Stop Charge",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                    Text("${AppContants.rupessSystem}300",style: TextStyle(fontSize: 16,color: Colors.black),),
                  ],
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                    Text("${AppContants.rupessSystem} ${totalAmount.toStringAsFixed(0)}",style: TextStyle(fontSize: 16,color: Colors.black),),
                  ],
                ),
              ),
            ],
          ),
        ),

        bottomSheet: InkWell(
          onTap: (){
            authController.bookingNow(distance: '',expectedTime: '',amount: totalFare.toStringAsFixed(0), categoryId: "", categoryName: "", discount: discountAmount.toStringAsFixed(0), discountPercentage: discountPercentage.toStringAsFixed(0), dropAddress: dropAddress, dropAddressHeading: "", dropLat: dropLat.toString(), dropLong: dropLng.toString(), paymentType: "Cash", pickupAddress: pickAddress, pickupHeading: "", pickupLat: pickLat.toString(), pickupLong: pickLng.toString(), rate: rate.toString(), receiverContactNumber: sendMobile, receiverName: sendName, stopAddress: "", stopCharge: "", totalAmount: totalAmount.toStringAsFixed(0), totalDistance: distanceInKm.toStringAsFixed(0), vehicleId: vehicleData.id.toString(), vehicleImg: vehicleData.fileName.toString(), vehicleName: vehicleData.name.toString());


          },
          child: Container(height: 45,
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.secondaryGradient
            ),
            child: Text("Book ${vehicleData.name}",style: TextStyle(fontSize: 16,color: Colors.white),),
          ),
        ),

      ),
    );
  }
}
