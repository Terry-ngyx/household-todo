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

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class _Current{
  String username;
  String email;
  bool is_admin;
  int room_id;

  _Current({this.username,this.email,this.is_admin,this.room_id});

  factory _Current.fromJson(Map<String,dynamic> parsedJson){
    return _Current(
      username: parsedJson['username'],
      email: parsedJson['email'],
      is_admin: parsedJson['is_admin'],
      room_id: parsedJson['room_id'],
    );
  }
}

class HomePageState extends State<HomePage> {
  int _userid = 0;
  String _token = '';
  List<String> _memberColors = [];
  List<String> _members = [];

  final storage = FlutterSecureStorage();
  
  @override
  void initState() {
    super.initState();
    getStoredData();
    getCurrentUser();
  }


  Future<void> getStoredData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("user_id");
    String token = await storage.read(key:'jwt');
    print(userId);
    print(token);
    setState(() => _userid = userId);
    setState(() => _token = token);
  }

  //GET REQUEST FOR CURRENT USER:
  Future<void> getCurrentUser() async {
    
    print(_userid);
    String token = await storage.read(key:'jwt');
    // set up authenticated GET request arguments
    String url = 'http://10.0.2.2:5000/api/v1/users/me';
    // Map<String, String> headers ={'Authorization:': 'Bearer $_token'};
    http.Response response = await http.get(
      '$url',
      headers:  {'Authorization': 'Bearer $token'},
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    _Current currentUser = new _Current.fromJson(responseJson);
    print(currentUser);
    print(currentUser.username);
    print(currentUser.email);
    print(currentUser.is_admin);
    print(currentUser.room_id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username',currentUser.username);
    prefs.setString('email',currentUser.email);
    prefs.setBool('is_admin',currentUser.is_admin);
    prefs.setInt('room_id',currentUser.room_id);
  }
  
  //GET REQUEST FOR ALL PEOPLE IN THE ROOM:
  // Future<void> getHousemates() async {
  //   // set up authenticated GET request arguments
  //   String url = 'http://10.0.2.2:5000/api/v1/users/housemates';
  //   // Map<String, String> headers ={'Authorization:': 'Bearer $_token'};
  //   http.Response response = await http.get(
  //     '$url',
  //     headers:  {HttpHeaders.authorizationHeader: 'Bearer $_token'},
  //     // headers: {
  //     //   HttpHeaders.contentTypeHeader: 'application/json',
  //     //   HttpHeaders.authorizationHeader: 'Bearer $_token'
  //     // },
  //   );
  // }

  Future<void> getHouseholdData() async{
    List<String> membercolors = ['F96861','61C6C0','BDCC11','F73D99','F28473','C7CEEA','73C2FB','F9C1A0','FFE9A1','FE5855'];
    List<String> members = ['linglee','suzen','weihan','terrence']; 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("memberColors",membercolors);
    prefs.setStringList("members",members);
    // List<String> memberColors = prefs.getStringList("memberColors");
    // List<String> members = prefs.getStringList("members");
    setState(() => _memberColors = membercolors);
    setState(() => _members = members);
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
            ReusableWidgets.roomBanner("ROOM ID"),
            Container(
              margin: EdgeInsets.symmetric(horizontal:20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  //Members
                  Container(
                    height: 150.0,
                    margin: EdgeInsets.only(bottom:20.0),
                    padding: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Members",textAlign: TextAlign.center,style:TitleText),
                          Row(children: <Widget>[
                            //PENDING MEMBERS ADD IN                   
                          ])
                        ],)
                    )
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[ 
                      //Profile
                      Container(
                        margin: EdgeInsets.only(bottom:20.0),
                        height: 170.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFFF96861)),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: Text('Profile',textAlign: TextAlign.center,style: TitleText)
                        )
                      ), 
                      //To do
                      Container(
                        margin: EdgeInsets.only(bottom:20.0),
                        height: 170.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFFBDCC11)),
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: GestureDetector(
                          onTap:() {
                            Navigator.pushNamed(context,TodoRoute);
                          },
                          child: Center(
                            child: Text('To Do',textAlign: TextAlign.center,style: TitleText)
                          )
                        )
                      ),
                    ]
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[  
                      //Assign to me
                      Container(
                        margin: EdgeInsets.only(bottom:20.0),
                        height: 170.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFF61C6C0)),
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Center(
                          child: Text('Assign to Me',textAlign: TextAlign.center,style: TitleText)
                        )
                      ),  
                      //Schedule
                      Container(
                        margin: EdgeInsets.only(bottom:20.0),
                        height: 170.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFFF73D99)),
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Center(
                          child: Text('Schedule',textAlign: TextAlign.center,style: TitleText)
                        )
                      ),
                    ]
                  ),

                  //Due Today
                  Container(
                    height: 125.0,
                    margin: EdgeInsets.only(bottom:20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        Text("Due Today :",textAlign: TextAlign.left,style:TitleText),
                        Container(
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.white),
                          //   borderRadius: BorderRadius.circular(15.0)
                          // ),
                          height: 73.0,
                          child: Center(
                            child: Text("Task/Schedule due by today", textAlign: TextAlign.center,style:MutedText)
                            //PENDING: NEED TO ADD IF ELSE STATEMENT SO IF THERE IS SOMETHING TO BE COMPLETED BY TODAY IT SHOWS UP HERE!
                          )
                        )
                      ],)
                    )
                  ),

                ]
              )
            )
          ] 
        )
      )
    );
  }
}

