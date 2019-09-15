import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:household/start/getstarted.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../style.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor, body: LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class _User {
  String status;
  String jwt_token;

  _User({this.status, this.jwt_token});

  factory _User.fromJson(Map<String, dynamic> parsedJson) {
    return _User(
      status: parsedJson['status'],
      jwt_token: parsedJson['jwt_token'],
    );
  }
}

class LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  String username;
  String password;

  Future<bool> _login(String userUsername, String userPassword) async {
    // set up POST request arguments
    String url = 'http://10.0.2.2:5000/api/v1/users/login';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"username": "$userUsername", "password": "$userPassword"}';
    // print(json);
    // make POST request
    http.Response response = await http.post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // print(statusCode);
    // this API passes back the id of the new item added to the body
    String body = response.body;

    final jsonResponse = jsonDecode(response.body);
    _User user = new _User.fromJson(jsonResponse);
    // print(user.status);
    // print(user.jwt_token);
    if (user.status == "success") {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successful!')));

      // Scaffold.of(context)
      //     .showSnackBar(SnackBar(content: Text('Login Successful!')));
      return true;
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Login Failed!')));
    }

    final storage = new FlutterSecureStorage();
    await storage.write(key: 'jwt', value: user.jwt_token);
    print(await storage.read(key: 'jwt'));
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

                                    var value =
                                        await _login(username, password);
                                    if (value) {
                                      await new Future.delayed(
                                          const Duration(seconds: 3));
                                      Navigator.pushNamed(
                                          context, GetStartedRoute);
                                    }
                                    // if (_login(username, password)) {
                                    // print(username);
                                    // print(password);
                                    //   Navigator.pushNamed(
                                    //       context, GetStartedRoute);
                                    // }
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
                                onPressed: () {
                                  Navigator.pushNamed(context, LoginRoute);
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
                              print("are you working?");
                            },
                            child: Text("Don't have an account? Sign Up now!",
                                textAlign: TextAlign.center),
                          ))
                        ])))));
  }
}
