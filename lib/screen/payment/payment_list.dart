import 'package:flutter/material.dart';
import 'package:triptoll/util/appContants.dart';
import 'package:triptoll/util/appImage.dart';

import '../../util/appColors.dart';

class PaymentList extends StatefulWidget {
  const PaymentList({super.key});

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.primaryGradient,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Payment",style: TextStyle(fontSize: 18,color: Colors.white),),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primaryGradient,width: 0.8)
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          index =0;
                        });
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(4),bottomLeft: Radius.circular(4)),
                          color:index ==0 ?  AppColors.primaryGradient:Colors.white
                        ),
                        child: Text("Wallet",style: TextStyle(fontSize: 16,color:index ==0 ?  Colors.white:Colors.black),),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          index =1;
                        });
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(4),bottomRight: Radius.circular(4)),
                            color:index ==1 ?  AppColors.primaryGradient:Colors.white
                        ),
                        child: Text("Payment",style: TextStyle(fontSize: 16,color:index ==1 ?  Colors.white:Colors.black),),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {

                return Container(

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
                      Expanded(
                          flex:1,
                          child: Image.asset(AppImage.splashLogo,)),

                      Expanded(
                          flex:8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text("Amount Of ORD-449",style: TextStyle(fontSize: 14,color: Colors.black),),
                                      Text("07 Jun 2025",style: TextStyle(fontSize: 14,color: AppColors.secondaryGradient,fontWeight: FontWeight.w400),),

                                    ],
                                  ),
                                ),

                                Text("${AppContants.rupessSystem}400",style: TextStyle(fontSize: 22,color: AppColors.primaryGradient),)
                              ],
                            ),
                          ))
                    ],
                  ),
                );

            },),
          )
        ],
      ),
    );
  }
}
