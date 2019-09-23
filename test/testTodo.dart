import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';

class PrivateDialog extends StatefulWidget {
  Function callback;
  PrivateDialog(this.callback);
  @override
  _PrivateDialogState createState() => _PrivateDialogState();
}

class _PrivateDialogState extends State<PrivateDialog> {
  bool isButtonEnabled = false;


    _postPrivateTask(String _tasks) async {
    String token = await storage.read(key: 'jwt');
    String url = 'http://10.0.2.2:5000/api/v1/users/newprivatetask';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json = '{"description":"$_tasks"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    final jsonResponse = jsonDecode(response.body);
    // print(jsonResponse);
    // getPrivateTask();
  }

  @override
  void initState(){
    super.initState();
  }

   void isEmpty() {
    setState(() {
      if (newTaskController.text.length == 0) {
        isButtonEnabled = false;
        print(isButtonEnabled);
      } else {
        isButtonEnabled = true;
        print(isButtonEnabled);
      }
    });
  }

  final newTaskController = TextEditingController();
  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 12.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF96861)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Text(
                "Add New Task",
                style: AddTaskTitle,
              ),
            ),
            SizedBox(
              width: 35,
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Color(0xFFF96861),
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        height: 180,
        width: 400,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: TextFormField(
                autofocus: true,
                controller: newTaskController,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'What Chu wanna Do?',
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color(0xFFF96861))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Color(0xFFF96861)))),
              ),
            ),
            Container(
                width: 400,
                margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: RaisedButton(
                  color: Color(0xFFF96861),
                  onPressed: isButtonEnabled ? () {
                    Navigator.pop(context);
                    _postPrivateTask(newTaskController.text);
                    widget.callback();
                    newTaskController.clear();
                  }:null,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(15.0),
                  child:
                      Text('Add', textAlign: TextAlign.center, style: BtnText),
                )),
          ],
        ),
      ),
    );
  }
}
