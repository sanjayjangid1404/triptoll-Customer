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
  int? expandedIndex;
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
          body:  ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: authController.faqLIstResponse.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade300,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final item =authController.faqLIstResponse[index]!;
              final isExpanded = expandedIndex == index;

              return InkWell(
                onTap: () {
                  setState(() {
                    expandedIndex = isExpanded ? null : index;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${index + 1}.  ${item.title}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                        child: Text(
                          item.description.toString(),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ),
                  ],
                ).paddingSymmetric(vertical: 10),
              );
            },
          ));
    });
  }
}
