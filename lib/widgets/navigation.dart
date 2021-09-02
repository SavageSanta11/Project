import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Navigation extends StatefulWidget {
  final double width;
  final double height;
  const Navigation(this.width, this.height);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  String opText = 'What Do you want to poll?';
  String search = '';
  @override
  Widget build(BuildContext context) {
    Container _createSearchField(double width, double height) {
      return Container(
        width: 0.58 * width,
        height: 0.055 * height,
        child: TextField(
          decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                size: 30.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.1 * 0.281 * height),
              ),
              filled: true,
              fillColor: Colors.white70),
        ),
      );
    }

    Container _createSignInButton(double width, double height) {
      return (Container(
          height: 0.055 * height,
          width: 0.07 * width,
          child: TextButton(
            child: Text(
              'SIGN UP',
              style: GoogleFonts.lato(
                  color: Color(0xffedf0f3), fontSize: 0.1 * 0.261 * height),
            ),
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              primary: Color(0xff092836),
            ),
            onPressed: () {},
          )));
    }

    Container _createMenuButton(double width, double height) {
      return Container(
        width: 0.1 * width,
        child: IconButton(
          icon: Icon(
            Icons.menu,
            size: 30,
          ),
          color: Color(0xff092836),
          onPressed: () {},
        ),
      );
    }

    Container _createQonwayLogo(double width, double height) {
      return Container(
        width: 0.1 * width,
        child: Text(
          'Q O N W A Y',
          style: GoogleFonts.lato(
              color: Color(0xff092836),
              fontSize: 0.1 * 0.281 * height,
              fontWeight: FontWeight.bold),
        ),
      );
    }

    Container _createAboutUsButton(double width, double height) {
      return Container(
        width: 0.1 * width,
        child: Center(
          child: GestureDetector(
              onTap: () {/* Write listener code here */},
              child: Text('About Us',
                  style: GoogleFonts.lato(
                      color: Color(0xff092836),
                      fontSize: 0.1 * 0.281 * height))),
        ),
      );
    }

    Container _buildDesktopView(double width, double height) {
      return Container(
        height: height * 0.1,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _createMenuButton(width, height),
            _createQonwayLogo(width, height),
            _createSearchField(width, height),
            _createAboutUsButton(width, height),
            _createSignInButton(width, height)
          ],
        ),
      );
    }

    Container _buildMobileView(double width, double height) {
      return (Container());
    }

    Widget _navigationset;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
      _navigationset = _buildDesktopView(width, height);
    } else {
      _navigationset = _buildMobileView(width, height);
    }
    return Container(
      width: widget.width,
      height: widget.height,
      child: _navigationset,
    );
  }
}
