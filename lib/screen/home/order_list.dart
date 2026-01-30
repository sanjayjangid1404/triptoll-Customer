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
    "New",
    "Scheduled",
    "Accepted",
    "Paid",
    "Cancelled",
  ];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {


      Get.find<AuthController>().getAllBooking(status: selectedOrderType.toLowerCase(),limit: "100",offset: "10");

      setState(() {

      });

    });
  }
  void showCancelDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Do you really want to cancel this order?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                            Get.find<AuthController>().cancelOrder(
                              bookingID: bookingId,
                              reason: "cancel by customer",
                              comment: "cancelled",
                              isOrder: true,
                            );
                            Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Yes, Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                        ),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
          title: Text("My Order".tr,style: TextStyle(fontSize: 18,color: Colors.white),),
          actions: [
            Text(selectedOrderType,style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),),
            PopupMenuButton<String>(
              color: Colors.white,
              icon: Icon(Icons.more_vert),
              onSelected: (String value) {
                setState(() {
                  selectedOrderType = value;
                  Get.find<AuthController>().getAllBooking(status: selectedOrderType.toLowerCase(),limit: "100",offset: "10");
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
              authController.bookingListResponse.value.orders != null ?
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: authController.bookingListResponse.value.orders!.length,
                itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Get.to(OrderDetails(bookingID: authController.bookingListResponse.value.orders![index].id.toString(),));

                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${'Order'.tr} #: ${authController.bookingListResponse.value.orders![index].orderId}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    AppContants.changeDateFormat(authController.bookingListResponse.value.orders![index].addDate!, "dd MMM yyyy"),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text("${'Payment Type is'.tr} ${authController.bookingListResponse.value.orders![index].paymentType!}", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300)),
                                  ),
                                ],
                              ),
                            ),

                            // Price and Status
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${AppContants.rupessSystem}${authController.bookingListResponse.value.orders![index].totalAmount!}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor("${authController.bookingListResponse.value.orders![index].paymentType!}"),
                                    border: Border.all(color: _getStatusTextColor("${authController.bookingListResponse.value.orders![index].paymentType!}")),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    authController.bookingListResponse.value.orders![index].orderStatus!.toString(),
                                    style: TextStyle(
                                      color: _getStatusTextColor("${authController.bookingListResponse.value.orders![index].paymentType!}"),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        if (authController.bookingListResponse.value.orders![index].orderStatus == 'new' ||
                            authController.bookingListResponse.value.orders![index].orderStatus == 'scheduled')
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: InkWell(
                              onTap: () {
                                showCancelDialog(
                                  context,
                                  authController.bookingListResponse.value.orders![index].id.toString(),
                                );
                              },
                              child: Container(
                                width: Get.width,
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },) :
                  SizedBox()
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
