import 'dart:convert';

import 'package:project/widgets/WaitlistCardWidget.dart';

import '../widgets/carousel/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../widgets/polldata_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;



// ignore: camel_case_types
class CommentPage extends StatefulWidget {
  static const String route = 'CommentPage';
  @override
  _CommentPageState createState() => _CommentPageState();
}

// ignore: camel_case_types
class _CommentPageState extends State<CommentPage> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;
  bool center = false;

  @override
  Widget build(BuildContext context) {
    Material _buildDesktopView(double width, double height) {
      return Material(
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
                        suffixIcon: Icon(Icons.search, size: 30.0,),
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
