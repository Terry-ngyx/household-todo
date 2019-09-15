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

class ProfilePage extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
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
            
            NavBar('Profile'),

            Container(

            ),

          ]
        )
      )
    );
  }

}
