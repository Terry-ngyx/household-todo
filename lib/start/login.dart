import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:household/start/getstarted.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:household/widgets/messaging_widget.dart';

import 'dart:async';
import 'dart:convert';

import '../style.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, 
      body: LoginForm()
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

Future <String> getDeviceToken() async {
    String fcmToken = await firebaseMessaging.getToken();

    if (fcmToken != null) {
      print("token: $fcmToken");
      await storage.write(key:'fcmToken',value:fcmToken);
      return fcmToken;
    }
  }

class _User {
  String status;
  String jwt_token;
  String user_id;
  String room_id;
  bool is_admin;

  _User({this.status, this.jwt_token, this.user_id, this.room_id, this.is_admin});

  factory _User.fromJson(Map<String, dynamic> parsedJson) {
    return _User(
      status: parsedJson['status'],
      jwt_token: parsedJson['jwt_token'],
      user_id: parsedJson['user_id'],
      room_id: parsedJson['room_id'],
      is_admin: parsedJson['is_admin'],
    );
  }
}

class LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  String username;
  String password;

  Future<_User> _login(String userUsername, String userPassword) async {

    // set up POST request arguments
    String url = 'http://localhost:5000/api/v1/users/login';
    Map<String, String> headers = {"Content-type": "application/json"};

    // var fcmToken = await getDeviceToken();
    var fcmToken = "qweqwe";
    
    String json = '{"username": "$userUsername", "password": "$userPassword", "android_token": "$fcmToken"}';
    // print(json);
    // make POST request

    http.Response response = await http.post(url, headers: headers, body: json);
    print(json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // print(response);
    // print(statusCode);   //200
    // this API passes back the id of the new item added to the body
    String body = response.body;

    final jsonResponse = jsonDecode(response.body);
    _User user = new _User.fromJson(jsonResponse);
    // print(user.status);
    // print(user.jwt_token);

    if (user.status == "success") {
      //Snackbar
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successful!')));
      // Scaffold.of(context)
      //     .showSnackBar(SnackBar(content: Text('Login Successful!')));
      //Shared Preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id',user.user_id);
      prefs.setString('user_room_id',user.room_id);
      prefs.setBool('user_is_admin',user.is_admin);
      //Secured Storage
      await storage.write(key:'jwt',value:user.jwt_token);

      // print(user.user_id);
      // print(user.room_id);
      // print(user.is_admin);

      return user;
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Login Failed!')));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Form(
                key: _formkey,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 50.0),
                              child: Text('Login',
                                  style: PageTitle,
                                  textAlign: TextAlign.center)),
                          Text('Username', style: NormalFont),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFF96861)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15.0),
                                  )),
                              autofocus: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter your username';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                username = value;
                              },
                            ),
                          ),
                          Text('Password', style: NormalFont),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFF73D99)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15.0),
                                  )),
                              autofocus: false,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter your password';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                password = value;
                              },
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 30.0, 0.0, 30.0),
                              margin:
                                  EdgeInsets.fromLTRB(120.0, 0.0, 120.0, 0.0),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                color: Color(0xFFF96861),
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(content: Text('Logging In')));
                                    _formkey.currentState.save();
                                    var user =
                                        await _login(username, password);
                                    if (user.room_id!=null) {
                                      await new Future.delayed(
                                          const Duration(seconds: 1));
                                      Navigator.pushNamed(
                                          context, HomeRoute);
                                    }
                                    else{
                                      await new Future.delayed(
                                          const Duration(seconds: 1));
                                      Navigator.pushNamed(
                                          context, GetStartedRoute);
                                    }
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0)),
                                child: Text('Login',
                                    textAlign: TextAlign.center,
                                    style: BtnText),
                              )),
                          Container(
                              margin:
                                  EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 50.0),
                              child: RaisedButton(
                                color: Color(0xFF61C6C0),
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(content: Text('Logging In')));
                                    _formkey.currentState.save();

                                    var user =
                                        await _login(username, password);
                                    if (user.room_id != null) {
                                      await new Future.delayed(
                                          const Duration(seconds: 3));
                                      Navigator.pushNamed(
                                          context, HomeRoute);
                                    }
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0)),
                                padding: EdgeInsets.all(15.0),
                                child: Text('Login with Google',
                                    textAlign: TextAlign.center,
                                    style: BtnText),
                              )),
                          Container(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, SignUpRoute);
                              // print("are you working?");
                            },
                            child: Text("Don't have an account? Sign Up now!",
                                textAlign: TextAlign.center),
                          ))
                        ])))));
  }
}