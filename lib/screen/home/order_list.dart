import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/util/appColors.dart';
import 'package:triptoll/util/appContants.dart';

import '../order/order_details.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {

  String selectedOrderType = "All";

  final List<String> orderTypes = [
    "All",
    "Pending",
    "Accepted",
    "Close",
    "Cancelled",
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {


      Get.find<AuthController>().getAllBooking(status: selectedOrderType.toLowerCase(),limit: "10",offset: "10");

      setState(() {

      });

    });
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: ( authController) =>
       Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColors.primaryGradient,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("My Order",style: TextStyle(fontSize: 18,color: Colors.white),),
          actions: [
            Text(selectedOrderType,style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (String value) {
                setState(() {
                  selectedOrderType = value;
                });
                print("Selected Order Type: $value");
              },
              itemBuilder: (BuildContext context) {
                return orderTypes.map((String type) {
                  return PopupMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: authController.bookingListResponse!.length,
                itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Get.to(OrderDetails(bookingID: authController.bookingListResponse![index]!.id.toString(),));

                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #: ${authController.bookingListResponse![index]!.orderId}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${AppContants.changeDateFormat(authController.bookingListResponse![index]!.addDate!, "dd MMM yyyy")}",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text("Payment Type is ${authController.bookingListResponse![index]!.paymentType!}", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300)),
                              ),
                            ],
                          ),
                        ),

                        // Price and Status
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${AppContants.rupessSystem}${authController.bookingListResponse![index]!.totalAmount!}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor("${authController.bookingListResponse![index]!.paymentType!}"),
                                border: Border.all(color: _getStatusTextColor("${authController.bookingListResponse![index]!.paymentType!}")),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${authController.bookingListResponse![index]!.orderStatus!.toString()}",
                                style: TextStyle(
                                  color: _getStatusTextColor("${authController.bookingListResponse![index]!.paymentType!}"),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },)
            ],
          ),
        ),
      ),
    );
  }


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'reject':
        return Colors.deepPurple.shade100;
      case 'accepted':
        return Colors.orange.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      case 'close':
        return Colors.grey.shade300;
      default:
        return Colors.grey.shade200;
    }
  }
  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'reject':
        return Colors.red;
      case 'accepted':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'close':
        return Colors.black87;
      default:
        return Colors.black54;
    }
  }
}
