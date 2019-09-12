import 'package:flutter/material.dart';
import '../appbar.dart';
import '../style.dart';

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: ReusableWidgets.getAppBar('Household'),
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
  @override
  Widget build(BuildContext context){
    return Center(
        child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Text('Login', style:WelcomeTitle, textAlign:TextAlign.center)
            ),
            Text('Username',style:NormalFont),
            SizedBox(height: 20.0),
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
              ),
              validator: (value) {
                if (value.isEmpty){
                  return 'please enter some text';
                }
                return null;
              }
            ),
            Text('Password',style:NormalFont),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(
                  color: Colors.blue, width: 3.0
                ))
              ),
              autofocus: false,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty){
                  return 'please enter your password';
                }
                return null;
              }
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formkey.currentState.validate()){
                    Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
              )
            )
          ]
        )
      )
    );
  }
}