import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_location/flutter_background_location.dart';
import 'package:household/widgets/message.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

import 'dart:async';
import 'dart:convert';

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
import 'places_search_map.dart';

const Home = '/welcome';
const LoginRoute = '/login';
const SignUpRoute = '/signup';
const HomeRoute = '/home';
const GetStartedRoute = '/getstarted';
const TodoRoute = '/todo';
const ProfileRoute = '/profile';
const ProfileEditRoute = '/profileedit';
const ScheduleRoute = '/schedule';
const MapRoute = '/map';

void main() => runApp(MyApp());

final storage = FlutterSecureStorage();
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  // This widget is the root of your application.
}

class _MyAppState extends State<MyApp> {
  Timer _timer;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    print("hello");

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (message['data'].title ==
            "There's a grocery shop nearby! Do your work!") {
          print("Got Message");
          stopTimer();
        }
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(notification['title'], notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        if (message['data'].title ==
            "There's a grocery shop nearby! Do your work!") {
          print("Got Message");
          stopTimer();
        }
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(notification['title'], notification['body']));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        if (message['data'].title ==
            "There's a grocery shop nearby! Do your work!") {
          print("Got Message");
          stopTimer();
        }
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(notification['title'], notification['body']));
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

  getCurrentLocation() async {
    FlutterBackgroundLocation().getCurrentLocation().then((location) async {
      print("This is current Location " +
          location.longitude.toString() +
          " " +
          location.latitude.toString());
      String token = await storage.read(key: 'jwt');
      String url = 'http://10.0.2.2:5000/api/v1/users/geolocation';
      String json = '{"latitude": "${location.latitude}", "longitude": "${location.longitude}"}';
      http.Response response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization':'Bearer $token'
        },
        body: json
      );
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chores of Duty',
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
      home: SplashScreen(),
      // initialRoute: Home,
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
      case MapRoute:
        return MaterialPageRoute(builder: (_) => ShowMap());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
    }
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed("/welcome");
  }

  @override
  void initState() {
    super.initState();
    print("Splash Screen trii");
    startTime();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xFFABC8FE)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: Icon(
                          Icons.accessibility_new,
                          color: Color(0xFF234875),
                          size: 90.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text(
                        "Don't say I Bo-Chore",
                        style: SplashScreenText
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF234875)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0,20.0,0,20.0),
                    ),
                    Text("Git your chores done !", textAlign: TextAlign.center, style: SplashScreenSmallText,)
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
