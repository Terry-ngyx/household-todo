import 'package:flutter/material.dart';
import 'package:flutter_background_location/flutter_background_location.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'main.dart';
import 'style.dart';
import 'widgets/appbar.dart';

class ShowMap extends StatefulWidget{
  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap>{
  static double _longitude = 0;
  static double _latitude = 0;
  List<Marker> _allMarkers = [];

  getCurrentLocation() async {
    FlutterBackgroundLocation().getCurrentLocation().then((location) async {

      String token = await storage.read(key: 'jwt');
      String url = 'https://chores-of-duty.herokuapp.com/api/v1/users/geolocation';
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
      
      List<Marker> allMarkers = [];
      if (jsonResponse["response"]["venues"].length > 0) {
        for (int i=0; i < jsonResponse["response"]["venues"].length; i++){
          double lat = jsonResponse["response"]["venues"][i]["location"]["lat"];
          double long = jsonResponse["response"]["venues"][i]["location"]["lng"];
          double distance = jsonResponse["response"]["venues"][i]["location"]["distance"]/1000;
          List<dynamic> address = jsonResponse["response"]["venues"][i]["location"]["formattedAddress"];
          allMarkers.add(Marker(
            markerId: MarkerId('myMarker_$i'),
            draggable: false,
            onTap: () {
              print(distance);
              print(address);
              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Container(
                      padding: EdgeInsets.fromLTRB(
                          0, 0, 0, 12.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Color(0xFF61C6C0)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.center,
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: Text("${jsonResponse["response"]["venues"][0]["name"]}",style: DialogTitleMint),
                          ),
                          SizedBox(
                            width: 35,
                          ),
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: Color(0xFFF96861),
                                size: 30.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    content: Container(
                      height: 380,
                      width: 500,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 100.0,
                            width: 100.0,
                            child: Icon(
                              Icons.local_grocery_store,
                              color: Color(0xFF61C6C0),
                              size: 80.0
                            )
                          ),
                          Container(
                            height: 250.0,
                            width: 300.0,
                            margin: EdgeInsets.only(top:10.0),
                            padding: EdgeInsets.symmetric(vertical: 40.0,horizontal:10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF61C6C0)),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text('Distance :',style:LocationDialog),
                                Text('$distance km',style:LocationDialogBold),
                                Text(''),
                                Container(height: 2.0),
                                Text(''),
                                Text('Address :',style:LocationDialog),
                                Expanded(
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    removeBottom: true,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: address.length,
                                      itemBuilder: (context,index){
                                        var addressLine = address[index];
                                        return Text('$addressLine',style:LocationDialogBold,textAlign:TextAlign.center);
                                      }
                                   )
                                  )
                                )
                              ],
                            )
                          )
                        ],
                      ),
                    ),
                  );
                }
              );
              print('Marker Tapped');
            },
            position: LatLng(lat,long),
          ));
        }
      }

      setState((){
        _longitude= location.longitude;
        _latitude = location.latitude;
        _allMarkers = allMarkers;
      });
      print(_longitude);
      print(_latitude);
      print(allMarkers);
      print(_allMarkers);
      print(jsonResponse["response"]["venues"].length);
    });
  }

  @override
  void initState(){
    super.initState();
    getCurrentLocation();
  }

  
  Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
    backgroundColor: Theme.of(context).backgroundColor, 
    body: Column(children: <Widget>[

      NavBar('Grocers Nearby',0xFFF28473,false),

      Container(
        height: MediaQuery.of(context).size.height-89,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_latitude,_longitude),
            zoom: 12,
          ),
          mapType: MapType.normal,
            onMapCreated: _onMapCreated,
          markers: Set.from(_allMarkers),
          myLocationEnabled: true,
        )
      )

    ],)

    );
  }

}

