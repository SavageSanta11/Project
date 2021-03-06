import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

Future<void> pushUserToWaitlist() async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTQzMjgwMSwianRpIjoiNjhlNmU0OGUtNmFmNS00ZDhlLTgzMTItMDdiODgzMjRhM2Y1IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTQzMjgwMSwiZXhwIjoxNjI5NDMzNzAxfQ.9-RgnOEkhbA28A22h_tu_6J_syc2YqHYR9rQ1M1NVYE',
    'Content-Type': 'application/json'
  };
  String body = json.encode(
      <String, dynamic>{"user": "kano@qonway.com", "location": "Seoul"});

  http.Response response = await http.post(
      Uri.parse('http://164.52.212.151:7002/api/access/waitlist'),
      headers: headers,
      body: body);

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

class WaitlistCardWidget extends StatefulWidget {
  const WaitlistCardWidget({ Key? key }) : super(key: key);

  @override
  _WaitlistCardWidgetState createState() => _WaitlistCardWidgetState();
}

class _WaitlistCardWidgetState extends State<WaitlistCardWidget> {
  @override
  Widget build(BuildContext context) {
     Container _createJoinButton(double width, double height, bool isWeb) {
      return (Container(
        width: kIsWeb ? width * 0.25 : width * 0.95,
        height: height * 0.05,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        child: ElevatedButton(
          child: Text("JOIN NOW",
              style: GoogleFonts.lato(
                fontSize: 16.0,
                color: Color(0xff092836),
              )),
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            primary: Colors.white,
          ),
          onPressed: () {
            pushUserToWaitlist();
          },
        ),
      ));
    }
    
    Container _endingCard(double width, double height, bool isWeb) {
      return Container(
        width: width*0.25,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 1],
                colors: [Color(0xff8dcdde), Colors.purple])),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Join",
                  style: GoogleFonts.lato(
                    fontSize: isWeb ? 66 : 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "the",
                  style: GoogleFonts.lato(
                    fontSize: isWeb ? 66 : 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  'waitlist',
                  style: GoogleFonts.lato(
                    fontSize: isWeb ? 66 : 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: isWeb
                    ? EdgeInsets.fromLTRB(20, 150, 20, 0)
                    : EdgeInsets.fromLTRB(5, 100, 5, 0),
                child: _createJoinButton(width, height, isWeb),
              )
            ],
          ),
        ),
      );
    }
    Widget widget;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isWeb = false;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
     
      widget = _endingCard(width, height, isWeb);
      isWeb = true;
    } else {
      widget = _endingCard(width, height, isWeb);
      isWeb = false;
    }
    return widget;
  }
}