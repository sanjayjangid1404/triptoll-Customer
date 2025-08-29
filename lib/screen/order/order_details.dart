import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/util/appContants.dart';

import '../../util/appColors.dart';

class OrderDetails extends StatefulWidget {
  String bookingID;
   OrderDetails({super.key,required this.bookingID});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {


      Get.find<AuthController>().getBookingDetails(bookingID: widget.bookingID);

      setState(() {

      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController ) =>
       Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColors.primaryGradient,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Trip Details",style: TextStyle(fontSize: 18,color: Colors.white),),

        ),

        body:!authController.isBookingDetails && authController.bookingDetailsResponse!=null ?
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("#${authController.bookingDetailsResponse!.orderId??""}",style: TextStyle(fontSize: 32,color: AppColors.secondaryGradient),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(authController.bookingDetailsResponse!.addDate!=null ? "${AppContants.changeDateFormat(authController.bookingDetailsResponse!.addDate!, "dd MMM yyyy")}":"",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.w400),),
                        Text("${authController.bookingDetailsResponse!.orderStatus!.toUpperCase()}",style: TextStyle(fontSize: 14,color: AppColors.primaryGradient,fontWeight: FontWeight.w400),),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(child: Text("${authController.bookingDetailsResponse!.pickupAddress!}",maxLines: 2,))

                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(child: Text("${authController.bookingDetailsResponse!.dropAddress!}",maxLines: 2,))

                  ],
                ),
                SizedBox(height: 10,),
                Divider(color: Colors.black.withOpacity(0.2),thickness: 0.7,),
                SizedBox(height: 10,),
                SizedBox(height: 20,),

                Text("Vehicle Details",style: TextStyle(fontSize: 24,color: AppColors.secondaryGradient),),

                SizedBox(height: 10,),

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
                        child: Image.network(authController.bookingDetailsResponse!.vehicleImg!=null ? "${AppContants.imageURL}uploaded_files/category_img/${authController.bookingDetailsResponse!.vehicleImg}":"https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png",height: 70,)),
                    Expanded(
                        flex:7,
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("${authController.bookingDetailsResponse!.categoryName??"EV"}",style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w700),),
                          //  Text("3 Wheeler",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w400),),
                            Text("${authController.bookingDetailsResponse!.weight??"80"} ${authController.bookingDetailsResponse!.weightType??"Kg"}",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w400),),

                            Text("${AppContants.rupessSystem}${authController.bookingDetailsResponse!.totalAmount!}",style: TextStyle(fontSize: 18,color: AppColors.primaryGradient,fontWeight: FontWeight.w700),),
                          ],
                        ))


                  ],
                ),

              ),

                SizedBox(height: 10,),
                SizedBox(height: 20,),

                Text("Amount Details",style: TextStyle(fontSize: 24,color: AppColors.secondaryGradient),),

                SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Amount",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                      Text("${AppContants.rupessSystem}${authController.bookingDetailsResponse!.amount!}",style: TextStyle(fontSize: 16,color: Colors.black),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Discount(10%)",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                      Text("${AppContants.rupessSystem}${authController.bookingDetailsResponse!.discount!}",style: TextStyle(fontSize: 16,color: Colors.black),),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text("Net Fare",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                //       Text("${AppContants.rupessSystem}${authController.bookingDetailsResponse!.!}",style: TextStyle(fontSize: 16,color: Colors.black),),
                //     ],
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Stop Charge",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                      Text("${AppContants.rupessSystem}${authController.bookingDetailsResponse!.stopCharge!}",style: TextStyle(fontSize: 16,color: Colors.black),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6)),),
                      Text("${AppContants.rupessSystem}${authController.bookingDetailsResponse!.totalAmount!}",style: TextStyle(fontSize: 16,color: Colors.black),),
                    ],
                  ),
                ),

                SizedBox(height: 30,),

                authController.bookingDetailsResponse!.orderStatus.toString().toLowerCase() == "new" || authController.bookingDetailsResponse!.orderStatus.toString().toLowerCase() == "accpeted"  || authController.bookingDetailsResponse!.orderStatus.toString().toLowerCase() == "accepted" ?  InkWell(
                  onTap: (){
                    AppContants.showNoteBottomSheet(context,authController,authController.bookingDetailsResponse!.id.toString(),true,Get.back());

                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.secondaryGradient
                    ),
                    child: Text("Cancel Order",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w700),),
                  ),
                ):SizedBox()






              ],
            ),
          ),
        ):Center(child: CircularProgressIndicator(color: AppColors.primaryGradient,),),
      ),
    );
  }
}
