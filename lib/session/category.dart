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

class ProfilePage extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  List _members = [];
  List _memberColors = [];
  List _memberIds = [];
  String newItem;
 
  final storage = FlutterSecureStorage();

   Future<void> getStoredMemberData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List members = prefs.getStringList('members');
    List memberColors = prefs.getStringList('member_color');
    List memberIds = prefs.getStringList('member_id');
    setState(() {
      _members = members;
      _memberColors = memberColors;
      _memberIds = memberIds;
    });
  }

  @override
  void initState() {
    super.initState();
    getStoredMemberData();
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
              margin: EdgeInsets.all(40.0),
              decoration: BoxDecoration(border: Border.all(color:Colors.white)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.fromLTRB(80.0,0.0,80.0,20.0),
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color:Color(0xFFF96861)),
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Text('Creator: linglee',style:NormalFont),
                  ),
                   
                   Text('Members',style:NormalFont),

                   Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.only(bottom: 40.0),
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),     
                    child: Column(
                      children: <Widget>[
                        Text("Members",textAlign: TextAlign.center,style:TitleText),
                        Expanded(
                          child: Center(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: _members.length,
                              itemBuilder: (context,index){
                                var member = _members[index];
                                var color = int.parse(_memberColors[index]);
                                return HouseMembers(member,color);
                              }
                            )
                          )
                        )
                      ],)
                   ),

                   Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.only(bottom: 40.0),
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Colors.purple),
                        ),
                      ),
                      initialValue: "Type Something",
                      validator: (value) {
                        if (value.isEmpty){
                          return 'nothing has been typed!';
                        }
                        return null;
                      },
                      onSaved: 
                      (String value){
                        newItem = value;
                      },
                    )
                   ),

                ]
              )
            ),

          ]
        )
      )
    );
  }

}
