import 'package:flutter/material.dart';
import '../main.dart';
import '../style.dart';
import '../appbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, 
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
            ReusableWidgets.roomBanner("ROOM ID"),
            Container(
              margin: EdgeInsets.symmetric(horizontal:20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  //Members
                  Container(
                    height: 150.0,
                    margin: EdgeInsets.only(bottom:20.0),
                    padding: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Members",textAlign: TextAlign.center,style:TitleText),
                          Row(children: <Widget>[
                            //PENDING: NEED TO ADD MEMBER COLOR & MEMBER USERNAME
                          ])
                        ],)
                    )
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[ 
                      //Profile
                      Container(
                        margin: EdgeInsets.only(bottom:20.0),
                        height: 170.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFFF96861)),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: Text('Profile',textAlign: TextAlign.center,style: TitleText)
                        )
                      ), 
                      //To do
                      Container(
                        margin: EdgeInsets.only(bottom:20.0),
                        height: 170.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFFBDCC11)),
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Center(
                          child: Text('To Do',textAlign: TextAlign.center,style: TitleText)
                        )
                      ),
                    ]
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[  
                      //Assign to me
                      Container(
                        margin: EdgeInsets.only(bottom:20.0),
                        height: 170.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFF61C6C0)),
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Center(
                          child: Text('Assign to Me',textAlign: TextAlign.center,style: TitleText)
                        )
                      ),  
                      //Schedule
                      Container(
                        margin: EdgeInsets.only(bottom:20.0),
                        height: 170.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          border: Border.all(width:3.0,color: Color(0xFFF73D99)),
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Center(
                          child: Text('Schedule',textAlign: TextAlign.center,style: TitleText)
                        )
                      ),
                    ]
                  ),

                  //Due Today
                  Container(
                    height: 125.0,
                    margin: EdgeInsets.only(bottom:20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        Text("Due Today :",textAlign: TextAlign.left,style:TitleText),
                        Container(
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.white),
                          //   borderRadius: BorderRadius.circular(15.0)
                          // ),
                          height: 73.0,
                          child: Center(
                            child: Text("Task/Schedule due by today", textAlign: TextAlign.center,style:MutedText)
                            //PENDING: NEED TO ADD IF ELSE STATEMENT SO IF THERE IS SOMETHING TO BE COMPLETED BY TODAY IT SHOWS UP HERE!
                          )
                        )
                      ],)
                    )
                  ),

                ]
              )
            )
          ] 
        )
      )
    );
  }
}

