import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/pages/home_page.dart';
import 'create_poll.dart';
import 'package:http/http.dart' as http;

String access_token = "";
String refresh_token = "";

Future<String> registerUser(String emailId) async {
  var headers = {'Content-Type': 'application/json'};

  String email = json.encode(<String, String>{
    "email": emailId,
  });

  http.Response response = await http.post(
      Uri.parse('http://164.52.212.151:3012/api/access/account/register'),
      headers: headers,
      body: email);

  var convertDataToJson = json.decode(response.body);

  access_token = convertDataToJson["data"]["access_token"];
  refresh_token = convertDataToJson["data"]["refresh_token"];
 
  return convertDataToJson["data"]["type"];
}



class Home extends StatelessWidget {
  static const String route = '/IndexPage';

  String userType = "";

  @override
  Widget build(BuildContext context) {
    Container _buildImageSection(double width, double height) {
      return (Container(
          width: width,
          height: height,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: width * 0.6,
              color: Colors.blue,
              child: Image.network(
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
            ),
          )));
    }

    Container _buildTitleText(double width, double height) {
      return (Container(
        padding: EdgeInsets.all(38.0),
        child: Text(
          'Welcome to Qonway',
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Leto'),
        ),
      ));
    }

    Container _buildMegaphone(double width, double height) {
      double radius = width * 0.2;
      double containerwidth = width * 0.1;

      return (Container(
        width: containerwidth,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
      ));
    }

    Container _buildGoogleLogin(double width, double height) {
      double buttonWidth = width * 0.8;
      double buttonheight = width * 0.1;
      double fontSize;
      if (MediaQuery.of(context).size.width > 700) {
        print('This is desktop');
        fontSize = width * 0.035;
      } else {
        print('this is mobile');
        fontSize = width * 0.06;
      }
      return (Container(
          child: ConstrainedBox(
        constraints:
            BoxConstraints.tightFor(width: buttonWidth, height: buttonheight),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.blue,
              primary: Color(0xff4392B5),
            ),
            child: Text(
              'Continue with Google',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Leto'),
            ),
            onPressed: () async {
              userType = await registerUser("kano@qonway.com");
              if (userType == "influencer") {
                Navigator.of(context).pushNamed(CreatePoll.route);
              } else {
                Navigator.of(context).pushNamed(HomePage.route);
              }
            }),
      )));
    }

    Container _buildLoginSection(double width, double height) {
      return (Container(
          width: width,
          height: height,
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMegaphone(width, height),
                _buildTitleText(width, height),
                _buildGoogleLogin(width, height),
              ],
            ),
          )));
    }

    Container _buildDesktopView() {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

      return (Container(
        width: width,
        height: height,
        color: Color(0xffb8cac8),
        child: Row(
          children: [
            _buildImageSection(width * 0.5, height),
            _buildLoginSection(width * 0.5, height),
          ],
        ),
      ));
    }

    Container _buildMobileView() {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

      return (Container(
        width: width,
        height: height,
        color: Color(0xffb8cac8),
        child: Column(
          children: [
            _buildImageSection(width, height * 0.5),
            _buildLoginSection(width, height * 0.5),
          ],
        ),
      ));
    }

    Widget homePage;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
      homePage = _buildDesktopView();
    } else {
      homePage = _buildMobileView();
    }

    return Scaffold(
        body: ListView(
      children: [
        homePage,
      ],
    ));
  }
}
