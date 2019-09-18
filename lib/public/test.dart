import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../main.dart';
import '../style.dart';
import '../widgets/appbar.dart';
import '../widgets/members.dart';
import 'category.dart';

class TestPage extends StatefulWidget {

  @override
  TestState createState() => TestState();
}

class TestState extends State<TestPage> {
 
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
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
            
            NavBar('Groceries',0xFFBDCC11,false),

            Container(
              decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFF61C6C0)),
                          borderRadius: BorderRadius.circular(15.0)),
              child: GestureDetector(
                // behavior: HitTextBehavior.translucent,
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>CategoryPage("1","Groceries","linglee","Thu, 10 Oct 2019 10:10:10 GMT"))
                  );
                },
                child: Text('CLICK ME')
              ),
            )
            
          ]
        )
      )
    );
  }

}
