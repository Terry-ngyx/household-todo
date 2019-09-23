import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main.dart';
import '../style.dart';

class ImageBanner extends StatelessWidget {
  final String _assetPath;

  ImageBanner(this._assetPath);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0,50.0,10.0,50.0),
      constraints: BoxConstraints.expand(height:300.0,width:300.0),
      child: SvgPicture.asset(
        _assetPath,
        fit: BoxFit.fill,
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
              ImageBanner('assets/images/logo.svg'),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 15.0),
                      child: RaisedButton(
                        color: Color(0xFFF96871),
                        onPressed: () {
                          Navigator.pushNamed(context,SignUpRoute);
                        },
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                        padding: EdgeInsets.all(15.0),
                        child: Text('Sign Up', textAlign: TextAlign.center, style: BtnText),
                      ) 
                    ),
                    Container(
                      width: 150.0,
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 15.0),
                      child: RaisedButton(
                        color: Color(0xFFF73D99),
                        onPressed: () {
                          Navigator.pushNamed(context,LoginRoute);
                        },
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                        padding: EdgeInsets.all(15.0),
                        child: Text('Login', textAlign: TextAlign.center, style: BtnText),
                      ) 
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.fromLTRB(110.0, 0.0, 110.0, 0.0),
              //   child: RaisedButton(
              //     color: Color(0xFF61C6C0),
              //     onPressed: () {
              //       Navigator.pushNamed(context,LoginRoute);
              //     },
              //     shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('Login with Google', textAlign: TextAlign.center, style: BtnText),
              //   ) 
              // ),
            ]
          )
        )
      )
    );
  }
}

