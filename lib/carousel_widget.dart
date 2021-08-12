import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'polldata_widget.dart';

// ignore: camel_case_types
class carousel_widget extends StatefulWidget {
  @override
  _carousel_widgetState createState() => _carousel_widgetState();
}

// ignore: camel_case_types
class _carousel_widgetState extends State<carousel_widget> {
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
    Column _getColumnDataWeb(double width, double height) {
      return (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              height: height*0.85,
              viewportFraction: 0.35,
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
                  width: width*0.25,
                  child: card,
                );
              });
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(cardList, (index, url) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == index ? Colors.blueAccent : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ));
    }

    Column _getColumnDataMobile(double width, double height) {
      return (Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              height: height*0.9,
              viewportFraction: 1,
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
                  width: width*0.95,
                 // height: height*0.8,
                  child: card,
                );
              });
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(cardList, (index, url) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == index ? Colors.blueAccent : Colors.grey,
                ),
              );
            }),
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
     carousel = _getColumnDataWeb(width, height);
    } else {
      carousel = _getColumnDataMobile(width, height);
    }

    
    return Container(
        width: width,
        height: height,
        color: Color(0xffedf0f3),
        child: carousel);
  }
}
