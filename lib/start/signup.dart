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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          child: Text('Sign Up',
                              style: PageTitle, textAlign: TextAlign.center)),
                      Column(
                        children: <Widget>[
                          Text('Username', style: NormalFont),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 3.0))),
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
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text('Email', style: NormalFont),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 3.0))),
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
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text('Password', style: NormalFont),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                            child: TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 3.0))),
                              autofocus: false,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter your password';
                                } else if (value != confirmPasswordController.text) {
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
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text('Confirm Password', style: NormalFont),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                            child: TextFormField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 3.0))),
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
                        ],
                      ),
                      Container(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                          margin: EdgeInsets.fromLTRB(120.0, 10.0, 120.0, 10.0),
                          child: RaisedButton(
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Processing Data')));
                                _formkey.currentState.save();
                                // print(email);
                                // print(username);
                                // print(password);
                                // print(confirmPassword);
                              }
                            },
                            child: Text(
                              'Submit',
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ]))));
  }
}
