import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/util/appContants.dart';
import 'package:triptoll/util/appImage.dart';

import '../../controller/authController.dart';
import '../../util/appColors.dart';
import '../home/wallet_list_row.dart';

class PaymentList extends StatefulWidget {
  const PaymentList({super.key});

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getWalletHistory();
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      assignId: true,
      builder: (authController) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: AppColors.primaryGradient,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Payment", style: TextStyle(fontSize: 18, color: Colors.white),),

          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: AppColors.primaryGradient, width: 0.8)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4)),
                                color: index == 0
                                    ? AppColors.primaryGradient
                                    : Colors.white
                            ),
                            child: Text("Wallet", style: TextStyle(fontSize: 16,
                                color: index == 0 ? Colors.white : Colors
                                    .black),),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4)),
                                color: index == 1
                                    ? AppColors.primaryGradient
                                    : Colors.white
                            ),
                            child: Text("Payment", style: TextStyle(
                                fontSize: 16,
                                color: index == 1 ? Colors.white : Colors
                                    .black),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Expanded(
                child:   ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    itemBuilder: (context, index) {
                      var wObj = authController.walletResponseList[index];
                      return WalletRow(wObj: wObj);
                    },
                    separatorBuilder: (context, index) => const Divider(
                      indent: 50,),
                    itemCount: authController.walletResponseList.length)
              )
            ],
          ),
        );
      },
    );
  }
}
