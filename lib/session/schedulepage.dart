import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';

import '../style.dart';
import '../main.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final roomIdController = TextEditingController();
  String _repeatedOn;
  CalendarController _calendarController;

  // callback(dialogRepeatedOn) {
  //   setState(() {
  //     _repeatedOn = dialogRepeatedOn;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
              TableCalendar(
                calendarController: _calendarController,
              ),
              RaisedButton(
                color: Color(0xFFF73D99),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),
                padding: EdgeInsets.all(15.0),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogBox();
                        // return DialogBox(callback);
                      });
                },
                child: Text('Add Task',
                    textAlign: TextAlign.center, style: BtnText),
              ),
            ]))));
  }
}

class DialogBox extends StatefulWidget {
  // Function(String) callback;

  // DialogBox(this.callback);

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

// class _Task {
//   String name;
//   String jwt_token;
//   String user_id;
//   String room_id;
//   String is_admin;

//   _Task({this.status, this.jwt_token, this.user_id, this.room_id, this.is_admin});

//   factory _Task.fromJson(Map<String, dynamic> parsedJson) {
//     return _Task(
//       status: parsedJson['status'],
//       jwt_token: parsedJson['jwt_token'],
//       user_id: parsedJson['user_id'],
//       room_id: parsedJson['room id'],
//       is_admin: parsedJson['is admin'],
//     );
//   }
// }

class _DialogBoxState extends State<DialogBox> {
  List<String> _repeatOn = ['Weekly', 'Monthly']; // Option 2
  List<String> _repeatFor = [for (var i = 0; i < 51; i += 1) '$i'];
  // List<String> _repeatFor =
  String _repeatedOn = 'Monthly';
  String _repeatedFor = '12';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF73D99)),
          ),
        ),
        child: Text(
          "Add New Task",
          style: DialogTextPink,
        ),
      ),
      content: Container(
          height: 400.0,
          width: 300.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: TextFormField(
                  // style: TextStyle(height: 2.0),
                  style: TextStyle(color: Color(0xFFF73D99)),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'Add Task',
                      hintStyle: TextStyle(
                          color: Color(0xFFF73D99).withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontSize: 28.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFF73D99))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Colors.white))),
                ),
              ),
              //////////////////// DROPDOWN BUTTON
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Repeat On:',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    child: DropdownButton(
                      hint: Text(''), // Not necessary for Option 1
                      value: _repeatedOn,
                      items: _repeatOn.map((option) {
                        return DropdownMenuItem(
                          child: new Text(
                            option,
                            style: TextStyle(color: Color(0xFFF73D99)),
                          ),
                          value: option,
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _repeatedOn = newValue;
                          // widget.callback(newValue);
                          print(_repeatedOn);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(children: <Widget>[
                Container(
                  child: Text(
                    'Repeat For:',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  child: DropdownButton(
                    hint: Text(''), // Not necessary for Option 1
                    value: _repeatedFor,
                    items: _repeatFor.map((option) {
                      return DropdownMenuItem(
                        child: new Text(
                          option,
                          style: TextStyle(color: Color(0xFFF73D99)),
                        ),
                        value: option,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _repeatedFor = newValue;
                        // widget.callback(newValue);
                        print(_repeatedFor);
                      });
                    },
                  ),
                ),
              ]),
              Container(
                    margin: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 50.0),
                    child: RaisedButton(
                      color: Color(0xFF61C6C0),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0)),
                      padding: EdgeInsets.all(15.0),
                      child: Text('Add Task',
                          textAlign: TextAlign.center, style: BtnText),
                    )),
            ],
          )),

      //  content: Text("Hi Bello",style:AddTaskBody,),
    );
  }
}
