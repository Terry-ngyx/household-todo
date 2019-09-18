import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../main.dart';
import '../style.dart';
import '../widgets/appbar.dart';
import '../widgets/tasks.dart';
// import '../widgets/newtasks.dart';

class _Task {
  String status;
  String task_id;
  int user_id;
  String descriptions;
  List<bool> is_completed;
  String name;
  String jwt_token;

  _Task({
    this.status,
    this.descriptions,
    this.task_id,
    this.user_id,
    this.is_completed,
    this.jwt_token,
    this.name,
  });

  factory _Task.fromJson(Map<String, dynamic> parsedJson) {
    return _Task(
      status: parsedJson['status'],
      user_id: parsedJson['user_id'],
      task_id: parsedJson['task_id'],
      jwt_token: parsedJson['jwt_token'],
      name: parsedJson['name'],
      descriptions: parsedJson['description'],
      is_completed: parsedJson['is_completed'],
    );
  }
}

class TodoPage extends StatefulWidget {
  TodoPage({Key key}) : super(key: key);
  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<TodoPage> {
  List<bool> is_completed = [false, true, false, true];
  List _descriptions = ["Hello", "Hi", "Bello", "hahah"];

  List _descriptionsPublic = ["Groceries", "BBQ", "Shopping", "Travel"];
  List<bool> is_completedPublic = [false, true, false, true];

  String _roomId = "1";
  String jwt_token = "haaha";
  String _userid = "1";
  String _taskid = "1";
  String _username = "linglee";
  // List _memberIds = [];
  // List _memberColors = [];
  // List _members = [];
  // List _name = [];

  // final storage = FlutterSecureStorage();

  // Future<void> getPersonalTask() async {
  //   final storage = FlutterSecureStorage();
  //   String token = await storage.read(key: 'jwt');
  //   String url = "localhost:5000/api/v1/users/get/private_task";
  //   http.Response response =
  //       await http.get('$url', headers: {'Authorization': 'Bearer $token'});
  //   final responseJson = jsonDecode(response.body);
  //   _Task task = new _Task.fromJson(responseJson);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int userId = prefs.getInt("user_id");
  //   List name = prefs.getStringList("name");
  //   List descriptions = prefs.getStringList("descriptions");
  //   List members = prefs.getStringList("members");
  //   List memberColors = prefs.getStringList("members_color");
  //   setState(() => _name = name);
  //   setState(() => _userid = userId);
  //   setState(() => jwt_token = token);
  //   setState(() => _descriptions = descriptions);
  //   setState(() => _members = members);
  //   setState(() => _memberColors = memberColors);
  //   setState(() => _taskid = taskId)
  // }

  @override
  void initState() {
    super.initState();
    // getPersonalTask();
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
              NavBar('To Do'),
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
                                      return AlertDialog(
                                        title: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, 0, 12.0),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xFFF96861)),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "Add New Task",
                                                  style: AddTaskTitle,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
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
                                                margin: EdgeInsets.fromLTRB(
                                                    0.0, 10.0, 0.0, 0.0),
                                                child: TextFormField(
                                                  autofocus: true,
                                                  controller: newTaskController,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'What Chu wanna Do?',
                                                      hintStyle: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18.0),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              new BorderRadius.circular(
                                                                  15.0),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFFF96861))),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              new BorderRadius.circular(
                                                                  15.0),
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Color(0xFFF96861)))),
                                                ),
                                              ),
                                              Container(
                                                  width: 400,
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 30.0, 0.0, 0.0),
                                                  child: RaisedButton(
                                                    color: Color(0xFFF96861),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _descriptions.add(
                                                          newTaskController
                                                              .text);
                                                      is_completed.add(false);
                                                      newTaskController.clear();
                                                      print(_descriptions.length); // result 1 and it will be executed after 2 seconds
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .circular(
                                                                15.0)),
                                                    padding:
                                                        EdgeInsets.all(15.0),
                                                    child: Text('Add',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: BtnText),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      );
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
                                    itemCount: _descriptions.length,
                                    itemBuilder: (context, index) {
                                      var task = _descriptions;
                                      var taskStatus = is_completed;
                                      var description = _descriptions[index];
                                      bool completed = is_completed[index];
                                      // return PersonalTasks(description);
                                      // return PersonalTasks(description,completed,task_id);
                                      return Dismissible(
                                        direction: DismissDirection.endToStart,
                                        key: Key(description),
                                        onDismissed: (direction) {
                                          setState(() {
                                            task.removeAt(index);
                                            taskStatus.removeAt(index);
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
                                                is_completed[index] =
                                                    !is_completed[index];
                                              });
                                            },
                                            child: PersonalTasks(
                                                description, completed),
                                          ),
                                        ),
                                      );
                                    })),
                          ],
                        )),
                  ])),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 40.0, 30.0, 5.0),
                          constraints:
                              BoxConstraints.expand(height: 40.0, width: 40.0),
                          child: Icon(
                            Icons.people,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 40.0, 50.0, 5.0),
                          child: Text('Public', style: TitleText),
                        ),
                        SizedBox(
                          width: 110.0,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                            width: 80,
                            child: GestureDetector(
                              onTap: () {
                                // 
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
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                                width: 500.0,
                                height: 200.0,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: _descriptionsPublic.length,
                                    itemBuilder: (context, index) {
                                      var category = _descriptionsPublic;
                                      var categoryStatus = is_completedPublic;
                                      var descriptionPublic = _descriptionsPublic[index];
                                      bool completedPublic = is_completedPublic[index];
                                      // return PersonalTasks(description);
                                      // return PersonalTasks(description,completed,task_id);
                                      return Dismissible(
                                        direction: DismissDirection.endToStart,
                                        key: Key(descriptionPublic),
                                        onDismissed: (direction) {
                                          setState(() {
                                            category.removeAt(index);
                                            categoryStatus.removeAt(index);
                                            print(category.length);
                                          });
                                          // Shows the information on Snackbar
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      " Task $descriptionPublic dismissed !")));
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
                                                is_completedPublic[index] =
                                                    !is_completedPublic[index];
                                              });
                                            },
                                            child: GroupCategory(
                                                descriptionPublic, completedPublic),
                                          ),
                                        ),
                                      );
                                    })),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
