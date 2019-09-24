import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import '../main.dart';
import '../style.dart';
import '../widgets/appbar.dart';
import '../widgets/members.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class _Current{
  String username;
  String email;
  bool is_admin;
  String room_id;

  _Current({this.username,this.email,this.is_admin,this.room_id});

  factory _Current.fromJson(Map<String,dynamic> parsedJson){
    return _Current(
      username: parsedJson['username'],
      email: parsedJson['email'],
      is_admin: parsedJson['is_admin'],
      room_id: parsedJson['room id'],
    );
  }
}
class _Housemates{
  String status;
  List users;

  _Housemates({this.status,this.users});

  factory _Housemates.fromJson(Map<String,dynamic> parsedJson){
    return _Housemates(
      status: parsedJson['status'],
      users: parsedJson['users']
    );
  }
}

class HomePageState extends State<HomePage> {
  String _userid = '';
  String _roomid = '';
  String _username = '';
  bool _isAdmin = false;
  List<String> _memberColors = [];
  List<String> _members = [];
  List<String> _membersAdmin = [];

  @override
  void initState() {
    super.initState();
    getStoredData();
    getCurrentUser();
  }

  Future<void> getStoredData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("user_id");
    setState(() => _userid = userId);
  }

  //GET REQUEST FOR CURRENT USER:
  Future<void> getCurrentUser() async {
    String token = await storage.read(key:'jwt');
    // set up authenticated GET request arguments
    String url = 'http://10.0.2.2:5000/api/v1/users/me';
    // Map<String, String> headers ={'Authorization:': 'Bearer $_token'};
    http.Response response = await http.get(
      '$url',
      headers:  {'Authorization': 'Bearer $token'},
    );
    final responseJson = jsonDecode(response.body);
    _Current currentUser = new _Current.fromJson(responseJson);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username',currentUser.username);
    prefs.setString('email',currentUser.email);
    prefs.setBool('is_admin',currentUser.is_admin);
    print(currentUser.is_admin);
    prefs.setString('room_id',currentUser.room_id);
    //Get Shared Preference
    String roomId = prefs.getString("room_id");
    String username = prefs.getString("username");
    bool isAdmin = prefs.getBool("is_admin");
    //setState of current_user info
    setState(() => _roomid = roomId);
    setState(() => _username = username);
    setState(() => _isAdmin = isAdmin);


    await new Future.delayed(const Duration (seconds:1));
    getHousemates();
    }
  // GET REQUEST FOR ALL PEOPLE IN THE ROOM:
  Future<void> getHousemates() async {
    //Access Shared Preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String roomId = prefs.getString('room_id');
    // set up authenticated GET request arguments
    String url = 'http://10.0.2.2:5000/api/v1/users/housemates/$roomId';
    http.Response response = await http.get(
      '$url',
      headers:  {"Content-type": "application/json"}
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    _Housemates housemates = new _Housemates.fromJson(responseJson);

    //Convert list of objects into individual lists:
    List<String> memberAdmin=[];
    List<String> memberName=[];
    List<String> memberId=[];
    for (int i=0;i<housemates.users.length;i++){
      memberAdmin.add(housemates.users[i]["is admin"].toString());
      memberName.add(housemates.users[i]["name"].toString());
      memberId.add(housemates.users[i]["id"].toString());
    }

    //set member colors
    List<String> membercolors = ["0xFFF96861","0xFF61C6C0","0xFFBDCC11","0xFFF73D99","0xFFF28473","0xFFC7CEEA","0xFF73C2FB","0xFFF9C1A0","0xFFFFE9A1","0xFFFE5855"];
    
    //Store Shared Preferences
    prefs.setStringList("members",memberName);
    prefs.setStringList("member_is_admin",memberAdmin);
    prefs.setStringList("member_id",memberId);
    prefs.setStringList("member_color",membercolors);
    
    //Get Shared Preference and set state
    List members = prefs.getStringList("members");
    List member_is_admin = prefs.getStringList("member_is_admin");
    setState(()=>_members = memberName);
    setState(()=>_membersAdmin = memberAdmin);
    setState(() => _memberColors = membercolors);
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
            // ReusableWidgets.roomBanner("ROOM ID: $_roomid"),
            NavBar('ROOM ID: $_roomid',0xFFF96861,false),
            Container(
              margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //Members
                  Container(
                    height: 200.0,
                    margin: EdgeInsets.fromLTRB(0, 40.0, 0, 20.0),
                    // margin: EdgeInsets.only(bottom:20.0),
                    padding: EdgeInsets.fromLTRB(0.0,20.0,0.0,20.0),
                    decoration: BoxDecoration(
                      border: Border.all(width:3.0 , color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                          child:
                          Text("Members",textAlign: TextAlign.center,style:TitleText),
                          ),
                          Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width:3.0 ,color:Colors.white)
                            ),
                          ),
                          ),
                          Expanded(
                            child: Center(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _members.length,
                                itemBuilder: (context,index){
                                  var member = _members[index];
                                  var color = int.parse(_memberColors[index]);
                                  return HouseMembers(member,color);
                                }
                              )
                            )
                          )
                        ],)
                    )
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //Profile
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
                        // margin: EdgeInsets.only(bottom:20.0),
                        height: 160.0,
                        width: 160.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFFF96861)),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            Navigator.pushNamed(context,ProfileRoute);
                            print("are you working?");
                          },
                          child: Center(
                            child: Text('Profile',textAlign: TextAlign.center,style: TitleText)
                          )
                        )
                      ), 
                      //To do
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
                        // margin: EdgeInsets.only(bottom:20.0),
                        height: 160.0,
                        width: 160.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFFBDCC11)),
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap:() {
                            Navigator.pushNamed(context,TodoRoute);
                            print("are you working?");
                          },
                          child: Center(
                            child: Text('To Do',textAlign: TextAlign.center,style: TitleText)
                          )
                        )
                      ),
                    ]
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //Assign to me
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
                        // margin: EdgeInsets.only(bottom:20.0),
                        height: 160.0,
                        width: 160.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFF61C6C0)),
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap:() {
                            Navigator.pushNamed(context,MapRoute);
                            print("are you working?");
                          },
                          child: Center(
                            child: Text('Grocers Nearby',textAlign: TextAlign.center,style: TitleText)
                          )
                        )
                      ),
                      //Schedule
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
                        // margin: EdgeInsets.only(bottom:20.0),
                        height: 160.0,
                        width: 160.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFFF73D99)),
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap:() {
                            Navigator.pushNamed(context,ScheduleRoute);
                            print("are you working?");
                          },
                          child: Center(
                            child: Text('Schedule',textAlign: TextAlign.center,style: TitleText)
                          )
                        )
                      ),
                    ]
                  ),

                  //Due Today
                  // Container(
                  //   height: 125.0,
                  //   margin: EdgeInsets.only(bottom:20.0),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.white),
                  //     borderRadius: BorderRadius.circular(15.0)
                  //   ),
                  //   child: Container(
                  //     padding: EdgeInsets.all(10.0),
                  //     child: Column(children: <Widget>[
                  //       Text("Due Today :",textAlign: TextAlign.left,style:TitleText),
                  //       Container(
                  //         height: 73.0,
                  //         child: Center(
                  //           child: Text("Task/Schedule due by today", textAlign: TextAlign.center,style:MutedText)
                  //           //PENDING: NEED TO ADD IF ELSE STATEMENT SO IF THERE IS SOMETHING TO BE COMPLETED BY TODAY IT SHOWS UP HERE!
                  //         )
                  //       )
                  //     ],)
                  //   )
                  // ),

                ]
              )
            )
          ]
        )
      )
    );
  }
}

