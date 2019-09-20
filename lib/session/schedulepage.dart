import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

String getdate_post(DateTime date, TimeOfDay time) {
  return "${date.year}-${date.month}-${date.day} ${time.hour}:${time.minute}:00";
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
  List _selectedEvents = [];
  List<String> abc = ['A', 'B', 'C'];
  // DateTime _selectedDay;
  CalendarController _calendarController;

  ////////////////////////////GET REQUEST GETTING TASKS////////////////////////////
  Future<void> _getScheduledTask() async {
    print('Fetching');
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
        if (distinctDateTimes[x] ==
            DateTime.parse('${responseJson[y]["date"]} 00:00:00.000')) {
          task.add(responseJson[y]["task"]);
        }
      }
      tasks.add(task);
    }

    for (int x = 0; x < distinctDateTimes.length; x++) {
      _events.addAll({distinctDateTimes[x]: tasks[x]});
    }

    DateTime x = DateTime.parse(
        '${DateTime.now().toString().split(" ")[0]} 00:00:00.000');
    setState(() {
      _events = _events;
      _selectedEvents = _events[x] ?? [];
    });
    print(_events);
    print('Fetched');
  }

  @override
  void initState() {
    _calendarController = CalendarController();
    _getScheduledTask();
    print('dsidasghkjsdsd');
    // DateTime distinctDateTimes = DateTime.parse('2019-09-19 00:00:00.000');
    // print('enetajijr ${DateTime.now()}');
    print(_events);
    _selectedEvents = _events[DateTime.now()] ?? [];
    print(_selectedEvents);
    super.initState();
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
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 20.0, 40.0, 10.0),
                          constraints:
                              BoxConstraints.expand(height: 40.0, width: 40.0),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 20.0, 9.0, 5.0),
                          child: Text('Personal', style: TitleText),
                        ),
                        SizedBox(
                          width: 110.0,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                            width: 80,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      if (date == null) {
                                        date = DateTime.now();
                                        return DialogBox(
                                            date, _getScheduledTask);
                                      } else {
                                        return DialogBox(
                                            date, _getScheduledTask);
                                      }
                                      // return DialogBox(callback);
                                    });
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 40.0,
                              ),
                            ) //add icon
                            )
                      ],
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        width: 500.0,
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 500.0,
                                height: 200.0,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: _selectedEvents.length,
                                    itemBuilder: (context, index) {
                                      var task = _selectedEvents;
                                      // var taskStatus = is_completed;
                                      var description = _selectedEvents[index];
                                      // bool completed = is_completed[index];
                                      // return PersonalTasks(description);
                                      // return PersonalTasks(description,completed,task_id);
                                      return Dismissible(
                                        direction: DismissDirection.endToStart,
                                        key: Key(description),
                                        onDismissed: (direction) {
                                          setState(() {
                                            task.removeAt(index);
                                            // taskStatus.removeAt(index);
                                            print(task.length);
                                          });
                                          // Shows the information on Snackbar
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      " Task $description dismissed !")));
                                        },
                                        background: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0.0, 9.0, 0.0, 9.0),
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          height: 50,
                                          color: Colors.red,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 20, 0),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 40.0,
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0.0, 5.0, 0.0, 5.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // is_completed[index] =
                                                //     !is_completed[index];
                                              });
                                            },
                                            child: PersonalTasks(description),
                                          ),
                                        ),
                                      );
                                    })),
                          ],
                        )),
                  ])),
              // RaisedButton(
              //   color: Color(0xFFF73D99),
              //   shape: RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(15.0)),
              //   padding: EdgeInsets.all(15.0),
              //   onPressed: () {
              //     showDialog(
              //         context: context,
              //         builder: (context) {
              //           if (date == null) {
              //             date = DateTime.now();
              //             return DialogBox(date, _getScheduledTask);
              //           } else {
              //             return DialogBox(date, _getScheduledTask);
              //           }
              //           // return DialogBox(callback);
              //         });
              //   },
              //   child: Text('Add Task',
              //       textAlign: TextAlign.center, style: BtnText),
              // ),
            ]))));
  }
}

class PersonalTasks extends StatelessWidget {
  String task;
  // String task_id;
  PersonalTasks(this.task);
  // PersonalTasks(this.task);

  // void toggle (){
  //   setState(){
  //     completed = !completed;
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100.0,
      width: 500.0,
      margin: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),

      // color: completed ? Color(0xFF848484) : Color(0xFF61C6C0),
      child: Text(task, textAlign: TextAlign.left),
      // )
    );
  }
}

class DialogBox extends StatefulWidget {
  DateTime date;
  Function callback;
  // Function(String) callback;
  ///asdasd
  DialogBox(this.date, this.callback);
  @override
  _DialogBoxState createState() => _DialogBoxState();
}

/////////////////////////////// DIALOG BOX //////////////////////////////////
class _DialogBoxState extends State<DialogBox> with TickerProviderStateMixin {
  List<String> _repeatBy = ['weekly', 'monthly']; // Option 2
  List<String> _repeatFor = [for (var i = 1; i < 51; i += 1) '$i'];
  TimeOfDay _time = new TimeOfDay.now();
  bool isButtonEnabled = false;
  final taskController = TextEditingController();
  // List<String> _repeatFor =
  String _repeatedBy = 'weekly';
  String _repeatedFor = '1';

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    taskController.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print("Second text field: ${taskController.text}");
  }

////////////////////////////POST REQUEST CREATE NEW TASK/////////////////////
  Future<String> _createTask(String task, String repeat_by, String repeat_for,
      String repeat_on, String date_time) async {
    String token = await storage.read(key: 'jwt');
    // set up POST request arguments
    String url = 'http://10.0.2.2:5000/api/v1/users/new_scheduled';
    String json =
        '{"task": "$task", "repeat_by": "$repeat_by", "repeat_for": "$repeat_for", "repeat_on": "$repeat_on", "date_time": "$date_time"}';
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
  }

  void isEmpty() {
    setState(() {
      if (taskController.text.length == 0) {
        isButtonEnabled = false;
        print(isButtonEnabled);
      } else {
        isButtonEnabled = true;
        print(isButtonEnabled);
      }
    });
  }

  Future<Null> _selectTime() async {
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

    if (picked != null && picked != _time) {
      setState(() => _time = picked);
    }
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
                  onChanged: (val) {
                    isEmpty();
                    print('z');
                  },
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
                RaisedButton(
                    child:
                        new Text('${_time.hour}' + ' : ' + '${_time.minute}'),
                    onPressed: () {
                      _selectTime();
                    }),
              ]),
              Container(
                  margin: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 50.0),
                  child: RaisedButton(
                    color: Color(0xFF61C6C0),
                    onPressed: isButtonEnabled
                        ? () async {
                            await _createTask(
                                taskController.text,
                                _repeatedBy,
                                _repeatedFor,
                                getday(widget.date),
                                getdate_post(widget.date, _time));
                            // print(_time.hour);
                            print('task created, Fetching...');
                            await widget.callback();
                            Navigator.pop(context);
                          }
                        : null,
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
