import 'package:flutter/material.dart';
import '../style.dart';
import '../main.dart';

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(    
      backgroundColor: Theme.of(context).backgroundColor, 
      body: LoginForm()
    );
  }
}

class LoginForm extends StatefulWidget{
  @override
  LoginFormState createState(){
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm>{
  final _formkey = GlobalKey<FormState>();
  String username;
  String password;

  @override
  Widget build(BuildContext context){
    return Center(
      child: SingleChildScrollView(
        child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Text('Login', style:PageTitle, textAlign:TextAlign.center)
            ),
            Column(
              children: <Widget>[
                Text('Username',style:NormalFont),
                SizedBox(height: 20.0,),
                Container(
                  margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue, width: 3.0
                        )
                      )
                    ),
                    autofocus: true,
                    validator: (value) {
                      if (value.isEmpty){
                        return 'please enter your username';
                      }
                      return null;
                    },
                    onSaved: (String value){
                      username = value;
                    },
                  ),
                ),
              ]
            ),
            Column(
              children: <Widget>[
                Text('Password',style:NormalFont),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue, width: 3.0
                        )
                      )
                    ),
                    autofocus: false,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty){
                        return 'please enter your password';
                      }
                      return null;
                    },
                    onSaved: (String value){
                      password = value;
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0.0,30.0,0.0,30.0),
              margin: EdgeInsets.fromLTRB(120.0,10.0,120.0,10.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formkey.currentState.validate()){
                    Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                      _formkey.currentState.save();
                      print(username);
                      print(password);
                  }
                },
                child: Text('Submit', textAlign: TextAlign.center,),
              )
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context,SignUpRoute);
                  print("are you working");
                },
                child: Text("Don't have an account? Sign Up now!", textAlign: TextAlign.center),
              )
            )
          ]
        )
      )
      )
    );
  }
}