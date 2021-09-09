import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/homeBody.dart';
import 'package:google_fonts/google_fonts.dart';


// ignore: camel_case_types
class HomePage extends StatefulWidget {
  static const String route = '/HomePage';
  final String id;

  const HomePage({Key? key, required this.id  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

// ignore: camel_case_types
class _HomePageState extends State<HomePage> {
  @override
  

  Widget build(BuildContext context) {
    Material _buildDesktopView(double width, double height) {
      return Material(
        child: Container(
          width: width,
          height: height,
          child: ListView(
            children: [
              Navigation(width, height * 0.1),
              HomeBody(width, height * 0.9, widget.id)
            ],
          ),
        ),
      );
    }

    Widget _buildMobileView(double width, double height) {
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
          body: HomeBody(width * 0.95, height * 0.9, widget.id));
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
