import 'package:flutter/material.dart';
import '../style.dart';

class PersonalTasks extends StatelessWidget {
  String task;
  // String task_id;
  bool completed;
  PersonalTasks(this.task, this.completed);
 

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 100.0,
        width: 500.0,
        margin: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),

          color: completed ? Color(0xFF848484) : Color(0xFF61C6C0),
          child: Text(task, 
          style:completed? DoneMutedText : MutedText, 
          textAlign: TextAlign.left),
        // )
        );
  }
}

class GroupCategory extends StatelessWidget {
  String category;
  bool completedPublic;
  GroupCategory(this.category, this.completedPublic);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500.0,
      margin: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 4.0),
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),
      decoration: BoxDecoration(
        color: completedPublic ? Color(0xFF848484) : Color(0xFFB2C214),
      ),
      child: Text(category, 
      style: completedPublic ?DoneMutedText : MutedText, 
      textAlign: TextAlign.left),
    );
  }
}

//PENDING: ADD CONTAINER FOR TODOLIST ITEMS IN GROUP CATEGORIES