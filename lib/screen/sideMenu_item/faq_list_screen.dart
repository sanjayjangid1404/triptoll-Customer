import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/authController.dart';


class FrequentlyAskedQuestionsScreen extends StatefulWidget {
  const FrequentlyAskedQuestionsScreen({super.key});

  @override
  State<FrequentlyAskedQuestionsScreen> createState() =>
      _FrequentlyAskedQuestionsScreenState();
}

class _FrequentlyAskedQuestionsScreenState
    extends State<FrequentlyAskedQuestionsScreen> {

  bool senderExpansion = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getFaqListFunction();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "FAQ", style: TextStyle(fontSize: 18, color: Colors.black),),
          ),
          body: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: authController.faqLIstResponse.length,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            itemBuilder: (context, index) {
              final item = authController.faqLIstResponse[index];
              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child:  Text(
                      '${index + 1}.  ${item!.title.toString()}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                ],
              );
            },
          ));
    });
  }
}
