import 'package:flutter/material.dart';

class Helper {
  static const TextStyle pageTitle =
      TextStyle(color: Colors.black, letterSpacing: 1.4, fontSize: 22);
  static const KPrimaryColor = Color(0xff6f35a5);
  static const kPrimaryLightColor = Color(0xfff1e6ff);
  static const double defaludtPadding = 16;
  //show loading dailogs
  static void showLoadingDialog(BuildContext context,
      {required Duration duration}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(duration, () {
            Navigator.of(context).pop();
          });
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
