import 'package:flutter/material.dart';
import '../../model/wallet_responce_model.dart';
import '../../util/appContants.dart';

class WalletRow extends StatelessWidget {
  final WalletResponse wObj;
  const WalletRow({super.key, required this.wObj});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset( "assets/images/wallet_add.png" , width: 35, height: 35, ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wObj.remark??"",
                  style: TextStyle(color: Color(0xff282F39), fontSize: 12),
                ),
                Text(
                  wObj.addDate??"",
                  style: TextStyle(color: Color(0xff7F7F7F), fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            (wObj.trnType?.toLowerCase() == "debit" ?"-":"+") + AppContants.rupessSystem+( (wObj.walletAmount??"0")),
            style: TextStyle(color: Color(0xff282F39), fontSize: 16),
          ),
        ],
      ),
    );
  }
}
