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
}
