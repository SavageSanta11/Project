import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/pages/create_poll.dart';
import 'package:project/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

String accessToken = "";
String refreshToken = "";

setToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', "abc");
}
getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('token');
  return stringValue;
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

Future<void> _handleSignOut() => _googleSignIn.disconnect();

Future<String> registerUser(String emailId) async {
  var headers = {'Content-Type': 'application/json'};

  String email = json.encode(<String, String>{
    "email": emailId,
  });

  http.Response response = await http.post(
      Uri.parse('http://164.52.212.151:7002/api/access/account/register'),
      headers: headers,
      body: email);

  var convertDataToJson = json.decode(response.body);

  accessToken = convertDataToJson["data"]["access_token"];
  refreshToken = convertDataToJson["data"]["refresh_token"];

  return convertDataToJson["data"]["type"];
}

// ignore: must_be_immutable
class Home extends StatefulWidget {
  static const String route = '/IndexPage';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleSignInAccount? _currentUser;

  String userType = "";

  @override
  void initState() {
    super.initState();
    setToken();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
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
              
              String token = await getToken();
              
              
             /* _handleSignIn();
              print(user!.email);
              */
              userType = await registerUser("kano@qonway.com");
              print(userType);
              if (userType == "influencer") {
                Navigator.of(context).pushNamed(CreatePoll.route);
              } else {
                Navigator.of(context).pushNamed(HomePage.route);
              }
              //Navigator.of(context).pushNamed(CreatePoll.route);
              
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
