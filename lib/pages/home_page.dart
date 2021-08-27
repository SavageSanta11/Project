import 'dart:convert';
import 'package:project/widgets/commentWidget.dart';
import '../widgets/carousel/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../widgets/polldata_widget.dart';
import '../widgets/WaitlistCardWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

List<dynamic> polls = [];
String pollId = "";
int count = 1;

// ignore: non_constant_identifier_names
Future<void> showUserComments(String poll_id, String email) async {
  String uri = 'http://164.52.212.151:7002/api/access/show/comments?poll_id=' +
      poll_id +
      '&email=' +
      email;

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
  void updateViewcomment(bool Viewcomment, String poll_id) {
    setState(() {
      onViewcomment = Viewcomment;
      pollId = poll_id;
    });
  }

  Future<void> getPollRecommendations(
      // ignore: non_constant_identifier_names
      String poll_id,
      int count,
      int skip) async {
    String uri =
        'http://164.52.212.151:7002/api/access/poll/recommendations?poll_id=' +
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

    print(uri);
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
    //this.getPollRecommendations('awyluvw', 5, 5);
    this.getPollRecommendations('sa7myom', 5, 5);
  }

  Widget selectedCard = Text("data");

  Widget build(BuildContext context) {
    Material _buildDesktopView(double width, double height) {
      if (onViewcomment) {
        // return the card + comment view
        return Material(
            child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 0.03 * width,
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
                    width: 0.01 * width,
                  ),
                  Text(
                    'Q O N W A Y',
                    style: GoogleFonts.lato(
                        color: Color(0xff092836),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 0.03 * width,
                  ),
                  Container(
                    width: 0.58 * width,
                    height: 0.055 * height,
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
                    width: 0.03 * width,
                  ),
                  GestureDetector(
                      onTap: () {/* Write listener code here */},
                      child: Text('About Us',
                          style: GoogleFonts.lato(
                              color: Color(0xff092836), fontSize: 18.0))),
                  SizedBox(
                    width: 0.01 * width,
                  ),
                  SizedBox(
                      height: 0.055 * height,
                      width: 0.06 * width,
                      child: TextButton(
                        child: Text(
                          'SIGN UP',
                          style: GoogleFonts.lato(
                              color: Color(0xffedf0f3), fontSize: 18.0),
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
                      child: Comments(
                        pollId: pollId,
                      ))
                ],
              ),
            ),
          ],
        ));
      } else {
        // return the carousel view
        return pollsLoaded
            ? Material(
                child: (ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0.042 * height, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 0.03 * width,
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
                            width: 0.01 * width,
                          ),
                          Text(
                            'Q O N W A Y',
                            style: GoogleFonts.lato(
                                color: Color(0xff092836),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 0.03 * width,
                          ),
                          Container(
                            width: 0.58 * width,
                            height: 0.055 * height,
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
                            width: 0.03 * width,
                          ),
                          GestureDetector(
                              onTap: () {/* Write listener code here */},
                              child: Text('About Us',
                                  style: GoogleFonts.lato(
                                      color: Color(0xff092836),
                                      fontSize: 20.0))),
                          SizedBox(
                            width: 0.01 * width,
                          ),
                          SizedBox(
                              height: 0.055 * height,
                              width: 0.06 * width,
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
                      padding: EdgeInsets.fromLTRB(10, 0.014 * height, 10, 0),
                      child: CarouselSlider.builder(
                        carouselController: _controller,
                        options: CarouselOptions(
                          height: height * 0.85,
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
                          child: (3 > 0)
                              ? polldata_widget(
                                  pollId: polls[itemIndex]['poll_id'],
                                  username: polls[itemIndex]['poll_user'],
                                  question: polls[itemIndex]['poll_data']
                                      ['question'],
                                  votes: 13,
                                  time: 13,
                                  optionsLength: polls[itemIndex]['poll_data']
                                      ['answers']['options'],
                                  options: polls[itemIndex]['poll_data']
                                      ['answers'],
                                  previewUrl: polls[itemIndex]['poll_data']
                                      ['previewUrls']['previewUrl_1'],
                                  pollTitle: 'This is the poll title',
                                  onViewcomment:
                                      (bool viewComment, String poll_id) {
                                    setState(() {
                                      onViewcomment = viewComment;
                                      pollId = poll_id;
                                      selectedCard = polldata_widget(
                                          pollId: polls[itemIndex]['poll_id'],
                                          username: polls[itemIndex]
                                              ['poll_user'],
                                          question: polls[itemIndex]
                                              ['poll_data']['question'],
                                          votes: 13,
                                          time: 13,
                                          optionsLength: polls[itemIndex]
                                                  ['poll_data']['answers']
                                              ['options'],
                                          options: polls[itemIndex]['poll_data']
                                              ['answers'],
                                          previewUrl: polls[itemIndex]
                                                  ['poll_data']['previewUrls']
                                              ['previewUrl_1'],
                                          pollTitle: 'pollTitle',
                                          onViewcomment: updateViewcomment);
                                    });
                                  },
                                )
                              : WaitlistCardWidget(),
                          onTap: () {
                            _controller.nextPage();
                            setState(() {
                              count += 1;
                            });
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
                  width: width * 0.94,
                  height: height * 0.8,
                  child: Comments(
                    pollId: pollId,
                  ))
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
                          pollId: polls[itemIndex]['poll_id'],
                          username: polls[itemIndex]['poll_user'],
                          question: polls[itemIndex]['poll_data']['question'],
                          votes: 13,
                          time: 13,
                          optionsLength: polls[itemIndex]['poll_data']
                              ['answers']['options'],
                          options: polls[itemIndex]['poll_data']['answers'],
                          previewUrl: polls[itemIndex]['poll_data']
                              ['previewUrls']['previewUrl_1'],
                          pollTitle: 'This is the poll title',
                          onViewcomment: (bool viewComment, String poll_id) {
                            setState(() {
                              onViewcomment = viewComment;
                              pollId = poll_id;
                              selectedCard = polldata_widget(
                                  pollId: polls[itemIndex]['poll_id'],
                                  username: polls[itemIndex]['poll_user'],
                                  question: polls[itemIndex]['poll_data']
                                      ['question'],
                                  votes: 13,
                                  time: 13,
                                  optionsLength: polls[itemIndex]['poll_data']
                                      ['answers']['options'],
                                  options: polls[itemIndex]['poll_data']
                                      ['answers'],
                                  previewUrl: polls[itemIndex]['poll_data']
                                      ['previewUrls']['previewUrl_1'],
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
