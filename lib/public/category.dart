import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../main.dart';
import '../style.dart';
import '../widgets/appbar.dart';
import '../widgets/members.dart';
import '../widgets/publictask.dart';

class CategoryPage extends StatefulWidget {
  String categoryId;
  String category;
  String createdBy;
  String completedBy;
  CategoryPage(this.categoryId,this.category,this.createdBy,this.completedBy);

  @override
  CategoryState createState() => CategoryState(categoryId,category,createdBy,completedBy);
}

class _AddTask{
  String status;
  _AddTask({this.status});
  factory _AddTask.fromJson(Map<String,dynamic> parsedJson){
    return _AddTask(
      status: parsedJson['status'],
    );
  }
}

class CategoryState extends State<CategoryPage> {
  String categoryId;
  String category;
  String createdBy;
  String completedBy;
  CategoryState(this.categoryId,this.category,this.createdBy,this.completedBy);

  List _members = [];
  List _memberColors = [];
  List _memberIds = [];
  List<String> _taskIds = [];
  List<String> _tasks = [];
  List<String> _createdBys = [];
  List<bool> _isCompleteds = [];
  int _taskLength = 0;
 
  final storage = FlutterSecureStorage();
  final taskController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    taskController.dispose();
    super.dispose();
  }

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

  //GET REQUEST TO GET TASK LIST IN THE PUBLIC CATEGORY
  _getPublicTask(String categoryId) async{
    String token = await storage.read(key: 'jwt');
    String url = 'http://10.0.2.2:5000/api/v1/users/get/public_task/$categoryId';
    http.Response response = await http.get(
      url,
      headers:{'Authorization':'Bearer $token'}
    );
    final responseJson = jsonDecode(response.body);
    //Convert list of objects into individual lists:
    List<String> taskId = [];
    List<String> task = [];
    List<String> createdBy = [];
    List<bool> isCompleted = [];
    for (int i=0;i<responseJson.length;i++){
      taskId.add(responseJson[i]["id"]);
      task.add(responseJson[i]["task"]);
      createdBy.add(responseJson[i]["created by"]);
      isCompleted.add(responseJson[i]["is completed"]);
    }
    print(taskId);
    print(task);
    setState((){
      _taskIds = taskId;
      _tasks = task;
      _createdBys = createdBy;
      _isCompleteds = isCompleted;
      _taskLength = _tasks.length;
    });
  }

  //POST REQUEST TO ADD ITEMS
  _addPublicTask(String task, String categoryId) async{
    String token = await storage.read(key: 'jwt');
    String url = 'http://10.0.2.2:5000/api/v1/users/newpublictask';
    String json = '{"task":"$task","category_id":"$categoryId"}';
    http. Response response = await http.post(
      url,
      headers: {
        'Content-type':'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json,
    );
    final jsonResponse = jsonDecode(response.body);
    _AddTask addTask = new _AddTask.fromJson(jsonResponse);
    print(addTask.status);
    if (addTask.status == "success"){
      Flushbar(
        message: '$category list has been updated',
        backgroundColor: Colors.blueGrey,   
        duration: Duration(seconds: 3),
      )..show(context);
      _getPublicTask(categoryId);
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    getStoredMemberData();
    _getPublicTask(categoryId);
  }

  complete(int taskId) async{
    int positionChg = _taskIds.indexOf(taskId.toString());
    List updatedIsCompleted = _isCompleteds;
    if (updatedIsCompleted[positionChg]){
      updatedIsCompleted[positionChg] = false;
    } else {
      updatedIsCompleted[positionChg] = true;
    }
    setState((){
      _isCompleteds = updatedIsCompleted;
    });
  }
  delete(int taskId) async{
    int positionDelete = _taskIds.indexOf(taskId.toString());
    List<String> newTaskIds = _taskIds;
    List<String> newTasks = _tasks;
    List<String> newCreatedBy = _createdBys;
    List<bool> newIsCompleted = _isCompleteds;
    newTaskIds.removeAt(positionDelete);
    newTasks.removeAt(positionDelete);
    newCreatedBy.removeAt(positionDelete);
    newIsCompleted.removeAt(positionDelete);
    setState((){
      _taskIds = newTaskIds;
      _tasks = newTasks;
      _createdBys = newCreatedBy;
      _isCompleteds = newIsCompleted;
      _taskLength = _tasks.length;
    });
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
            
            NavBar('$category',0xFFBDCC11,false),

            Container(
              margin: EdgeInsets.symmetric(vertical:30.0,horizontal:40.0),
              // decoration: BoxDecoration(border: Border.all(color:Colors.white)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.fromLTRB(80.0,0.0,80.0,20.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color:Color(0xFFF96861)),
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Creator : ',style:BoldFont,textAlign:TextAlign.center),
                        Text('$createdBy',style:NormalFont,textAlign:TextAlign.center),
                      ],
                    ) 
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 30.0, bottom: 5.0),
                    child:Text('Members',style:NormalFont),
                  ),

                   Container(
                    height: 85.0,
                    padding: EdgeInsets.all(5.0),
                    margin: EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(children: <Widget>[
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _members.length,
                            itemBuilder: (context,index){
                              var member = _members[index];
                              var color = int.parse(_memberColors[index]);
                              return HouseMembers2(member,color);
                            }
                          )
                        ),
                      ),
                    ],)
                  ),

                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
                      Text('complete by: ',style:MemberListBold),
                      Text('$completedBy',style:MemberList),

                    ],)
                  ),

                  Container(
                    height: 450.0,
                    padding: EdgeInsets.symmetric(vertical:30.0,horizontal:40.0),
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.white),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        TextField(
                          controller: taskController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Type Something',
                            hintStyle: TextStyle(color:Colors.grey,),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.add,color: Colors.white,size: 35.0,),
                              onPressed: (){
                                _addPublicTask(taskController.text,categoryId);
                                FocusScope.of(context).unfocus();
                                WidgetsBinding.instance.addPostFrameCallback( (_) => taskController.clear());
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:Color(0xFFDB6ED6)),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _taskLength,
                              itemBuilder: (context,index){
                                var taskId = int.parse(_taskIds[index]);
                                var task = _tasks[index];
                                var createdBy = _createdBys[index];
                                var isCompleted = _isCompleteds[index];
                                var memberPosition = _memberIds.indexOf(createdBy);
                                int memberColor = 0;
                                if (memberPosition != -1){
                                  memberColor = int.parse(_memberColors[memberPosition]);
                                } else {
                                  memberColor = 0xFF808080;
                                }
                                return PublicTask(taskId,task,isCompleted,memberColor,complete,delete);
                              }
                            ),
                          )
                        )
                      
                      ],
                    )
                  )     

                ]
              )
            ) 
            
          ]
        )
      )
    );
  }

}
