import 'package:flutter/material.dart';
import '../appbar.dart';
import '../main.dart';
import '../style.dart';

class ImageBanner extends StatelessWidget {
  final String _assetPath;

  ImageBanner(this._assetPath);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height:250.0,width:250.0),
      child: Image.asset(
        _assetPath,
        fit: BoxFit.contain,
      ));
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, 
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(      
                child: Text('Welcome to Household', style: WelcomeTitle, textAlign: TextAlign.center,),
              ),
              ImageBanner("assets/images/logo.png"),
              Container(
                margin: EdgeInsets.fromLTRB(70.0,50.0,70.0,15.0),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context,LoginRoute);
                  },
                  padding: EdgeInsets.all(15.0),
                  child: Text('Login | Sign Up', textAlign: TextAlign.center, style: BtnText),
                ) 
              ),
            ]
          )
        )
      )
    );
  }
}