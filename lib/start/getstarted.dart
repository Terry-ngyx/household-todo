import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main.dart';
import '../style.dart';

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

class JoinRoomFormState extends State<JoinRoomForm> {
  final _formkey = GlobalKey<FormState>();
  String roomId;
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
                                Navigator.pushNamed(context, GetStartedRoute);
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
                      Navigator.pushNamed(context, GetStartedRoute);
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
