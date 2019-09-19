import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../style.dart';
import '../main.dart';
import 'dart:async';
import 'dart:convert';

String getweekday(DateTime date) {
  switch (date.weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'invalid choice';
  }
}

String getdate(DateTime date) {
  return "${date.day}-${date.month}-${date.year}";
}

String getdate_post(DateTime date) {
  return "${date.year}-${date.month}-${date.day} 12:12:00";
}

String getday(DateTime date) {
  return "${date.day}";
}

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime date;
  String _repeatedBy;
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  // DateTime _selectedDay;
  CalendarController _calendarController;

  ////////////////////////////GET REQUEST GETTING TASKS////////////////////////////
  Future<void> _getScheduledTask() async {
    List<DateTime> dateTimes = [];
    List<String> task;
    List<List<String>> tasks = [];

    String token = await storage.read(key: 'jwt');
    String url = 'http://10.0.2.2:5000/api/v1/users/get/scheduled/all';
    http.Response response = await http.get(
      '$url',
      headers: {'Authorization': 'Bearer $token'},
    );
    final responseJson = jsonDecode(response.body);

    for (int i = 0; i < responseJson.length; i++) {
      DateTime parsedDate = DateTime.parse(responseJson[i]["date"]);
      dateTimes.add(parsedDate);
    }

    var distinctDateTimes = dateTimes.toSet().toList();
    // setState(()=>_tasks = tasks);
    // setState(()=>_is_completed = is_completed);

    // print(tasks);
    // print(distinctDateTimes);
    // print(responseJson);

    for (int x = 0; x < distinctDateTimes.length; x++) {
      task = [];
      for (int y = 0; y < responseJson.length; y++) {
        if (distinctDateTimes[x] == DateTime.parse('${responseJson[y]["date"]} 00:00:00.000')) {
          task.add(responseJson[y]["task"]);
        }
      }
      tasks.add(task);
    }

    for (int x = 0; x < distinctDateTimes.length; x++) {
      _events.addAll({distinctDateTimes[x]: tasks[x]});
    }

    setState(()=>_events = _events);
    // print(distinctDateTimes);
    // print(tasks);
  }

  @override
  void initState() {
    _calendarController = CalendarController();
    _getScheduledTask();
    super.initState();
    // final _selectedDay = DateTime.now();

    // // print(_selectedDay);

    // _selectedEvents = _events[_selectedDay] ?? [];
    // print(_selectedEvents);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _calendarController.dispose();
    super.dispose();
  }

  // void setEvent(_selectedDay) {
  //   _events = {
  //     _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
  //     _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
  //     _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
  //   };

  //   _selectedEvents = _events[_selectedDay] ?? [];
  // }

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
                events: _events,
                onDaySelected: (calendar_date, events) {
                  setState(() {
                    _selectedEvents = events;
                    print(_selectedEvents);
                  });
                  date = calendar_date;
                  // print(getdate(date));
                  // print(getweekday(date));
                },
                calendarStyle: CalendarStyle(
                  selectedColor: Colors.deepOrange[400],
                  todayColor: Colors.deepOrange[200],
                  markersColor: Colors.white,
                  outsideDaysVisible: false,
                ),
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
                        if (date == null) {
                          date = DateTime.now();
                          return DialogBox(date);
                        } else {
                          return DialogBox(date);
                        }
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
  DateTime date;
  // Function(String) callback;
  DialogBox(this.date);
  @override
  _DialogBoxState createState() => _DialogBoxState();
}

/////////////////////////////// DIALOG BOX //////////////////////////////////
class _DialogBoxState extends State<DialogBox> with TickerProviderStateMixin {
  List<String> _repeatBy = ['weekly', 'monthly']; // Option 2
  List<String> _repeatFor = [for (var i = 0; i < 51; i += 1) '$i'];
  final taskController = TextEditingController();
  // List<String> _repeatFor =
  String _repeatedBy = 'monthly';
  String _repeatedFor = '12';

////////////////////////////POST REQUEST CREATE NEW TASK/////////////////////
  Future<String> _createTask(String task, String repeat_by, String repeat_for,
      String repeat_on, String date_time) async {
    String token = await storage.read(key: 'jwt');
    // set up POST request arguments
    String url = 'http://10.0.2.2:5000/api/v1/users/new_scheduled';
    String json =
        '{"task": "$task", "repeat_by": "$repeat_by", "repeat_for": "$repeat_for", "repeat_on": "$repeat_on", "date_time": "$date_time"}';

    print(json);
    // make POST request
    http.Response response = await http.post(
      '$url',
      headers: {
        'Authorization': 'Bearer $token',
        "Content-type": "application/json"
      },
      body: json,
    );

    // check the status code for the result
    int statusCode = response.statusCode;

    final jsonResponse = jsonDecode(response.body);
    print(response.body);
    // _Room user = new _Room.fromJson(jsonResponse);
    // print(user.status);
    // if (user.status == "success") {
    //   Scaffold.of(context)
    //       .showSnackBar(SnackBar(content: Text('New Room created!')));
    //   await new Future.delayed(const Duration(seconds: 1));

    //   Navigator.pushNamed(context, HomeRoute);

    //   return '';
    // }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    taskController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFF73D99)),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    "Add New Task",
                    style: DialogTextPink,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    getdate(widget.date),
                    textAlign: TextAlign.right,
                    style: DialogTextPink,
                  ),
                ),
              )
            ],
          )),
      content: Container(
          height: 400.0,
          width: 300.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: TextFormField(
                  controller: taskController,
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
                      value: _repeatedBy,
                      items: _repeatBy.map((option) {
                        return DropdownMenuItem(
                          child: new Text(
                            option,
                            style: TextStyle(color: Color(0xFFF73D99)),
                          ),
                          value: option,
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        print(widget.date);
                        setState(() {
                          _repeatedBy = newValue;
                          // widget.callback(newValue);
                          print(_repeatedBy);
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
                      _createTask(
                          taskController.text,
                          _repeatedBy,
                          _repeatedFor,
                          getday(widget.date),
                          getdate_post(widget.date));
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
