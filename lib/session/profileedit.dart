import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import '../main.dart';
import '../style.dart';
import '../widgets/appbar.dart';

class ProfileEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, 
      body: ProfileEditForm()
    );
  }
}

class ProfileEditForm extends StatefulWidget {
  @override
  ProfileEditState createState() => ProfileEditState();
}

class _UserInfo{
  List<dynamic> usernames;
  List<dynamic> emails;
  _UserInfo({this.usernames,this.emails});
  factory _UserInfo.fromJson(Map<String,dynamic> parsedJson){
    return _UserInfo(
      usernames: parsedJson['usernames'],
      emails: parsedJson['emails'],
    );
  }
}

class _UpdateInfo{
  String status;
  _UpdateInfo({this.status});
  factory _UpdateInfo.fromJson(Map<String,dynamic> parsedJson){
    return _UpdateInfo(
      status: parsedJson['status'],
    );
  }
}

class ProfileEditState extends State<ProfileEditForm> {
  final _formkey = GlobalKey<FormState>();
  //Initializing states
  String _username ='';
  String _email = '';
  List existingUsernames = [];
  List existingEmails = [];
  //variables for updated info
  String updatedEmail;
  String updatedUsername;

  final storage = FlutterSecureStorage();

  //create text controller for form validation
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrUserInfo();
    getExistingUserInfo();
  }

  Future<void> getCurrUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    String email = prefs.getString("email");
    setState(() => _username = username);
    setState(() => _email = email);
    usernameController.text = username;
    emailController.text = email;
  }

  //GET REQUEST TO SEE LIST OF USERS:
  Future <void> getExistingUserInfo() async{
    String url = 'http://192.168.1.137:5000/api/v1/users/';
    http.Response response = await http.get(url,headers:{"Content-type":"application/json"});
    final responseJson = jsonDecode(response.body);
    _UserInfo userInfo = new _UserInfo.fromJson(responseJson);
    setState(() => existingUsernames = userInfo.usernames);
    setState(() => existingEmails = userInfo.emails);
  }

  //POST REQUEST TO UPDATE USERNAME/EMAIL:
  _update(String updateUsername, String updateEmail) async{
    String token = await storage.read(key:'jwt');
    String url = 'http://192.168.1.137:5000/api/v1/users/edit';
    String json ='{"username": "$updateUsername", "email": "$updateEmail"}';
    http.Response response = await http.post(
      url,
      headers: {
        'Content-type':'application/json',
        'Authorization':'Bearer $token'
      },
      body: json,
    );
    final jsonResponse = jsonDecode(response.body);
    _UpdateInfo update = new _UpdateInfo.fromJson(jsonResponse);
    print(update.status);
    if (update.status == "success") {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('User info successfully updated!')));
      await new Future.delayed(const Duration(seconds: 3));

      //Edit Shared Preferences;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Edit members list
      List members = prefs.getStringList('members');
      String username = prefs.getString("username");
      members[members.indexOf('$username')] = updateUsername;
      prefs.remove("members");
      prefs.remove("username");
      prefs.remove("email");
      prefs.setString("username","$updateUsername");
      prefs.setString("email","$updateEmail");
      prefs.setString("members","$members");
      setState(() => _username = updateUsername);
      setState(() => _username = updateEmail);
      Navigator.pushNamed(context,HomeRoute);
    }
  }
  
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: <Widget>[
          
          NavBar('Profile',0xFFF96861,false),

          Form(
            key: _formkey,    
            child: Container(
              margin: EdgeInsets.fromLTRB(40.0,100.0,40.0,0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  Text('Username', style: NormalFont, textAlign: TextAlign.left),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit,color: Colors.white,size: 20.0,),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFF96861)),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15.0),
                        )
                      ),                        
                      validator: (value) {
                        print(_username);
                        print(_email);
                        if (value.isEmpty){
                          return 'please enter your desired username';
                        } else if (value == _username && emailController.text == _email){
                          return 'neither username nor email has been changed';
                        } else if (value != _username && existingUsernames.contains(value)){
                          return 'username already exists! Please pick another';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String value){
                        updatedUsername = value;
                      },
                    )
                  ),

                  Text('Email Address', style: NormalFont, textAlign: TextAlign.left),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit,color: Colors.white,size: 20.0,),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFF73D99)),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15.0),
                        )
                      ),
                      validator: (value) {
                        if (value.isEmpty){
                          return 'please enter your desired email address';
                        } else if (value == _email && usernameController.text == _username){
                          return 'neither username nor email has been changed';
                        } else if (value != _email && existingEmails.contains(value)){
                          return 'email address already exists! Please pick another';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String value){
                        updatedEmail = value;
                      },
                    )
                  ),

                Container(
                  margin: EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 40.0),
                  child: RaisedButton(
                    color: Color(0xFF61C6C0),
                    onPressed: null,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)
                    ),
                    padding: EdgeInsets.symmetric(vertical:15.0,horizontal:20.0),
                    child: Text('Change Password',textAlign: TextAlign.center,style: BtnText),
                  )
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal:100.0),
                  child: RaisedButton(
                    padding: EdgeInsets.all(20.0),
                    color: Color(0xFFF96861),
                    onPressed: (){
                      if(_formkey.currentState.validate()){
                        // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Updating user information...')));
                      _formkey.currentState.save();
                      print(updatedEmail + updatedUsername);
                      _update(updatedUsername,updatedEmail);                        
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius:
                        new BorderRadius.circular(15.0)
                      ),
                    child: Text('Update',textAlign: TextAlign.center,style: BtnText),
                  )
                ),

                ],
              )
            ) 
            
          ),

        ]
      )
    );
  }

}
