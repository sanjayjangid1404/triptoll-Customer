import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/authController.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
 @override
  void initState() {
    super.initState();
    String cityID = Get.find<AuthController>().getCityID().toString();
    Get.find<AuthController>().getNotificationHistory({
      "user_type":'Customer',
      "city_id": cityID,
       });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        centerTitle: true,
        title: Text('Notification\'s'.tr,
          style: TextStyle(
              color: Colors.black
          ),),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Get.find<AuthController>().notificationHistoryModel.value.status == true ?
          Column(
            children: [
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: Get.find<AuthController>().notificationHistoryModel.value.notifications!.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) =>
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  final item = Get.find<AuthController>().notificationHistoryModel.value.notifications![index];
                  String dateTimeString = item.addDate.toString();
                  DateTime parsedDate = DateTime.parse(dateTimeString);
                  String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
                  return ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    title: Text(
                      item.message.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // subtitle: Text( item.message.toString()),
                    trailing: Text(
                      formattedDate.toString(),
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12),
                    ),
                  );
                },
              ),
              Get.find<AuthController>().notificationHistoryModel.value.notifications!.isEmpty?
              SizedBox(
                height: Get.height /2,
                child: Center(
                  child: Text('New Notification\'s\nNot Found',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),
                     textAlign: TextAlign.center,
                  ),
                ),
              ) :
              SizedBox()
            ],
          ) :
          SizedBox();
        }),
      ),
    );
  }
}
