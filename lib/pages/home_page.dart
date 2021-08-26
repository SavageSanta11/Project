import 'dart:convert';
import 'package:project/widgets/commentWidget.dart';
import '../widgets/carousel/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../widgets/polldata_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

List<dynamic> polls = [];

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

// ignore: non_constant_identifier_names
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

// ignore: non_constant_identifier_names
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

// ignore: non_constant_identifier_names
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
  // ignore: unused_field
  int _currentIndex = 0;
  bool center = false;
  bool pollsLoaded = false;

  bool onViewcomment = false;

  // ignore: non_constant_identifier_names
  void updateViewcomment(bool Viewcomment) {
    setState(() {
      onViewcomment = Viewcomment;
    });
  }

  Future<void> getPollRecommendations(
      // ignore: non_constant_identifier_names
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

  Widget selectedCard = Text("data");

  Widget build(BuildContext context) {
    Material _buildDesktopView(double width, double height) {
      if (onViewcomment) {
        // return the card + comment view
        return Material(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                              borderRadius: new BorderRadius.circular(20.0)),
                          primary: Color(0xff092836),
                        ),
                        onPressed: () {},
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: width * 0.25,
                      height: height * 0.8,
                      child: selectedCard),
                  Container(
                      width: width * 0.40,
                      height: height * 0.8,
                      child: Comments())
                ],
              ),
            ),
          ],
        ));
      } else {
        // return the carousel view
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
                                      color: Color(0xff092836),
                                      fontSize: 20.0))),
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
                            optionsLength: polls[itemIndex]['poll_data']['answers']['options'],
                            options: polls[itemIndex]['poll_data']['answers'],
                            previewUrl: polls[itemIndex]['poll_data']
                                ['previewUrl'],
                            pollTitle: 'This is the poll title',
                            onViewcomment: (bool viewComment) {
                              setState(() {
                                print(polls[itemIndex]['poll_data']['answers']['option_1']);
                                onViewcomment = viewComment;
                                selectedCard = polldata_widget(
                                    username: polls[itemIndex]['poll_user'],
                                    question: polls[itemIndex]['poll_data']
                                        ['question'],
                                    votes: 13,
                                    time: 13,
                                    optionsLength: polls[itemIndex]['poll_data']['answers']['options'],
                                    options: polls[itemIndex]['poll_data']['answers'],
                                    previewUrl: polls[itemIndex]['poll_data']
                                        ['previewUrl'],
                                    pollTitle: 'pollTitle',
                                    onViewcomment: updateViewcomment);
                              });
                            },
                          ),
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
    }

    Widget _buildMobileView(double width, double height) {
      if (onViewcomment) {
        //return card + comment section
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
          body: ListView(
            children: [
              Container(
                  width: width * 0.94,
                  height: height * 0.8,
                  child: selectedCard),
              Container(
                  width: width * 0.94, height: height * 0.8, child: Comments())
            ],
          ),
        );
      } else {
        return pollsLoaded
            ? Scaffold(
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
                    CarouselSlider.builder(
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: height * 0.85,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.85,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
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
                          optionsLength: polls[itemIndex]['poll_data']['answers']['options'],
                          options: polls[itemIndex]['poll_data']['answers'],
                          previewUrl:
                              'http://qonway.com:8089/api/v1/media/content/unym4ir.png',
                          pollTitle: 'This is the poll title',
                          onViewcomment: (bool viewComment) {
                            setState(() {
                              
                              onViewcomment = viewComment;
                              selectedCard = polldata_widget(
                                  username: polls[itemIndex]['poll_user'],
                                  question: polls[itemIndex]['poll_data']
                                      ['question'],
                                  votes: 13,
                                  time: 13,
                                  optionsLength: polls[itemIndex]['poll_data']['answers']['options'],
                                  options: polls[itemIndex]['poll_data']['answers'],
                                  previewUrl: polls[itemIndex]['poll_data']
                                      ['previewUrl'],
                                  pollTitle: 'pollTitle',
                                  onViewcomment: updateViewcomment);
                            });
                          },
                        ),
                        onTap: () {
                          _controller.nextPage();
                        },
                      ),
                    ),
                  ],
                ))
            : Material();
      }
      
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
