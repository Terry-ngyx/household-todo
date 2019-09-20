import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import '../style.dart';

import 'dart:async';
import 'dart:convert';

class PublicTask extends StatefulWidget {
  int taskId;
  String task;
  bool isCompleted;
  int memberColor;
  final Function(int) complete;
  final Function(int) delete;
  PublicTask(this.taskId,this.task,this.isCompleted,this.memberColor,this.complete,this.delete);

  @override
  _PublicTaskState createState() => _PublicTaskState();
}

class _DeleteTask{
  String status;
  _DeleteTask({this.status});
  factory _DeleteTask.fromJson(Map<String,dynamic> parsedJson){
    return _DeleteTask(
      status: parsedJson['status'],
    );
  }
}

class _PublicTaskState extends State<PublicTask>{

  Future<bool> _completeTask(int taskId) async{
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');
    String url = 'http://10.0.2.2:5000/api/v1/users/completepublictask';
    String json = '{"task_id": $taskId}';
    http.Response response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization':'Bearer $token'
      },
      body: json
    );
  }
  Future<bool> _deleteTask(int taskId) async{
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt');
    String url = 'http://10.0.2.2:5000/api/v1/users/deletepublictask';
    String json = '{"task_id": $taskId}';
    http.Response response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization':'Bearer $token'
      },
      body: json
    );
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    _DeleteTask deleteTask = new _DeleteTask.fromJson(jsonResponse);
    if(deleteTask.status=="successfully deleted"){
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () async{
        _completeTask(widget.taskId);
        widget.complete(widget.taskId);
      },
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: Key(UniqueKey().toString()),
        onDismissed: (direction) {
          _deleteTask(widget.taskId);
          Flushbar(
            message: 'task has been deleted',
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          )..show(context);
          widget.delete(widget.taskId);
        },
        background: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          alignment: AlignmentDirectional.centerEnd,
          height: 45.0,
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            child: Icon(Icons.delete,color: Colors.white,size: 35.0),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          padding: EdgeInsets.only(left: 10.0),
          color: Color(widget.memberColor),
          height: 45.0,
          child: Row(
            children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.0),
              width: 20.0,
              child:  widget.isCompleted? 
              Icon(Icons.check_circle,color:Colors.black,size:20.0)
              :
              Icon(Icons.radio_button_unchecked,color:Colors.white,size:20.0
              ),
            ),
            widget.isCompleted? Text(widget.task, style:NormalFontStriked):Text(widget.task, style:NormalFont)
            ],
          )
        )
      )
    );
  }
}
