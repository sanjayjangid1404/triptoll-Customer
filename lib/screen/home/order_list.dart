import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:triptoll/util/appColors.dart';
import 'package:triptoll/util/appContants.dart';
import '../../util/app_fonts.dart';
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
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  DateTime? selectedDateTimeIos;
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
        body: RefreshIndicator(
          onRefresh: () {
           return Get.find<AuthController>().getAllBooking(status: selectedOrderType.toLowerCase(),limit: "100",offset: "10");
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                authController.bookingListResponse.value.orders != null ?
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: authController.bookingListResponse.value.orders!.length,
                  itemBuilder: (context, index) {
                    final item = authController.bookingListResponse.value.orders![index];
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
                          SizedBox(height: 10,),
                          authController.bookingListResponse.value.orders![index].orderStatus == 'cancelled'  ||
                              authController.bookingListResponse.value.orders![index].orderStatus == 'paid'
                              ?
                          SizedBox(
                            width: Get.width,
                            height: 35,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              onPressed: (){
                                DateTime? selectedDate = DateTime.now();
                                  TimeOfDay? selectedTime;

                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setModalState) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 12,
                                              bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 20,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                            ),
                                            child: SafeArea(
                                              top: false,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      width: 40,
                                                      height: 4,
                                                      margin: const EdgeInsets.only(bottom: 14),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey.shade300,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                  ),

                                                  /// 🔹 Title
                                                  const Center(
                                                    child: Text(
                                                      "Delivery",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(height: 20),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        selectedDateTimeIos = null;
                                                      });
                                                      DateTime? picked = await showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime.now(),
                                                        lastDate: DateTime.now().add(const Duration(days: 1)), // 🔒 max tomorrow
                                                        builder: (context, child) {
                                                          return Theme(
                                                            data: Theme.of(context).copyWith(
                                                              colorScheme: const ColorScheme.light(
                                                                primary: Colors.black,
                                                                onPrimary: Colors.white,
                                                                onSurface: Colors.black,
                                                              ),
                                                              dialogBackgroundColor: Colors.white,
                                                            ),
                                                            child: child!,
                                                          );
                                                        },
                                                      );

                                                      if (picked != null) {
                                                        setModalState(() {
                                                          selectedDate = picked;
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.grey.shade300),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.calendar_today, size: 18),
                                                          const SizedBox(width: 10),
                                                          Text(
                                                            selectedDate == null
                                                                ? "Select Date"
                                                                : DateFormat('dd MMM yyyy').format(selectedDate!),
                                                            style: const TextStyle(fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if(selectedDate == null){
                                                        Get.snackbar(
                                                            "Error",
                                                            "Please select date first",
                                                            backgroundColor: Colors.red,
                                                            colorText: Colors.white
                                                        );
                                                        return;
                                                      }
                                                      else {
                                                        showCupertinoModalPopup(
                                                          context: context,
                                                          builder: (_) {
                                                            DateTime now = DateTime.now();

                                                            DateTime selectedDay = selectedDate ?? now;

                                                            DateTime minTimeToday = now.add(const Duration(minutes: 30));

                                                            DateTime tempDateTime = selectedDateTimeIos ??
                                                                DateTime(
                                                                  selectedDay.year,
                                                                  selectedDay.month,
                                                                  selectedDay.day,
                                                                  minTimeToday.hour,
                                                                  minTimeToday.minute,
                                                                );

                                                            bool isToday = isSameDay(selectedDay, now);

                                                            return Container(
                                                              height: 300,
                                                              color: Colors.white,
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    alignment: Alignment.centerRight,
                                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                    child: CupertinoButton(
                                                                      padding: EdgeInsets.zero,
                                                                      onPressed: () {
                                                                        setModalState(() {
                                                                          selectedDateTimeIos = tempDateTime;
                                                                        });
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: const Text(
                                                                        "Done",
                                                                        style: TextStyle(
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight.w600,
                                                                          color: CupertinoColors.activeBlue,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: CupertinoDatePicker(
                                                                      mode: CupertinoDatePickerMode.time,
                                                                      use24hFormat: false,
                                                                      initialDateTime: tempDateTime,
                                                                      minimumDate: isToday
                                                                          ? DateTime(
                                                                        selectedDay.year,
                                                                        selectedDay.month,
                                                                        selectedDay.day,
                                                                        minTimeToday.hour,
                                                                        minTimeToday.minute,
                                                                      )
                                                                          : null,

                                                                      onDateTimeChanged: (DateTime newTime) {
                                                                        HapticFeedback.selectionClick();

                                                                        tempDateTime = DateTime(
                                                                          selectedDay.year,
                                                                          selectedDay.month,
                                                                          selectedDay.day,
                                                                          newTime.hour,
                                                                          newTime.minute,
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );

                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.grey.shade300),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.access_time, size: 18),
                                                          const SizedBox(width: 10),
                                                          Text(
                                                            selectedDateTimeIos == null
                                                                ? "Select Time"
                                                                : TimeOfDay.fromDateTime(selectedDateTimeIos!).format(context),
                                                            style: const TextStyle(fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 14),
                                                  Text('* You can schedule your delivery within the next 24 hours only.'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                  const SizedBox(height: 24),

                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:ElevatedButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.grey,
                                                            padding: EdgeInsets.symmetric(vertical: 12),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),

                                                          child: const Text(
                                                            "Cancel",
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            if (selectedDate == null || selectedDateTimeIos == null) {
                                                              Get.snackbar(
                                                                  "Error",
                                                                  "Please select date & time",
                                                                  backgroundColor: Colors.red,
                                                                  colorText: Colors.white
                                                              );
                                                              return;
                                                            }

                                                            final selectedDateTime = DateTime(
                                                              selectedDate!.year,
                                                              selectedDate!.month,
                                                              selectedDate!.day,
                                                              selectedDateTimeIos!.hour,
                                                              selectedDateTimeIos!.minute,
                                                            );

                                                            final now = DateTime.now();
                                                            final maxTime = now.add(const Duration(hours: 24));

                                                            if (selectedDateTime.isBefore(now)) {
                                                              Get.snackbar(
                                                                  "Invalid Time",
                                                                  "Please select a future time",
                                                                  backgroundColor: Colors.red,
                                                                  colorText: Colors.white
                                                              );
                                                              return;
                                                            }
                                                            if (selectedDateTime.isAfter(maxTime)) {
                                                              Get.snackbar(
                                                                  "Invalid Schedule",
                                                                  "You can schedule only within next 24 hours",
                                                                  backgroundColor: Colors.red,
                                                                  colorText: Colors.white
                                                              );
                                                              return;
                                                            }
                                                            final Duration difference = selectedDateTime.difference(now);

                                                            final int hours = difference.inHours;
                                                            final int minutes = difference.inMinutes.remainder(60);

                                                            // 🔹 PRINT
                                                            print("Scheduled After: $hours hours $minutes minutes");
                                                            Get.back();

                                                            String formattedTime =
                                                                '${selectedDateTimeIos!.hour.toString().padLeft(2, '0')}:${selectedDateTimeIos!.minute.toString().padLeft(2, '0')}';
                                                            String onlyDate =
                                                            DateFormat('yyyy-MM-dd').format(selectedDate!);
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible: false,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  backgroundColor: Colors.white,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                  title: const Text(
                                                                    "Confirm Booking",
                                                                    style: TextStyle(
                                                                      fontFamily: "Poppins",
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 19,
                                                                    ),
                                                                  ),
                                                                  content: const Text(
                                                                    "Are you sure you want to continue this booking?",
                                                                    style: TextStyle(
                                                                      fontFamily: "Poppins",
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 12,
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(context); // cancel
                                                                      },
                                                                      child: const Text("Cancel",
                                                                        style: TextStyle(
                                                                          fontFamily: "Poppins",
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: 15,
                                                                        ),),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                        List<Map<String, dynamic>> stopLocations = [];

          // 1️⃣ Pickup add karo
                                                                        if (authController.getReorderDataModel.value.pickup != null) {
                                                                          var pickup = authController.getReorderDataModel.value.pickup;

                                                                          stopLocations.add({
                                                                            "type": "pickup",
                                                                            "lat": double.parse(pickup!.lat),
                                                                            "lng": double.parse(pickup.lng),
                                                                            "address": pickup.address,
                                                                            "sequence": 1,
                                                                            "name": pickup.name.toString(),
                                                                            "contact_number": pickup.contactNumber.toString(),
                                                                            "loading_charge": '',
                                                                            "loading_time": '',
                                                                            "loading_duration": '',
                                                                          });
                                                                        }

          // 2️⃣ Dropoffs add karo
                                                                        if (authController.getReorderDataModel.value.dropoffs != null) {
                                                                          List dropoffs = authController.getReorderDataModel.value.dropoffs!;

                                                                          for (var drop in dropoffs) {
                                                                            stopLocations.add({
                                                                              "type": "drop",
                                                                              "lat": double.parse(drop.lat),
                                                                              "lng": double.parse(drop.lng),
                                                                              "address": drop.address,
                                                                              "sequence": int.parse(drop.sequence),
                                                                              "name": drop.name.toString(),
                                                                              "contact_number": drop.contactNumber.toString(),
                                                                              "unloading_charge": '',
                                                                              "unloading_time": '',
                                                                              "unloading_duration": '',
                                                                            });
                                                                          }
                                                                        }
                                                                        String pickupOtp = (1000 + Random().nextInt(9000)).toString();
                                                                        print('pickupOtp ::${pickupOtp}');
                                                                        authController.bookingMultipleNow(
                                                                          pickupOtp: pickupOtp,
                                                                          distance:authController.getReorderDataModel.value.distance.toString(),
                                                                          expectedTime: authController.getReorderDataModel.value.expectedTime.toString(),
                                                                          amount: authController.getReorderDataModel.value.amount.toString(),
                                                                          totalAmount:authController.getReorderDataModel.value.totalAmount.toString(),
                                                                          categoryId: authController.getReorderDataModel.value.categoryId.toString(),
                                                                          categoryName: "",
                                                                          scheduleTime: formattedTime.toString(),
                                                                          scheduleDate: onlyDate.toString(),
                                                                          senderNameText: authController.getReorderDataModel.value.senderName.toString(),
                                                                          senderPhone: authController.getReorderDataModel.value.senderContactNumber.toString(),
                                                                          discount: "0",
                                                                          discountPercentage: "0",
                                                                          dropAddress: authController.getReorderDataModel.value.dropoffs![0].address.toString(),
                                                                          dropAddressHeading: "",
                                                                          dropLat: authController.getReorderDataModel.value.dropoffs![0].lat.toString(),
                                                                          dropLong:authController.getReorderDataModel.value.dropoffs![0].lng.toString(),
                                                                          paymentType: authController.getReorderDataModel.value.paymentType.toString(),
                                                                          pickupAddress:authController.getReorderDataModel.value.pickup!.address.toString(),
                                                                          pickupHeading: "",
                                                                          pickupLat: authController.getReorderDataModel.value.pickup!.lat.toString(),
                                                                          pickupLong: authController.getReorderDataModel.value.pickup!.lng.toString(),
                                                                          rate: authController.getReorderDataModel.value.rate.toString(),
                                                                          receiverContactNumber: authController.getReorderDataModel.value.receiverContactNumber.toString(),
                                                                          receiverName: authController.getReorderDataModel.value.receiverName.toString(),
                                                                          stopAddress: "lastStopLocation[address]",
                                                                          stopCharge: "",
                                                                          totalDistance: authController.getReorderDataModel.value.totalDistanceTravelled.toString(),
                                                                          vehicleId: "",
                                                                          vehicleImg: "",
                                                                          vehicleName:authController.getReorderDataModel.value.name.toString(),
                                                                          stopLocations: stopLocations,
                                                                        );
                                                                        Get.find<AuthController>().getAllBooking(status: selectedOrderType.toLowerCase(),limit: "100",offset: "10");

                                                                      },
                                                                      child: const Text("OK",
                                                                        style: TextStyle(
                                                                          fontFamily: "Poppins",
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w500,
                                                                          fontSize: 15,
                                                                        ),),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.blue,
                                                            padding: EdgeInsets.symmetric(vertical: 12),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),

                                                          child: const Text(
                                                            "Confirm",
                                                            style: TextStyle(color: Colors.white),
                                                          ),
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
                                    },
                                  );
                                Get.find<AuthController>().getBookingDetailsReorder(bookingID: item.id.toString());
                                print('himpreet ${ item.id.toString()}');
                              },
                              child: Text("Re Order",
                                  style:  TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.poppinsRegular,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ) :
                          SizedBox.shrink(),
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
