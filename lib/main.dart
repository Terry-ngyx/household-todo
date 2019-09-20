import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_location/flutter_background_location.dart';
import 'package:household/widgets/message.dart';

import 'dart:async';

import 'style.dart';
import 'start/welcome.dart';
import 'start/signup.dart';
import 'start/login.dart';
import 'start/getstarted.dart';
import 'session/homepage.dart';
import 'session/todo.dart';
import 'session/profile.dart';
import 'session/profileedit.dart';
import 'session/schedulepage.dart';

const Home = '/';
const LoginRoute = '/login';
const SignUpRoute = '/signup';
const HomeRoute = '/home';
const GetStartedRoute = '/getstarted';
const TodoRoute = '/todo';
const ProfileRoute = '/profile';
const ProfileEditRoute = '/profileedit';
const TestRoute = '/test';
const ScheduleRoute = '/schedule';

void main() => runApp(MyApp());

final storage = FlutterSecureStorage();
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  // This widget is the root of your application.
}

class _MyAppState extends State<MyApp>{

  Timer _timer;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    print("hello");
    
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (message['data'].title == "There's a grocery shop nearby! Do your work!"){
          print("Got Message");
          stopTimer();
        }
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              notification['title'], notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        if (message['data'].title == "There's a grocery shop nearby! Do your work!"){
          print("Got Message");
          stopTimer();
        }
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              notification['title'], notification['body']));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        if (message['data'].title == "There's a grocery shop nearby! Do your work!"){
          print("Got Message");
          stopTimer();
        }
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              notification['title'], notification['body']));
        });
      },
    );
    FlutterBackgroundLocation.startLocationService();
    startTimer();
    print("still working?");
  }

  void startTimer() {
    setState(() {  
      _timer = Timer.periodic(Duration(minutes: 15), (timer) {
        getCurrentLocation();
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
    Future.delayed(Duration(minutes: 10), () => startTimer());
  }

  getCurrentLocation() {
    FlutterBackgroundLocation().getCurrentLocation().then((location) {
      print("This is current Location " + location.longitude.toString() + " " + location.latitude.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Household',
      theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
          fontFamily: FontNameDefault,
          backgroundColor: Color(0xFF0C324E),
          primaryColor: Colors.white,
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white)),
      onGenerateRoute: Router.generateRoute,
      initialRoute: Home,
    );
  }
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home:
        return MaterialPageRoute(builder: (_) => WelcomePage());
      case LoginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case SignUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case HomeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case GetStartedRoute:
        return MaterialPageRoute(builder: (_) => GetStartedPage());
      case TodoRoute:
        return MaterialPageRoute(builder: (_) => TodoPage());
      case ProfileRoute:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case ProfileEditRoute:
        return MaterialPageRoute(builder: (_) => ProfileEditPage());
      case ScheduleRoute:
        return MaterialPageRoute(builder: (_) => SchedulePage());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
    }
  }
}
