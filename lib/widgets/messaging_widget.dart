import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:household/widgets/message.dart';
import '../main.dart';


class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}


class _MessagingWidgetState extends State<MessagingWidget> {
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              notification['title'], notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            '${notification['title']}',
            '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              notification['title'], notification['body']));
        });
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}

