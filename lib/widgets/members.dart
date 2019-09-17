import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import '../style.dart';

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

class HouseMembersProfile extends StatelessWidget{
  bool isadmin;
  String member;
  int color;
  int member_id;

  HouseMembersProfile(this.isadmin,this.member,this.color,this.member_id);

  Future<void> _kickuser(int userId) async{
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');
    String url = 'http://10.0.2.2:5000/api/v1/users/kick';
    String json = '{"kicked_id": $member_id}';
    http.Response response = await http.post(
      url,
      headers: {
        'Content-type':'application/json',
        'Authorization':'Bearer $token'
      },
      body: json,
    );
    print(response.body);
    final jsonResponse = jsonDecode(response.body);
    _Kick kickUser = new _Kick.fromJson(jsonResponse);
    print(kickUser.status);
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
              color: Color(color),
              shape: BoxShape.circle
            )
          )
        ),
        Text(member,textAlign:TextAlign.center,style: MemberList),
        isadmin ?
          Expanded(
            child: Container( 
              padding: EdgeInsets.only(right: 40.0),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {_kickuser(member_id);},
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
