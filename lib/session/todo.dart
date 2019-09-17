import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../main.dart';
import '../style.dart';
import '../widgets/appbar.dart';

class TodoPage extends StatefulWidget {
  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<TodoPage> {
  int _userid = 0;
  String _token = '';

  @override
  void initState() {
    super.initState();
    getStoredData();
  }

  Future<void> getStoredData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("user_id");
    final storage = FlutterSecureStorage();
    String token = await storage.read(key:'jwt');
    setState(() => _userid = userId);
    setState(() => _token = token);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, 
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
            
            NavBar('To Do',0xFFBDCC11,false),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(border: Border.all(color:Colors.white)),
              child: Column(
                children: <Widget>[

                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0,0.0,20.0,0.0),
                        constraints: BoxConstraints.expand(height:40.0,width:40.0),
                        child: SvgPicture.asset(
                          "assets/images/personal.svg",
                        ),
                      ),
                      Text('Personal',style:TitleText),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color:Colors.white)),
                        width: 50.0,
                        alignment: Alignment.centerRight,
                        constraints: BoxConstraints.expand(height:40.0,width:40.0),
                        child: SvgPicture.asset(
                          "assets/images/add_without_circle.svg",
                        ),                  //add icon
                      )
                    ],
                  ),

                  Container(      
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    height: 300.0,
                  )

                ]
              )
            )

          ]
        )
      )
    );
  }

}
