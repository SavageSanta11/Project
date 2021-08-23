import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../widgets/polldata_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

Future<void> recordComment() async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTQzMjE5MSwianRpIjoiZTQzYjMyYmQtOGNlNS00ODU4LWFjNjQtOGJlNzBjMGI0MTY5IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTQzMjE5MSwiZXhwIjoxNjI5NDMzMDkxfQ.mMHDB_oBSxnjGK8MYXRGrVw9yV-pajJ8YOi5LLbxdII',
    'Content-Type': 'application/json'
  };
  String body = json.encode(
      <String, String>{"poll_id": "yjhhonw", "text": "Hi, what's your name?"});

  http.Response response = await http.post(
      Uri.parse('http://164.52.212.151:3012/api/access/record/comment'),
      headers: headers,
      body: body);

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

Future<void> recordVote() async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTQzMjgwMSwianRpIjoiNjhlNmU0OGUtNmFmNS00ZDhlLTgzMTItMDdiODgzMjRhM2Y1IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTQzMjgwMSwiZXhwIjoxNjI5NDMzNzAxfQ.9-RgnOEkhbA28A22h_tu_6J_syc2YqHYR9rQ1M1NVYE',
    'Content-Type': 'application/json'
  };
  String body = json.encode(<String, dynamic>{
    "poll_id": "yjhhonw",
    "opt_num": 1,
    "opt_text": "Delhi Metro"
  });

  http.Response response = await http.post(
      Uri.parse('http://164.52.212.151:3012/api/access/record/vote'),
      headers: headers,
      body: body);

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

Future<void> pushUserToWaitlist() async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTQzMjgwMSwianRpIjoiNjhlNmU0OGUtNmFmNS00ZDhlLTgzMTItMDdiODgzMjRhM2Y1IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTQzMjgwMSwiZXhwIjoxNjI5NDMzNzAxfQ.9-RgnOEkhbA28A22h_tu_6J_syc2YqHYR9rQ1M1NVYE',
    'Content-Type': 'application/json'
  };
  String body = json.encode(
      <String, dynamic>{"user": "jellyboom@gmail.com", "location": "Seoul"});

  http.Response response = await http.post(
      Uri.parse('http://164.52.212.151:3012/api/access/waitlist'),
      headers: headers,
      body: body);

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

Future<void> publishPoll(String poll_id) async {
  String uri =
      'http://164.52.212.151:3012/api/access/poll/publish?poll_id=' + poll_id;

  http.Response response = await http.get(
    Uri.parse(uri),
  );

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

Future<void> getPollRecommendations(String poll_id, int count, int skip) async {
  String uri =
      'http://164.52.212.151:3012/api/access/poll/recommendations?poll_id=' +
          poll_id +
          '&count=' +
          count.toString() +
          '&skip=' +
          skip.toString();

  http.Response response = await http.get(
    Uri.parse(uri),
  );

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

Future<void> showComments(String poll_id, int skip, int pageSize) async {
  String uri = 'http://164.52.212.151:3012/api/access/show/comments?poll_id=' +
      poll_id +
      '&skip=' +
      skip.toString() +
      '&pageSize=' +
      pageSize.toString();

  http.Response response = await http.get(
    Uri.parse(uri),
  );

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

Future<void> showUserComments(String poll_id, String email) async {
  String uri = 'http://164.52.212.151:3012/api/access/show/comments?poll_id=' +
      poll_id +
      '&email=' +
      email;

  http.Response response = await http.get(
    Uri.parse(uri),
  );

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

Future<void> getPollResult(String poll_id) async {
  String uri =
      'http://164.52.212.151:3012/api/access/poll/result?poll_id=' + poll_id;

  http.Response response = await http.get(
    Uri.parse(uri),
  );

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

// ignore: camel_case_types
class HomePage extends StatefulWidget {
  static const String route = 'HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

// ignore: camel_case_types
class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  int _currentIndex = 0;
  bool currentPage = false;

  List cardList = [polldata_widget()];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Material _buildDesktopView(double width, double height) {
      return Material(
        child: (Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        size: 40,
                      ),
                      color: Color(0xff092836),
                      onPressed: () {},
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      'Q O N W A Y',
                      style: GoogleFonts.lato(
                          color: Color(0xff092836),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40.0,
                    width: 170.0,
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.mic_external_on,
                        size: 25,
                      ),
                      label: Text(
                        'CREATE POLL',
                        style: GoogleFonts.lato(
                          fontSize: 16.0,
                          color: Color(0xffedf0f3),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        primary: Color(0xff092836),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: height * 0.9,
                 
                  viewportFraction: 0.35,
                  enableInfiniteScroll: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: cardList.map((card) {
                  return Builder(builder: (BuildContext context) {
                    return Container(
                      width: width * 0.27,
                      child: card,
                    );
                  });
                }).toList(),
              ),
            ),
          ],
        )),
      );
    }

    Scaffold _buildMobileView(double width, double height) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              'QONWAY',
              style: GoogleFonts.lato(color: Colors.black),
            ),
            backgroundColor: Color(0xffedf0f3),
            leading: GestureDetector(
              onTap: () {/* Write listener code here */},
              child: Icon(
                Icons.menu,
                color: Color(0xff092836), // add custom icons also
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  height: height * 0.85,
                  viewportFraction: 0.85,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: cardList.map((card) {
                  return Builder(builder: (BuildContext context) {
                    return Container(
                      width: width * 0.95,
                      // height: height*0.8,
                      child: card,
                    );
                  });
                }).toList(),
              ),
            ],
          ));
    }

    Widget carousel;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
      carousel = _buildDesktopView(width, height);
    } else {
      carousel = _buildMobileView(width, height);
    }

    return Container(
        width: width,
        height: height,
        color: Color(0xffedf0f3),
        child: carousel);
  }
}
