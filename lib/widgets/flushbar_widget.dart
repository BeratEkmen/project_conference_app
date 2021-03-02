import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarWidget {
  static void display(BuildContext context, Size size, String message) {
    Flushbar(
      onTap: (flushbar) async {
        await flushbar.dismiss();
      },
      flushbarPosition: FlushbarPosition.BOTTOM,
      messageText: Text(
        message,
        style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.038,
            fontFamily: 'OpenSans'),
      ),
      duration: Duration(seconds: 3),
      blockBackgroundInteraction: true,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      isDismissible: true,
      borderRadius: 10.0,
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.04),
    ).show(context);
  }
}