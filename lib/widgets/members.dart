import 'package:flutter/material.dart';
import '../style.dart';

class HouseMembers extends StatelessWidget{
  String member;
  int color;

  HouseMembers(this.member,this.color);

  @override
  Widget build(BuildContext context){
    return Container(
      width: 90.0,
      child: Column(children: <Widget>[
        Center(
          child: Container(
            width: 25.0,
            height: 25.0,
            margin: EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 10.0),
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle
            )
          )
        ),
        Text(member,textAlign:TextAlign.center,style: MemberNames)
      ],)
    );
  }
}
