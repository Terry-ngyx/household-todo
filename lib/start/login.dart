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
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 50.0),
                child: Text('Login', style:PageTitle, textAlign:TextAlign.center)
              ),
              Text('Username',style:NormalFont),
              SizedBox(height: 20.0,),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF96861)
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white
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
              Text('Password',style:NormalFont),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF73D99)
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white
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
              Container(
                padding: const EdgeInsets.fromLTRB(0.0,30.0,0.0,30.0),
                margin: EdgeInsets.fromLTRB(120.0,0.0,120.0,0.0),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical:20.0),
                  color: Color(0xFFF96861),
                  onPressed: () {
                    if (_formkey.currentState.validate()){
                      Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                        _formkey.currentState.save();
                        print(username);
                        print(password);
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                  child: Text('Login', textAlign: TextAlign.center,style:BtnText),
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 50.0),
                child: RaisedButton(
                  color: Color(0xFF61C6C0),
                  onPressed: () {
                    Navigator.pushNamed(context,LoginRoute);
                  },
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(15.0),
                  child: Text('Login with Google', textAlign: TextAlign.center, style: BtnText),
                ) 
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context,SignUpRoute);
                  },
                  child: Text("Don't have an account? Sign Up now!", textAlign: TextAlign.center),
                )
              )
            ]
          )
        )
      )
      )
    );
  }
}