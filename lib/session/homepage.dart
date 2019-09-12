import 'package:flutter/material.dart';
import '../main.dart';
import '../style.dart';
import '../appbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    print('hello')
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, 
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ReusableWidgets.roomBanner("ROOM ID"),
          ] 
        )
      )
    );
  }
}

