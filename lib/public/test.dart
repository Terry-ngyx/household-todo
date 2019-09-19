import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

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

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  String dropdownHour = TimeOfDay.now().hour.toString();
  String dropdownMinute = TimeOfDay.now().minute.toString();
  List<String> _hours = [];
  List<String> _minutes = [];

  Future<void> _setTime() async{
    for (int i=0;i<24;i++){
      _hours.add('${i+1}');
    }
    for (int i=0;i<=60;i++){
      _minutes.add('$i');
    }
    setState((){
      _hours=_hours;
      _minutes=_minutes;
    });
  }

  Future<Null> _selectDate() async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.dark(),
        child: child,
        );
      },
    );

    if(picked != null && picked != _date){
      print('Date selected: ${_date.toString()}');
      setState(()=> _date = picked);
    }
  }

  Future<Null> _selectTime() async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.dark(),
        child: child,
        );
      },
    );

    if(picked != null && picked!= _time){
      print('Date selected: ${_date.toString()}');
      setState(()=> _time = picked);
    }
  }

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
            
            NavBar('Testing',0xFFBDCC11,false),

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
            ),

            Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(border:Border.all(color:Colors.white)),
              child: Column(children: <Widget>[
                Text('Date Selected: ${_date.toString()}'),
                RaisedButton(
                  child: new Text(DateFormat.yMMMMd("en_US").format(_date)),
                  onPressed: (){_selectDate();}
                ),
                Text('    '),
                Text('Date Selected: ${_time.toString()}'),
                RaisedButton(
                  child: new Text('${_time.hour}'+' : '+'${_time.minute}'),
                  onPressed: (){_selectTime();}
                ),
                Text(' '),
                Text('Return to Json: '),
                Text('${DateFormat("y-MM-dd").format(_date).toString()} ${_time.hour.toString()}:${_time.minute.toString()}:00')
              ],)
            ),

            
            
          ]
        )
      )
    );
  }

}
