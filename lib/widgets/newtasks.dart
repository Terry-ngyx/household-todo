// import 'package:flutter/material.dart';
// // import 'package:household/widgets/tasks.dart';
// import '../style.dart';



// // class Personal extends StatelessWidget{
// //   @override
// //   Widget build(BuildContext context){
// //   return Scaffold(
// //     body:PersonalTasks(task)
// //   );

// //   }
// // }

// class PersonalTask extends StatefulWidget{
//   @override
//   PersonalTaskState createState() => PersonalTaskState();
// }

// class PersonalTaskState extends State<PersonalTask> {
//   String task;
//   PersonalTasks(this.task);
//   bool pressed = false;
//   @override
//   Widget build(BuildContext context){
//     return Container(
//         height: 70.0,
//         margin: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
//         padding: EdgeInsets.fromLTRB(10.0, 12.0, 0.0, 10.0),
//         // decoration: BoxDecoration(
//         //   color: Colors.transparent,
//         // ),
//         child: RaisedButton(
//           color: Color(0xFF61C6C0),
//           child: Text(task, 
//           style: pressed ? MutedText : DoneMutedText, 
//           textAlign: TextAlign.left),
//           onPressed:(){
//             setState((){
//               pressed = !pressed;
//             });
//             // Text(task, style: DoneMutedText, textAlign: TextAlign.left);
//             // TextStyle(decoration: TextDecoration.lineThrough);
//             },
//         ));
//   }

// }