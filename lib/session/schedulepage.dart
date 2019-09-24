import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style.dart';
import '../main.dart';
import 'dart:async';
import 'dart:convert';
import '../widgets/appbar.dart';

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

String getdate_post2(DateTime date) {
  return "${date.year}-${date.month}-${date.day} 00:00:00";
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
  Map<DateTime, List> _id = {};
  Map<DateTime, List> _user_incharge_id = {};
  Map<DateTime, List> _color = {};
  Map<DateTime, List> _assigned = {};
  List _selectedEvents = [];
  List _selectedId = [];
  List _selectedUserInchargeId = [];
  List _selectedColor = [];
  List _selectedAssigned = [];
  DateTime _selectedDate;
  int selectedEventsLength = 0;
  List _members = [];
  List _memberColors = [];
  List _memberIds = [];
  CalendarController _calendarController;

  ////////////////////////////GET REQUEST GETTING TASKS////////////////////////////
  Future<void> _getScheduledTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List members = prefs.getStringList('members');
    List memberColors = prefs.getStringList('member_color');
    List memberIds = prefs.getStringList('member_id');

    print('Fetching');
    List<DateTime> dateTimes = [];
    List<String> task;
    List<String> id;
    List<String> user_incharge_id;
    List<int> color = [];
    List<String> assigned = [];
    List<List<String>> tasks = [];
    List<List<String>> ids = [];
    List<List<String>> user_incharge_ids = [];
    List<List<int>> colors = [];
    List<List<String>> assigneds = [];
    DateTime x;

    String token = await storage.read(key: 'jwt');
    String url = 'http://192.168.1.21:5000/api/v1/users/get/scheduled/all';
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
    print(responseJson);

    for (int x = 0; x < distinctDateTimes.length; x++) {
      task = [];
      id = [];
      user_incharge_id = [];
      color = [];
      assigned = [];
      for (int y = 0; y < responseJson.length; y++) {
        if (distinctDateTimes[x] ==
            DateTime.parse('${responseJson[y]["date"]} 00:00:00.000')) {
          task.add(responseJson[y]["task"]);
          id.add(responseJson[y]["task_id"]);
          user_incharge_id.add(responseJson[y]["user_id_incharge"].toString());
          int pos =
              memberIds.indexOf(responseJson[y]["user_id_incharge"].toString());
          if (pos != -1) {
            assigned.add(members[pos]);
            color.add(int.parse(memberColors[pos]));
          } else {
            assigned.add('Assign');
            color.add(0xFF848484);
          }
        }
      }
      tasks.add(task);
      ids.add(id);
      user_incharge_ids.add(user_incharge_id);
      colors.add(color);
      assigneds.add(assigned);
    }

    // print(memberIds);
    // print(user_incharge_ids);

    // print(assigneds);
    // print(colors);

    for (int x = 0; x < distinctDateTimes.length; x++) {
      _events.addAll({distinctDateTimes[x]: tasks[x]});
      _id.addAll({distinctDateTimes[x]: ids[x]});
      _user_incharge_id.addAll({distinctDateTimes[x]: user_incharge_ids[x]});
      _color.addAll({distinctDateTimes[x]: colors[x]});
      _assigned.addAll({distinctDateTimes[x]: assigneds[x]});
    }

    print(_color);
    print(_assigned);

    if (_selectedDate == null) {
      x = DateTime.parse(
          '${DateTime.now().toString().split(" ")[0]} 00:00:00.000');
    } else {
      x = DateTime.parse(
          '${_selectedDate.toString().split(" ")[0]} 00:00:00.000');
    }
    setState(() {
      _events = _events;
      _id = _id;
      _user_incharge_id = _user_incharge_id;
      _assigned = _assigned;
      _color = _color;
      _selectedEvents = _events[x] ?? [];
      _selectedId = _id[x] ?? [];
      _selectedColor = _color[x] ?? [];
      _selectedAssigned = _assigned[x] ?? [];
      _selectedUserInchargeId = _user_incharge_id[x] ?? [];
      selectedEventsLength = _selectedEvents.length;
      _members = members;
      _memberColors = memberColors;
      _memberIds = memberIds;
    });

    // print(_events);
    print(_selectedEvents);
    // print('Fetched');
  }

  _deleteScheduledTask(int _taskId) async {
    String token = await storage.read(key: 'jwt');
    String url = 'http://192.168.1.21:5000/api/v1/users/deletescheduledtask';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json = '{"task_id":"$_taskId"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    final jsonResponse = jsonDecode(response.body);
    // print(jsonResponse);
  }

  @override
  void initState() {
    _calendarController = CalendarController();
    _getScheduledTask();
    _selectedEvents = _events[DateTime.now()] ?? [];
    _selectedId = _events[DateTime.now()] ?? [];
    selectedEventsLength = _selectedEvents.length;
    // print(_selectedEvents);
    // print(_selectedId);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
              NavBar('Schedule', 0xFFF73D99, false),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                child: TableCalendar(
                    calendarController: _calendarController,
                    events: _events,
                    onDaySelected: (calendar_date, events) {
                      setState(() {
                        _selectedEvents = events;
                        selectedEventsLength = _selectedEvents.length;
                        // print(_selectedEvents);
                        _selectedDate = calendar_date;
                        date = DateTime.parse(
                            '${calendar_date.toString().split(" ")[0]} 00:00:00.000');
                        _selectedId = _id[date];
                        _selectedUserInchargeId = _user_incharge_id[date] ?? [];
                        _selectedColor = _color[date] ?? [];
                        _selectedAssigned = _assigned[date] ?? [];
                        print(_selectedDate);
                        // print(_id[date]);
                        // print(_id);
                        // print(_selectedId);
                      });
                    },
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Color(0xFF61C6C0)),
                        weekendStyle: TextStyle(color: Color(0xFFBDCC11))),
                    calendarStyle: CalendarStyle(
                      weekendStyle: TextStyle(color: Color(0xFFF28473)),
                      markersPositionBottom: 10.0,
                      markersColor: Colors.white,
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                        leftChevronIcon:
                            const Icon(Icons.chevron_left, color: Colors.white),
                        rightChevronIcon: const Icon(Icons.chevron_right,
                            color: Colors.white),
                        formatButtonTextStyle: TextStyle()
                            .copyWith(color: Colors.white, fontSize: 15.0),
                        formatButtonDecoration: BoxDecoration(
                          color: Color(0xFFF28473),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        formatButtonShowsNext: false),
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xFFF73D99),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xFFF28473),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    )),
              ),
              Container(
                  //  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 20.0, 40.0, 10.0),
                          constraints:
                              BoxConstraints.expand(height: 40.0, width: 40.0),
                          child: Icon(
                            Icons.av_timer,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 20.0, 9.0, 5.0),
                          child: Text('Schedules', style: TitleText),
                        ),
                        // SizedBox(
                        //   width: 100.0,
                        // ),
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
                                    itemCount: selectedEventsLength,
                                    itemBuilder: (context, index) {
                                      var colors = _selectedColor;
                                      var assigneds = _selectedAssigned;
                                      var task = _selectedEvents;
                                      var ids = _selectedId;
                                      var id = int.parse(_selectedId[index]);
                                      var color = _selectedColor[index];
                                      var assigned = _selectedAssigned[index];
                                      var description = _selectedEvents[index];
                                      print(description);
                                      return Dismissible(
                                        direction: DismissDirection.endToStart,
                                        key: Key(description),
                                        onDismissed: (direction) async {
                                          await _deleteScheduledTask(id);
                                          // _getScheduledTask();
                                          task.removeAt(index);
                                          ids.removeAt(index);
                                          colors.removeAt(index);
                                          assigneds.removeAt(index);
                                          setState(() {
                                            _selectedEvents = task;
                                            _selectedId = ids;
                                            selectedEventsLength =
                                                _selectedEvents.length;
                                            _selectedColor = colors;
                                            _selectedAssigned = assigneds;

                                            // pos = _memberIds.indexOf(
                                            //     _selectedUserInchargeId[index]);
                                            // if (pos != -1) {
                                            //   assigned = _members[pos];
                                            //   color =
                                            //       int.parse(_memberColors[pos]);
                                            // } else {
                                            //   assigned = 'Assign to user';
                                            //   color = 0xFF848484;
                                            // }
                                            // taskStatus.removeAt(index);
                                            // print(task.length);
                                          });
                                          // Shows the information on Snackbar
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      " Schedule $description dismissed !")));
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
                                            child: Schedules(
                                                description,
                                                assigned,
                                                color,
                                                id,
                                                _getScheduledTask,
                                                _selectedDate),
                                          ),
                                        ),
                                      );
                                    })),
                          ],
                        )),
                  ])),
            ]))));
  }
}

class Schedules extends StatefulWidget {
  String task;
  String assigned;
  int color;
  int id;
  Function getSceduledTask;
  DateTime selectedDate;
  // String task_id;
  Schedules(this.task, this.assigned, this.color, this.id, this.getSceduledTask,
      this.selectedDate);
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // alignment: MainAxisAlignment.spaceBetween,
        // height: 100.0,
        width: 500.0,
        margin: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 15.0),
        color: Color(widget.color),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              widget.task,
              textAlign: TextAlign.left,
              style: NormalFont,
            ),
            SizedBox(
              width: 40.0,
            ),
            Container(
                child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return DialogBoxAssign(widget.id, widget.getSceduledTask,
                          widget.selectedDate);
                      // return DialogBox(callback);
                    });
              },
              child: Text(widget.assigned, textAlign: TextAlign.center),
            ))
          ],
        )
        // )
        );
  }
}

/////////////////////////////// DIALOG BOX ASSIGN TASK//////////////////////////////////
class DialogBoxAssign extends StatefulWidget {
  int id;
  Function getScheduledTask;
  DateTime selectedDate;
  DialogBoxAssign(this.id, this.getScheduledTask, this.selectedDate);
  // DateTime date;
  // Function callback;
  // DialogBoxAssign(this.date, this.callback);
  @override
  _DialogBoxAssignState createState() => _DialogBoxAssignState();
}

class _DialogBoxAssignState extends State<DialogBoxAssign>
    with TickerProviderStateMixin {
  List<String> _assignTypeList = ['Individual', 'Round Robin'];
  List<String> _memberNames = []; // Option 2
  // List<String> _repeatFor = [for (var i = 1; i < 51; i += 1) '$i'];
  // TimeOfDay _time = new TimeOfDay.now();
  bool isButtonEnabled = false;
  final assignController = TextEditingController();
  // List<String> _repeatFor =
  String _assignedType = 'Round Robin';
  String _pickedMember;
  // String _repeatedFor = '1';

  Future<void> _getMemberNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> memberNames = prefs.getStringList('members');
    setState(() {
      _memberNames = memberNames;
      _pickedMember = _memberNames[0];
      print(widget.selectedDate);
    });
  }

  Future<void> _assign(String username, int taskId) async {
    String token = await storage.read(key: 'jwt');
    String url = 'http://192.168.1.21:5000/api/v1/users/assign';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json = '{"user_incharge_username":"$username", "task_id":"$taskId"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  Future<void> _assignroundrobin(int taskId, DateTime selected_date) async {
    String token = await storage.read(key: 'jwt');
    // DateTime.parse('${responseJson[y]["date"]} 00:00:00.000');
    print(selected_date);
    String date = getdate_post2(selected_date);
    String url = 'http://192.168.1.21:5000/api/v1/users/assignroundrobin';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json = '{"task_id":"$taskId", "selected_date":"$date"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  @override
  void initState() {
    _getMemberNames();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    assignController.dispose();
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
                      "Assign to roomie",
                      style: DialogTextPink,
                    ),
                  ),
                ),
              ],
            )),
        content: Container(
            height: 200.0,
            width: 300.0,
            child: Column(children: <Widget>[
              //////////////////// DROPDOWN BUTTON
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Repeat Type:  ',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    child: DropdownButton(
                      hint: Text(''), // Not necessary for Option 1
                      value: _assignedType,
                      items: _assignTypeList.map((option) {
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
                          _assignedType = newValue;
                          // widget.callback(newValue);
                          print(_assignedType);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: _assignedType == 'Individual' ? true : false,
                  child: Row(children: <Widget>[
                    Container(
                      child: Text(
                        'Assign To:  ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      child: DropdownButton(
                        hint: Text(''), // Not necessary for Option 1
                        value: _pickedMember,
                        items: _memberNames.map((option) {
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
                            _pickedMember = newValue;
                            // widget.callback(newValue);
                            print(_pickedMember);
                          });
                        },
                      ),
                    ),
                  ])),
              Container(
                  margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 50.0),
                  child: RaisedButton(
                    color: Color(0xFF61C6C0),
                    onPressed: () async {
                      if (_assignedType == 'Individual') {
                        await _assign(_pickedMember, widget.id);
                        await widget.getScheduledTask();
                        Navigator.pop(context);
                      } else {
                        await _assignroundrobin(widget.id, widget.selectedDate);
                        await widget.getScheduledTask();
                        Navigator.pop(context);
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(10.0),
                    child: Text('Assign',
                        textAlign: TextAlign.center, style: BtnText),
                  )),
            ])));
  }
}

/////////////////////////////// DIALOG BOX ADD TASK//////////////////////////////////
class DialogBox extends StatefulWidget {
  DateTime date;
  Function callback;
  // Function(String) callback;
  ///asdasd
  DialogBox(this.date, this.callback);
  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> with TickerProviderStateMixin {
  List<String> _repeatBy = ['weekly', 'monthly']; // Option 2
  List<String> _repeatFor = [for (var i = 1; i < 51; i += 1) '$i'];
  TimeOfDay _time = new TimeOfDay.now();
  String _timeString = 'Select Time';
  bool isButtonEnabled = false;
  final taskController = TextEditingController();
  // List<String> _repeatFor =
  String _repeatedBy = 'weekly';
  String _repeatedFor = '1';

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    // taskController.addListener(_printLatestValue);
  }

  // _printLatestValue() {
  //   print("Second text field: ${taskController.text}");
  // }

////////////////////////////POST REQUEST CREATE NEW TASK/////////////////////
  Future<String> _createTask(String task, String repeat_by, String repeat_for,
    String repeat_on, String date_time) async {
    String token = await storage.read(key: 'jwt');
    // set up POST request arguments
    String url = 'http://192.168.1.21:5000/api/v1/users/new_scheduled';
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
        // print(isButtonEnabled);
      } else {
        isButtonEnabled = true;
        // print(isButtonEnabled);
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

    if (picked != null) {
      String minute = picked.minute.toString();
      if (minute.length<2){
        minute = '0$minute';
      }
      setState(() {
        _time = picked;
        _timeString = '${picked.hour.toString()}:$minute';
      });
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
          padding: EdgeInsets.only(bottom: 12.0),
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
                    "New Task",
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
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: Color(0xFFF73D99),
                    size: 30.0,
                  ),
                ),
              ),
            ],
          )),
      content: Container(
          height: 300.0,
          width: 300.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
                child: TextFormField(
                  controller: taskController,
                  style: TextInBox,

                  // style: TextStyle(color: Color(0xFFF73D99)),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'Add Task',
                      hintStyle: TextStyle(
                          color: Color(0xFF848484).withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                          fontSize: 20.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFF73D99))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFF61C6C0)))),
                  onChanged: (val) {
                    isEmpty();
                  },
                ),
              ),
              //////////////////// DROPDOWN BUTTON
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 3.0, 0, 0),
                    margin: EdgeInsets.only(right: 20.0),
                    child: Text(
                      'Repeat On:',
                      // style: TextStyle(color: Color(0xFFF73D99)),
                      style: TextInBoxPink,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 3.0, 0, 0),
                    child: DropdownButton(
                      hint: Text(''), // Not necessary for Option 1
                      value: _repeatedBy,
                      items: _repeatBy.map((option) {
                        return DropdownMenuItem(
                          child: new Text(
                            option,
                            // style: TextStyle(color: Color(0xFFF73D99)),
                            style: TextInBoxPink,
                          ),
                          value: option,
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _repeatedBy = newValue;
                          // widget.callback(newValue);
                          print(widget.date);
                          print(_repeatedBy);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 3.0, 0, 0),
                  margin: EdgeInsets.only(right: 20.0),
                  child: Text(
                    'Repeat For:',
                    style: TextInBoxPink,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 3.0, 0, 0),
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
                        // print(_repeatedFor);
                      });
                    },
                  ),
                ),
              ]),
              Row(children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 3.0, 0, 0),
                  margin: EdgeInsets.only(right: 20.0),
                  child: Text("Remind At:",
                  style: TextInBoxPink,),

                ),
                Container(
                  height: 40.0,
                  padding: EdgeInsets.fromLTRB(0, 3.0, 0, 0),
                  child:RaisedButton(
                    color:Color(0xFFF73D99).withOpacity(0.8),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: new BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(5.0),
                    child:
                      new Text('$_timeString'),
                      textColor: Colors.white,
                    onPressed: () {
                      _selectTime();
                    }),
                ),
              ],),
              Center(
                child: Container(
                    margin: EdgeInsets.only(top: 25.0),
                    // margin: EdgeInsets.fromLTRB(50.0, 15.0, 60.0, 50.0),
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
              ),
            ],
          )),

      //  content: Text("Hi Bello",style:AddTaskBody,),
    );
  }
}
