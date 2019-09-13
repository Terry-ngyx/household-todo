import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../main.dart';
import '../style.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SigninForm(),
    );
  }
}

class SigninForm extends StatefulWidget {
  @override
  _SigninFormState createState() => _SigninFormState();
}

class User {
  String status;

  User({this.status});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      status: parsedJson['status'],
    );
  }
}

class _SigninFormState extends State<SigninForm> {
  final _formkey = GlobalKey<FormState>();
  String username;
  String email;
  String password;
  String confirmPassword;

  _signup(String userName, String userUsername, String userEmail,
      String userPassword, String userConfirmPassword) async {
    // set up POST request arguments
    String url = 'http://10.0.2.2:5000/api/v1/users/signup';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"name": "$userName", "username": "$userUsername", "email": "$userEmail", "password": "$userPassword", "confirmed_password": "$userConfirmPassword"}';
    print(json);
    // make POST request
    http.Response response = await http.post(url, headers: headers, body: json);
    print(response);
    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
    // this API passes back the id of the new item added to the body

    final jsonResponse = jsonDecode(response.body);
    User user = new User.fromJson(jsonResponse);
    print(user.status);

    // if (body[status]==){
    // }
    // {
    //   "title": "Hello",
    //   "body": "body text",
    //   "userId": 1,
    //   "id": 101
    // }
  }

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
                              margin: EdgeInsets.only(top: 10.0, bottom: 40.0),
                              child: Text('Sign Up',
                                  style: PageTitle,
                                  textAlign: TextAlign.center)),
                          Text('Username', style: NormalFont),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFF96861)),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                              autofocus: false,
                              obscureText: false,
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
                          Text('Email', style: NormalFont),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
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
                                ),
                              ),
                              autofocus: false,
                              obscureText: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter your email';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                email = value;
                              },
                            ),
                          ),
                          Text('Password', style: NormalFont),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                            child: TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF61C6C0)),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              autofocus: false,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter your password';
                                } else if (value !=
                                    confirmPasswordController.text) {
                                  // print(passwordController.text);
                                  return 'please check if password matches';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String value) {
                                password = value;
                              },
                            ),
                          ),
                          Text('Confirm Password', style: NormalFont),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                            child: TextFormField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFBDCC11)),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              autofocus: false,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please repeat your password';
                                } else if (value != passwordController.text) {
                                  // print(passwordController.text);
                                  return 'please check if password matches';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String value) {
                                confirmPassword = value;
                              },
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 30.0, 0.0, 30.0),
                              margin: EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),
                              child: RaisedButton(
                                color: Color(0xFFF96861),
                                onPressed: () {
                                  if (_formkey.currentState.validate()) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text('Processing Data')));
                                    _formkey.currentState.save();
                                    print(username + email + password);
                                    _signup("Terry", username, email, password,
                                        confirmPassword);
                                    // print(email);
                                    // print(username);
                                    // print(password);
                                    // print(confirmPassword);
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0)),
                                child: Text('Submit',
                                    textAlign: TextAlign.center,
                                    style: BtnText),
                              )),
                          Container(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, LoginRoute);
                            },
                            child: Text("Already have an account? Login now!",
                                textAlign: TextAlign.center),
                          ))
                        ])))));
  }
}
