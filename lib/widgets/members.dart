import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';

import 'dart:async';
import 'dart:convert';

import '../main.dart';
import '../style.dart';
import '../session/profile.dart';

class HouseMembers extends StatelessWidget{
  String member;
  int color;

  HouseMembers(this.member,this.color);

  @override
  Widget build(BuildContext context){
    return Container(
      width: 90.0,
      child: Column(children: <Widget>[
        Center(
          child: Container(
            width: 25.0,
            height: 25.0,
            margin: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 10.0),
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle
            )
          )
        ),
        Text(member,textAlign:TextAlign.center,style: MemberNames)
      ],)
    );
  }
}

class _Kick {
  String status;
  _Kick({this.status});
  factory _Kick.fromJson(Map<String,dynamic> parsedJson){
    return _Kick(status: parsedJson['status']);
  }
}

class HouseMembersProfile extends StatefulWidget{
  bool isadmin;
  String member;
  int color;
  int memberid;
  final Function(int) callback;

  HouseMembersProfile(this.isadmin,this.member,this.color,this.memberid,this.callback);

  @override 
  _HouseMembersProfileState createState() => _HouseMembersProfileState();  
}

class _HouseMembersProfileState extends State<HouseMembersProfile>{
  String _currUserId = '';

  Future _kickuser(int userId) async{
    String token = await storage.read(key: 'jwt');
    String url = 'http://10.0.2.2:5000/api/v1/users/kick';
    String json = '{"kicked_id": "${widget.memberid}"}';
    http.Response response = await http.post(
      url,
      headers: {
        'Content-type':'application/json',
        'Authorization':'Bearer $token'
      },
      body: json,
    );
    final jsonResponse = jsonDecode(response.body);
    _Kick kickUser = new _Kick.fromJson(jsonResponse);
    print(kickUser.status);
    if (kickUser.status == "success") {
      return true;
    }
  }

  Future _deleteroom() async{
    String token = await storage.read(key: 'jwt');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomId = prefs.getString('room_id');
    String curruserId = prefs.getString('user_id');
    String url = 'http://10.0.2.2:5000/api/v1/users/deleteroom';
    String json = '{"room_id": "$roomId"}';
    http.Response response = await http.post(
      url,
      headers: {
        'Content-type':'application/json',
        'Authorization':'Bearer $token'
      },
      body: json,
    );
    final jsonResponse = jsonDecode(response.body);
    _Kick deleteRoom = new _Kick.fromJson(jsonResponse);
    print(deleteRoom.status);
    if (deleteRoom.status == "success") {
      setState(()=>_currUserId=curruserId);
      print(_currUserId);
      return true;
    }
  }

void _showAlertDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          padding: EdgeInsets.all(5.0),
          child: Text(
            'Are you sure you want to destroy this room? :(',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        content:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                // margin: EdgeInsets.symmetric(horizontal:10.0),
                child: RaisedButton(
                color: Color(0xFF61C6C0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                onPressed: () {
                  _deleteroom();
                  Navigator.pushNamed(context,GetStartedRoute);
                },
                child: Text('Yes', style:TextStyle(color:Colors.white))
              ),
              ),
          Container(
          // margin: EdgeInsets.symmetric(horizontal:10.0),
          child: RaisedButton(
            color: Color(0xFFF96861),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            onPressed: () {Navigator.pop(context);},
              child: Text('Cancel',style:TextStyle(color:Colors.white))
          ),
          ),
            ],
          ),
      );
    }
  );
}

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      height: 60.0,
      child: Row(children: <Widget>[
        Center(
          child: Container(
            width: 25.0,
            height: 25.0,
            margin: EdgeInsets.fromLTRB(40.0, 10.0, 20.0, 10.0),
            decoration: BoxDecoration(
              color: Color(widget.color),
              shape: BoxShape.circle
            )
          )
        ),
        Text(widget.member,textAlign:TextAlign.center,style: MemberList),
        widget.isadmin ?
          Expanded(
            child: Container( 
              padding: EdgeInsets.only(right: 40.0),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String curruserId = prefs.getString('user_id');
                  print('memberid: ${widget.memberid}');
                  print('state: $curruserId');
                  if(widget.memberid != int.parse(curruserId)){
                    _kickuser(widget.memberid);
                    Flushbar(
                      message:'${widget.member} has been successfully kicked out :(',
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                      )..show(context);
                    widget.callback(widget.memberid);
                  } else {
                    _showAlertDialog();
                    // _deleteroom();
                    // Navigator.pushNamed(context,GetStartedRoute);
                  }
                },
                child: Icon(
                  Icons.remove_circle_outline,
                  color:Colors.white,
                  size: 30.0,
                )
              )
            )
          )
          :
          Container()
      ],)
    );
  }
}

class HouseMembers2 extends StatelessWidget{
  String member;
  int color;

  HouseMembers2(this.member,this.color);

  @override
  Widget build(BuildContext context){
    return Container(
      width: 85.0,
      child: Column(children: <Widget>[
        Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 10.0),
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle
            )
          )
        ),
        Text(member,textAlign:TextAlign.center,style: MemberNames)
      ],)
    );
  }
}
