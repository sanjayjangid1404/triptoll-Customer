import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:triptoll/screen/home/wallet_list_row.dart';
import 'package:http/http.dart' as http;
import '../../controller/authController.dart';
import '../../util/appColors.dart';
import '../../util/appContants.dart';
import 'homeview.dart';


class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {

  late Razorpay _razorpay;
  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    // Payment success logic
    //Get.snackbar('Success', 'Payment ID: ${response.paymentId}');
    print("✅ Payment Successful!");
    print("Payment ID: ${response.paymentId}");

    print("Signature: ${response.signature}");

    Get.find<AuthController>().addWalletPaymentFun(amount: _amountController.text.trim().toString(),transitionId: response.paymentId.toString(), context: context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failure logic
    //  Get.snackbar('Error', 'Code: ${response.code} | Message: ${response.message}');
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Transaction Fail'.tr,
        onConfirmBtnTap: (){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false, // Remove all previous routes
          );
        }
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet logic
    Get.snackbar('External Wallet'.tr, '${response.walletName}');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getWalletHistory();
      _razorpay =   Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      setState(() {});
    });
  }

  void _openRazorpayPayment(String id,amount) {

    var options = {
      'key': 'rzp_live_RAJBCQWCkgqpEb',
      'amount': amount, // Convert to paise
      'name': 'Triptoll',
      'description': 'Booking Payment',
      'order_id': id, // custom 8 digit order id
      'prefill': {
        'contact': '${Get.find<AuthController>().getUserPhone()??"123123123"}',
        'email': 'tritoll@gmail.com'
      },
      'theme': {
        'color': '#FF6B6B' // Your app theme color
      }
    };

    try {
      _razorpay.open(options);

    } catch (e) {
      debugPrint('Error: $e');
    }
  }
  Future<String?> createRazorpayOrderId({required int amount}) async {
    const String keyId = 'rzp_live_RAJBCQWCkgqpEb';      // 🔑 Your Key ID
    const String keySecret = 'DfWgvxPob2CSxM147onlshnF';  // 🔒 Your Key Secret (⚠️ sensitive!)

    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$keyId:$keySecret'));

    final url = Uri.parse('https://api.razorpay.com/v1/orders');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': basicAuth,
      },
      body: jsonEncode({
        "amount": amount,     // amount in paise (₹500 = 50000)
        "currency": "INR",
        "receipt": "receipt_${DateTime.now().millisecondsSinceEpoch}"
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("data=>$data");

      if(data["id"]!=null){
        _openRazorpayPayment(data['id'].toString(),amount);
      }
      return data['id']; // <-- This is the order_id
    } else {
      print("Failed to create order: ${response.statusCode} ${response.body}");
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      assignId: true,
      builder: (authController) {
        double totalAmount = 0;
        if (authController.walletResponseList.isNotEmpty) {
          totalAmount = authController.walletResponseList
              .map((e) {
            double amount = double.tryParse(e.walletAmount ?? "0") ?? 0;
            return (e.trnType?.toLowerCase() == "debit") ? -amount : amount;
          })
              .reduce((a, b) => a + b);
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: AppColors.primaryGradient,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Wallet".tr, style: TextStyle(fontSize: 18, color: Colors.white),),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  color: Color(0xffF2F5F7),
                  width: double.maxFinite,
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Text(
                      "Available balance in wallet".tr,
                      style: TextStyle(
                        color: Color(0xff7F7F7F),
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppContants.rupessSystem,
                          style: TextStyle(
                            color: Color(0xff3DB24B),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          totalAmount.toStringAsFixed(2),
                          style: TextStyle(
                            color: Color(0xff282F39),
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 0.5,
                  color: Colors.grey,
                  width: double.maxFinite,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showPaymentPopup(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Wallet Recharge".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 12,
                  color: Color(0xffF2F5F7),
                  width: double.maxFinite,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  color: Color(0xffF2F5F7),
                  width: double.maxFinite,
                  child: Text(
                    "Wallet History".tr,
                    style: TextStyle(
                      color: Color(0xff282F39),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ( authController.walletResponseList.isEmpty)
                    ? const Center(
                  child: Text(
                    "Wallet history not found",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
                    :
                ListView.separated(
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
              ],
            ),
          ),
        );
      },
    );
  }
  TextEditingController _amountController = TextEditingController();

  void _showPaymentPopup(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter Amount'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '(Min amount ₹100)'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an amount'.tr;
                      }

                      double? amount = double.tryParse(value);
                      if (amount == null) {
                        return 'Invalid amount'.tr;
                      }

                      if (amount < 100) {
                        return 'Minimum amount is ₹100'.tr;
                      }

                      return null;
                    },
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      hintText: '0.00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          String amountText = _amountController.text.trim();
                          if (amountText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter an amount')),
                            );
                            return;
                          }

                          double? amount = double.tryParse(amountText);
                          if (amount == null || amount < 100) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  'Amount must be at least ₹100')),
                            );
                            return;
                          }

                          createRazorpayOrderId(amount: (double.parse(
                              _amountController.text.trim()) * 100).round());
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Pay Now'.tr,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
