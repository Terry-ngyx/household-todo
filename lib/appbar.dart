import 'package:flutter/material.dart';
import 'style.dart';

class ReusableWidgets {
  static getAppBar(String title){
    return AppBar(
      backgroundColor: Colors.black,
      // backgroundColor: Colors.red[300],
      title: Text(title,
        style: AppBarTitle,
      ),
    );
  }

    static roomBanner(String title){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.0),
      padding: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        color: Color(0xFFF96861),
      ),
      child: Text(title,
        style: AppBarTitle, textAlign: TextAlign.center
      ),
    );
  }

}
