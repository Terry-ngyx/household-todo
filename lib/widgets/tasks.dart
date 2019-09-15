import 'package:flutter/material.dart';
import '../style.dart';

class PersonalTasks extends StatelessWidget {
  String task;
  PersonalTasks(this.task);

  @override
  Widget build(BuildContext context){
    return Container( 
      height:50.0,
      margin: EdgeInsets.fromLTRB(10.0,3.0,10.0,3.0),
      padding: EdgeInsets.fromLTRB(60.0,8.0,0.0,8.0),
      decoration: BoxDecoration(
        color: Color(0xFFBDCC11),
      ),
      child: Text(task,
        style: MutedText, textAlign: TextAlign.center
      ),
    );
  }
}

class GroupCategory extends StatelessWidget {
  String category;
  GroupCategory(this.category);

  @override
  Widget build(BuildContext context){
    return Container( 
      height:50.0,
      margin: EdgeInsets.fromLTRB(10.0,3.0,10.0,3.0),
      padding: EdgeInsets.fromLTRB(60.0,8.0,0.0,8.0),
      decoration: BoxDecoration(
        color: Color(0xFF61C6C0),
      ),
      child: Text(category,
        style: MutedText, textAlign: TextAlign.center
      ),
    );
  }
}

//PENDING: ADD CONTAINER FOR TODOLIST ITEMS IN GROUP CATEGORIES
