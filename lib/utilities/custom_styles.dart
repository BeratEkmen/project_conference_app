import 'package:flutter/material.dart';

class CustomStyles {


  static TextStyle kHintStyle(Size size) {
    return TextStyle(
        color: Colors.white54,
        fontFamily: 'OpenSans',
        fontSize: size.width * 0.047,
    );
  }

  static TextStyle kLabelStyle(Size size) {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'OpenSans',
      fontSize: size.width * 0.035,
    );
  }

  static BoxDecoration kBoxDecorationStyle() {
    return BoxDecoration(
        color: Color(0xFF6CA8F1),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ]);
  }
  static BoxDecoration kMainBoxStyle(){
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF73AEF5),
          Color(0xFF61A4F1),
          Color(0xFF478DE0),
          Color(0xFF398AE5),
        ],
        stops: [0.1, 0.4, 0.7, 0.9],
      ),
    );
  }

}