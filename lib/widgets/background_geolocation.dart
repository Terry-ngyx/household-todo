// import 'package:flutter/material.dart';
// import 'package:flutter_background_location/flutter_background_location.dart';
// import '../main.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';


// class Geolocation extends StatefulWidget {
//   @override
//   _GeolocationState createState() => _GeolocationState();
// }

// class _GeolocationState extends State<Geolocation> {

//   @override
//   void initState() {
//     super.initState();
//     FlutterBackgroundLocation.startLocationService();
//     Timer.periodic(Duration(seconds: 10), (timer) {
//       getCurrentLocation();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return null;
//   }

//   getCurrentLocation() async {
//     String token = await storage.read(key: 'jwt');
//     String url = 'http://192.168.1.21:5000/api/v1/users/geolocation';

//     FlutterBackgroundLocation().getCurrentLocation().then((location) async {
//       print("This is current Location " + location.longitude.toString() + " " + location.latitude.toString());
//       String json = '{"latitude":"${location.latitude.toString()}","longitude":"${location.longitude.toString()}"}';
//       http.Response response = await http.post(
//         url,
//         headers: {
//           'Content-type':'application/json',
//           'Authorization': 'Bearer $token'
//         },
//         body: json,
//       );
//       final jsonResponse = jsonDecode(response.body);
//     });
//   }

//   @override
//   void dispose() {
//     FlutterBackgroundLocation.stopLocationService();
//     super.dispose();
//   }
// }



