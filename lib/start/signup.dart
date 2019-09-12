import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class _SigninFormState extends State<SigninForm> {
  final _formkey = GlobalKey<FormState>();
  String username;
  String email;
  String password;
  String confirmPassword;

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
                                        BorderSide(color: Color(0xFFF96861))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                              ),
                              autofocus: true,
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
                                        BorderSide(color: Color(0xFFF73D99))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
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
                                        BorderSide(color: Color(0xFF61C6C0))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
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
                                        BorderSide(color: Color(0xFFBDCC11))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
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
                                    // print(email);
                                    // print(userVname);
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
