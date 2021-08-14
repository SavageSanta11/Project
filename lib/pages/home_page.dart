import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../widgets/polldata_widget.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class HomePage extends StatefulWidget {
  static const String route = 'HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

// ignore: camel_case_types
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

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
        child: (Column(
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
                          color: Color(0xff092836), fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40.0,
                    width: 170.0,
                    child: TextButton.icon(
                      icon: Icon(Icons.mic_external_on, size: 25,),
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
            SizedBox(
              height: 50.0,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: height * 0.80,
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
                    width: width * 0.25,
                    child: card,
                  );
                });
              }).toList(),
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
