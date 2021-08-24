import 'dart:convert';

import 'package:project/widgets/WaitlistCardWidget.dart';

import '../widgets/carousel/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../widgets/polldata_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

List<dynamic> polls = [];

List cardList = [
  polldata_widget(
    pollTitle: 'First title',
    username: 'SURESH GOPI',
    question: 'Is this bike cool?',
    votes: 13,
    time: 4,
    previewUrl:
        'https://img.etimg.com/thumb/msid-75572296,width-640,resizemode-4,imgsize-507941/bmw-ninet.jpg',
  ),
  polldata_widget(
    pollTitle: 'First title',
    username: 'RAMESH',
    question: 'Do you like this chocolate?',
    votes: 13,
    time: 4,
    previewUrl:
        'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISEBUTEhEVFRIVGRYVFxUXGBgWFRcYFxgXFhUVGhUdHCgiGh0nHRcYITEjJSkrLy4uFyAzODMsNygtLisBCgoKDg0OGxAQGzMlICUtLS0tLzUwLi8tLTItLS0tLS0tLS4tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAJUBUQMBIgACEQEDEQH/xAAbAAEAAgMBAQAAAAAAAAAAAAAABQYBAwQHAv/EAEYQAAEDAgMFAwgIAwYGAwAAAAEAAgMEEQUSIQYTMUFRImGRFTJSU3GBktEHFBYjQmKhsXKiwSQzNFST8CVDgrLh8WOD0v/EABsBAQACAwEBAAAAAAAAAAAAAAACBAEDBQYH/8QAPREAAQMCAgcDCQcDBQAAAAAAAQACEQMhBDEFEkFRYXGREyKBFFKhorHB0eHwFTIzU3KS8UKy4jRDYmOC/9oADAMBAAIRAxEAPwD3FERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERcNbicUJAkdYnUaE6e4LuVfxrWTjwHs/XmqWPxDsPR12i8gfXgttFge+Ct7dpaUm28N/4XfJd9JWRyi7HA9RwI9o4hULE2jK91hdrXOBHcLruwuS5zNdllAuDyI5g9y5NPTNWQXNBBMWsfC8K4/Bs1bFXlFH4bXiUEEZZG6PYeXQjqCpBehpvbUaHsuCue4FpgoiIpLCIvjeDqPFY3rfSHiERbEWk1LPTb4hfP1yP1jPiHzWJRdCLlNdF61nxN+a+DikA/58Xxt+aSi7UXD5Vp/Xxf6jfmnlWn9fF/qN+axrBZ1TuXci4fKtP/mIv9RvzTyrT+vi/wBRvzWdYJqncu5Fw+VYPXxfG35rPlSn9fF8bfmsawSDuXai4vKkHr4vjb81nynB6+L42/NZlIK7EXJ5Rh9dH8bfmnlGH10fxt+aSkLrRcvlGH10fxt+aeUIfWx/G35pKwupFzisi9Yz4h819CpZ6bfELKLci175vpDxCzvB1HiiL7RYWURFz1NS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',
  ),
  polldata_widget(
    pollTitle: 'First title',
    username: 'RAJESH',
    question: 'Who am I?',
    votes: 13,
    time: 4,
    previewUrl:
        'data:image/jpeg;base64,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',
  ),
  polldata_widget(
    pollTitle: 'First title',
    username: 'SANTOSH',
    question: 'Do you want to take a third shot?',
    votes: 13,
    time: 4,
    previewUrl:
        'data:image/jpeg;base64,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',
  ),
  WaitlistCardWidget()
];

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

// ignore: non_constant_identifier_names
Future<void> publishPoll(String poll_id) async {
  String uri =
      'http://164.52.212.151:3012/api/access/poll/publish?poll_id=' + poll_id;

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
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;
  bool center = false;
  bool pollsLoaded = false;

  Future<void> getPollRecommendations(
      String poll_id, int count, int skip) async {
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
    polls = convertDataToJson['data'];
    setState(() {
      pollsLoaded = true;
    });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    this.getPollRecommendations('awyluvw', 5, 5);
  }

  Widget build(BuildContext context) {
    Material _buildDesktopView(double width, double height) {
      return pollsLoaded
          ? Material(
              child: (Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60.0,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: 30,
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
                        SizedBox(
                          width: 60.0,
                        ),
                        Container(
                          width: 900.0,
                          height: 40.0,
                          child: TextField(
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  size: 30.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                fillColor: Colors.white70),
                          ),
                        ),
                        SizedBox(
                          width: 60.0,
                        ),
                        GestureDetector(
                            onTap: () {/* Write listener code here */},
                            child: Text('About Us',
                                style: GoogleFonts.lato(
                                    color: Color(0xff092836), fontSize: 20.0))),
                        SizedBox(
                          width: 20.0,
                        ),
                        SizedBox(
                            height: 40.0,
                            width: 120.0,
                            child: TextButton(
                              child: Text(
                                'SIGN UP',
                                style: GoogleFonts.lato(
                                    color: Color(0xffedf0f3), fontSize: 20.0),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                primary: Color(0xff092836),
                              ),
                              onPressed: () {},
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CarouselSlider.builder(
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: height * 0.8,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        viewportFraction: 0.35,
                        enableInfiniteScroll: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                            center = true;
                          });
                        },
                      ),
                      itemCount: polls.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          InkWell(
                        child: polldata_widget(
                            username: polls[itemIndex]['poll_user'],
                            question: polls[itemIndex]['poll_data']['question'],
                            votes: 13,
                            time: 13,
                            previewUrl: polls[itemIndex]['poll_data']
                                ['previewUrl'],
                            pollTitle: 'first'),
                        onTap: () {
                          _controller.nextPage();
                        },
                      ),
                    ),
                  ),
                ],
              )),
            )
          : Material();
    }

    Scaffold _buildMobileView(double width, double height) {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              'QONWAY',
              style: GoogleFonts.lato(color: Colors.black),
            ),
            backgroundColor: Color(0xfffafafa),
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
                    return Opacity(
                      opacity: center ? 1 : 0.5,
                      child: InkWell(
                        child: card,
                        onTap: () {
                          _controller.nextPage();
                          setState(() {
                            center = true;
                          });
                        },
                      ),
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
        color: Color(0xfffafafa),
        child: carousel);
  }
}
