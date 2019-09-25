import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../main.dart';
import '../style.dart';
import '../widgets/appbar.dart';
import '../widgets/tasks.dart';
import '../public/category.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key key}) : super(key: key);
  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<TodoPage> {
  List<String> _tasks = [];
  int _taskLength = 0;
  List<String> _taskId = [];
  List<bool> _is_completed = [];

  List<String> _category = [];
  int _categoryLength = 0;
  List<String> _categoryId = [];
  List<bool> _is_completedPB = [];
  List<String> _completed_byPB = [];
  List<String> _created_byPB = [];
  // bool isButtonEnabled = false;

  _getPrivateTask() async {
    String token = await storage.read(key: 'jwt');
    String url = 'https://chores-of-duty.herokuapp.com/api/v1/users/get/private_task';
    http.Response response = await http.get(
      '$url',
      headers: {'Authorization': 'Bearer $token'},
    );
    // print(response.body);
    final responseJson = jsonDecode(response.body);

    List<String> tasks = [];
    List<bool> is_completed = [];
    List<String> task_id = [];

    for (int i = 0; i < responseJson.length; i++) {
      tasks.add(responseJson[i]["task"]);
      task_id.add(responseJson[i]["id"]);
      is_completed.add(responseJson[i]["is completed"]);
    }
    setState(() => _tasks = tasks);
    setState(() => _taskLength = tasks.length);
    setState(() => _taskId = task_id);
    setState(() => _is_completed = is_completed);
    print(_taskLength);
    print(_taskId);
    print(_tasks);
  }

  _completedPrivateTask(int _taskId) async {
    String token = await storage.read(key: 'jwt');
    String url = 'https://chores-of-duty.herokuapp.com/api/v1/users/completeprivatetask';
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

  _deletePrivateTask(int _taskId) async {
    String token = await storage.read(key: 'jwt');
    String url = 'https://chores-of-duty.herokuapp.com/api/v1/users/deleteprivatetask';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json = '{"task_id":"$_taskId"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  _getPublicCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomId = prefs.getString("room_id");
    String token = await storage.read(key: 'jwt');
    String url =
        'https://chores-of-duty.herokuapp.com/api/v1/users/get/public_category/$roomId';
    http.Response response = await http.get(
      '$url',
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);

    // List<String> room_id = [];
    List<String> category = [];
    List<String> category_id = [];
    List<bool> is_completedPB = [];
    List<String> completed_byPB = [];
    List<String> created_byPB = [];
    for (int i = 0; i < responseJson.length; i++) {
      category.add(responseJson[i]["category"]);
      category_id.add(responseJson[i]["id"]);
      completed_byPB.add(responseJson[i]["completed by"]);
      is_completedPB.add(responseJson[i]["is completed"]);
      created_byPB.add(responseJson[i]["created by"]);
    }
    setState(() => _category = category);
    setState(() => _categoryLength = category.length);
    setState(() => _categoryId = category_id);
    setState(() => _is_completedPB = is_completedPB);
    setState(() => _completed_byPB = completed_byPB);
    setState(() => _created_byPB = created_byPB);
  }

  // getPublicTask() async{
  //   _getPublicCategory();
  // }

  _completedPublicCategory(int _categoryId) async {
    String token = await storage.read(key: 'jwt');
    String url = 'https://chores-of-duty.herokuapp.com/api/v1/users/completepubliccategory';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json = '{"category_id":"$_categoryId"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    final jsonResponse = jsonDecode(response.body);
    // print(jsonResponse);
  }

  _deletePublicCategory(int _categoryId) async {
    String token = await storage.read(key: 'jwt');
    String url = 'https://chores-of-duty.herokuapp.com/api/v1/users/deletepubliccategory';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json = '{"category_id":"$_categoryId"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  @override
  void initState() {
    super.initState();
    _getPrivateTask();
    _getPublicCategory();
  }

  final newTaskController = TextEditingController();
  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              NavBar('To Do', 0xFFBDCC11, false),
              Container(
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                  // margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
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
                          width: 100.0,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                            width: 60,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PrivateDialog(_getPrivateTask);
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
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 500.0,
                                height: 230.0,
                                child: Center(
                                  child: (_taskLength == 0)
                                      ? Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'No Task Yet',
                                            textAlign: TextAlign.center,
                                            style: NormalFont,
                                          ))
                                      : ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: _taskLength,
                                          itemBuilder: (context, index) {
                                            var task = _tasks;
                                            var taskStatus = _is_completed;
                                            var description = _tasks[index];
                                            var taskId =
                                                int.parse(_taskId[index]);
                                            bool completed =
                                                _is_completed[index];
                                            return Dismissible(
                                              direction:
                                                  DismissDirection.endToStart,
                                              key: Key(description),
                                              onDismissed: (direction) {
                                                _deletePrivateTask(taskId);
                                                task.removeAt(index);
                                                taskStatus.removeAt(index);
                                                _taskId.removeAt(index);
                                                setState(() {
                                                  _taskId = _taskId;
                                                  _tasks = task;
                                                  _is_completed = taskStatus;
                                                  _taskLength = task.length;
                                                });
                                                // Shows the information on Snackbar
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                  " Task $description dismissed !",
                                                  textAlign: TextAlign.center,
                                                )));
                                              },
                                              background: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0.0, 9.0, 0.0, 9.0),
                                                alignment: AlignmentDirectional
                                                    .centerEnd,
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
                                                    //pass Task id
                                                    _completedPrivateTask(
                                                        taskId);
                                                    setState(() {
                                                      _is_completed[index] =
                                                          !_is_completed[index];
                                                    });
                                                  },
                                                  child: PersonalTasks(
                                                      description, completed),
                                                ),
                                              ),
                                            );
                                          }),
                                )),
                          ],
                        )),
                  ])),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 20.0, 30.0, 5.0),
                          constraints:
                              BoxConstraints.expand(height: 40.0, width: 40.0),
                          child: Icon(
                            Icons.people,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 20.0, 50.0, 5.0),
                          child: Text('Public', style: TitleText),
                        ),
                        SizedBox(
                          width: 100.0,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                            width: 60,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PublicDialog(_getPublicCategory);
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
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              width: 500.0,
                              height: 230.0,
                              child: Center(
                                child: (_categoryLength == 0)
                                    ? Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          'No Category Yet',
                                          textAlign: TextAlign.center,
                                          style: NormalFont,
                                        ))
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: _categoryLength,
                                        itemBuilder: (context, index) {
                                          var category = _category;
                                          var categoryStatus = _is_completedPB;
                                          var completed_byPB = _completed_byPB;
                                          var created_byPB = _created_byPB;
                                          var descriptionPublic =
                                              _category[index];
                                          var categoryId =
                                              int.parse(_categoryId[index]);
                                          bool completedPublic =
                                              _is_completedPB[index];
                                          var completedby =
                                              _completed_byPB[index];
                                          var createdby = _created_byPB[index];
                                          return Dismissible(
                                            direction:
                                                DismissDirection.endToStart,
                                            key: Key(descriptionPublic),
                                            onDismissed: (direction) {
                                              _deletePublicCategory(categoryId);
                                              category.removeAt(index);
                                              categoryStatus.removeAt(index);
                                              completed_byPB.removeAt(index);
                                              created_byPB.removeAt(index);
                                              setState(() {
                                                _category = category;
                                                _is_completedPB = categoryStatus;
                                                _completed_byPB = completed_byPB;
                                                _created_byPB = created_byPB;
                                                _categoryLength = category.length;
                                              });
                                              // Shows the information on Snackbar
                                              Scaffold.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                " Category $descriptionPublic dismissed !",
                                                textAlign: TextAlign.center,
                                              )));
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
                                                  print("HI");
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoryPage(
                                                                  categoryId
                                                                      .toString(),
                                                                  descriptionPublic,
                                                                  createdby,
                                                                  completedby)));
                                                },
                                                child: Container(
                                                    child: GroupCategory(
                                                        descriptionPublic,
                                                        completedPublic)),
                                              ),
                                            ),
                                          );
                                        }),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ])));
  }
}

class PublicDialog extends StatefulWidget {
  Function callback;
  PublicDialog(this.callback);
  @override
  _PublicDialogState createState() => _PublicDialogState();
}

class _PublicDialogState extends State<PublicDialog> {
  String _date = 'Select Date';
  String _time = 'Select Time';
  bool isButtonEnabled = false;

  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(2010),
        lastDate: new DateTime(2022),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        });
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _date = DateFormat("y-MM-dd").format(picked).toString();
      });
    }
  }

  Future<Null> _selectTime() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked != null) {
      String minute = picked.minute.toString();
      if (minute.length < 2) {
        minute = '0$minute';
      }
      setState(() => _time = '${picked.hour.toString()}:$minute');
    }
  }

  _postPublicCategory(String _category, String _completed_byPB) async {
    String token = await storage.read(key: 'jwt');
    String url = 'https://chores-of-duty.herokuapp.com/api/v1/users/newpubliccategory';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    String json =
        '{"category":"$_category", "description":" ", "completed_by":"$_completed_byPB"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
  }

  @override
  void initState() {
    super.initState();
  }

  void isEmpty() {
    setState(() {
      if (newCategoryController.text.length == 0) {
        isButtonEnabled = false;
        print(isButtonEnabled);
      } else {
        isButtonEnabled = true;
        print(isButtonEnabled);
      }
    });
  }

  final newCategoryController = TextEditingController();
  @override
  void dispose() {
    newCategoryController.dispose();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(
                "Add New Category",
                style: AddTaskTitle,
              ),
            ),
            // SizedBox(
            //   width: 27,
            // ),
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
        height: 280,
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: TextFormField(
                  autofocus: true,
                  controller: newCategoryController,
                  style: TextInBox,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'New Category?',
                      hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.2),
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFF96861))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFF96861)))),
                  onChanged: (val) {
                    isEmpty();
                  }),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 15.0),
              child: Text(
                "Complete by :",
                // "Complete by : ${DateFormat("y-MM-dd").format(_date).toString()} ${_time.hour.toString()}:${_time.minute.toString()}:00",
                style: CompletedBy,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: Color(0xFFBDCC11),
                      onPressed: () {
                        _selectDate();
                        // _completed_byPB.add(
                        //     "${DateFormat("y-MM-dd").format(_date).toString()} ${_time.hour.toString()}:${_time.minute.toString()}:00");
                      },
                      child: Text('$_date', style: NormalFont),
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: Color(0xFF61C6C0),
                      onPressed: () {
                        _selectTime();
                        // _completed_byPB.add(
                        //     "${DateFormat("y-MM-dd").format(_date).toString()} ${_time.hour.toString()}:${_time.minute.toString()}:00");
                      },
                      child: Text(
                        "$_time",
                        style: NormalFont,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: 400,
                margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                child: RaisedButton(
                  color: Color(0xFFF96861),
                  onPressed: isButtonEnabled
                      ? () async {
                          Navigator.pop(context);
                          // _category.add(newCategoryController.text);
                          // _is_completedPB.add(false);
                          // _completed_byPB.add("");
                          await _postPublicCategory(
                              newCategoryController.text, "$_date $_time:00");
                          await widget.callback();
                          newCategoryController.clear();
                          // result 1 and it will be executed after 2 seconds
                        }
                      : null,
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

class PrivateDialog extends StatefulWidget {
  Function refresh;
  PrivateDialog(this.refresh);
  @override
  _PrivateDialogState createState() => _PrivateDialogState();
}

class _PrivateDialogState extends State<PrivateDialog> {
  bool isButtonEnabled = false;

  _postPrivateTask(String _tasks) async {
    String token = await storage.read(key: 'jwt');
    String url = 'https://chores-of-duty.herokuapp.com/api/v1/users/newprivatetask';
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
  void initState() {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  style: TextInBox,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'What Chu wanna Do?',
                      hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.2),
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFF96861))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFF96861)))),
                  onChanged: (val) {
                    isEmpty();
                  }),
            ),
            Container(
                width: 400,
                margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: RaisedButton(
                  color: Color(0xFFF96861),
                  onPressed: isButtonEnabled
                      ? () async {
                          await _postPrivateTask(newTaskController.text);
                          await widget.refresh();
                          newTaskController.clear();
                          Navigator.pop(context);
                        }
                      : null,
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
