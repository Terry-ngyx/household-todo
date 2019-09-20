import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../style.dart';
import '../session/homepage.dart';
import 'dart:async';
import 'dart:convert';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: JoinRoomForm());
  }
}

class JoinRoomForm extends StatefulWidget {
  @override
  JoinRoomFormState createState() {
    return JoinRoomFormState();
  }
}

class _Room {
  String status;
  String room_id;
  String room_name;

  _Room({this.status, this.room_id, this.room_name});

  factory _Room.fromJson(Map<String, dynamic> parsedJson) {
    return _Room(
      status: parsedJson['status'],
      room_id: parsedJson['room_id'],
      room_name: parsedJson['room_name'],
    );
  }
}

class JoinRoomFormState extends State<JoinRoomForm> {
  final _formkey = GlobalKey<FormState>();

  Future<String> _createRoom() async {
    String token = await storage.read(key: 'jwt');
    print(token);
    // set up POST request arguments
    String url = 'http://192.168.1.137:5000/api/v1/users/create';

    // make POST request
    http.Response response = await http.post(
      '$url',
      headers: {
        'Authorization': 'Bearer $token',
        "Content-type": "application/json"
      },
    );

    // check the status code for the result
    int statusCode = response.statusCode;

    final jsonResponse = jsonDecode(response.body);
    _Room user = new _Room.fromJson(jsonResponse);
    print(user.status);
    if (user.status == "success") {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('New Room created!')));
      await new Future.delayed(const Duration(seconds: 1));

      Navigator.pushNamed(context, HomeRoute);

      return '';
    }
  }

  Future<String> _joinRoom(String room_id) async {
    String token = await storage.read(key: 'jwt');
    // set up POST request arguments
    String url = 'http://192.168.1.137:5000/api/v1/users/join';
    // Map<String, String> headers = {
    //   "Content-type": "application/json",
    //   'Authorization': 'Bearer $token',
    // };
    String json = '{"room_id": "$room_id"}';

    // make POST request
    http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json,
    );

    print('IHIHIHI');
    // check the status code for the result
    int statusCode = response.statusCode;

    final jsonResponse = jsonDecode(response.body);
    _Room user = new _Room.fromJson(jsonResponse);

    print(user.status);
    if (user.status == "success") {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Room joined!')));
      await new Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, HomeRoute);

      return '';
    }
  }

  final roomIdController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    roomIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Center(
            child: Form(
          key: _formkey,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 30.0),
                      child: Text('Get Started !',
                          style: PageTitle, textAlign: TextAlign.center)),
                  Container(
                    height: 300.0,
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 50.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFF96861)),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 20.0),
                          child: Text(
                            'Join Existing Household',
                            style: WelcomeTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        CustomPaint(painter: Drawhorizontalline()),

                        // Expanded(child: Divider()),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                          child: TextFormField(
                            controller: roomIdController,
                            // style: TextStyle(height: 2.0),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: 'ROOM ID',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 28.0),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Color(0xFFF96861))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          ),
                        ),
                        Container(
                            width: 200,
                            margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                            child: RaisedButton(
                              color: Color(0xFFF96861),
                              onPressed: () {
                                print(roomIdController.text);
                                _joinRoom(roomIdController.text);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(15.0)),
                              padding: EdgeInsets.all(15.0),
                              child: Text('Enter Room',
                                  textAlign: TextAlign.center, style: BtnText),
                            )),
                      ],
                    ),
                  ),
                  Container(
                      child: RaisedButton(
                    color: Color(0xFF61C6C0),
                    onPressed: () {
                      _createRoom();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(15.0),
                    child: Text('New Household',
                        textAlign: TextAlign.center, style: BtnText),
                  )),
                ],
              )),
        )),
        Container(
          // padding: EdgeInsets.all(15),
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 120.0, 0.0),
          constraints: BoxConstraints.expand(height: 300.0, width: 500.0),
          child: SvgPicture.asset('assets/images/undraw_phone_call_grmk.svg'),
        )
      ],
    ));
  }
}

class Drawhorizontalline extends CustomPainter {
  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Color(0xFFF96861)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-175.0, 0.0), Offset(175.0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
