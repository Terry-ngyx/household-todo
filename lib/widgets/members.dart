import 'package:flutter/material.dart';
import '../style.dart';

class Members extends StatelessWidget{
  String member;
  String color;

  Members({this.member,this.color});

  @override
  Widget build(BuildContext context){
    return Row(
      children: <Widget>[
        
        Container(
          child: Column(children: <Widget>[
            Center(
              child: Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF96861),
                  shape: BoxShape.circle
                )
              )
            ),
            Text(member,textAlign:TextAlign.center,style: MemberNames)
          ],)
        ),

      ],
    );
  }
}
