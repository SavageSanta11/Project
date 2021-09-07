// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:project/pages/create_poll.dart';
import 'package:project/pages/profile_page_other.dart';
import 'package:project/pages/profile_page_self.dart';
import 'pages/index_page.dart';
import 'package:url_strategy/url_strategy.dart';
import 'pages/home_page.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

enum DeviceType { Phone, Tablet }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Home.route,
      //use MaterialApp() widget like this
       //create new widget class for this 'home' to
      // escape 'No MediaQuery widget found' error
      routes: {
        Home.route: (context) => Home(),
        CreatePoll.route: (context) => CreatePoll(),
        HomePage.route: (context) => HomePage(id: 'sa7myom',),
        ProfilePageSelf.route: (context) => ProfilePageSelf(),
        ProfilePageOther.route: (context) => ProfilePageOther(),
      },
      onGenerateRoute: (settings){
        if(settings.name != null){
          var uriData = Uri.parse(settings.name!);
          print(uriData);
        }
        if (settings.name == '/IndexPage') {
          return MaterialPageRoute(builder: (context) => Home());
        }
        if (settings.name == '/CreatePoll') {
          return MaterialPageRoute(builder: (context) => CreatePoll());
        }
        if (settings.name == '/HomePage') {
          return MaterialPageRoute(builder: (context) => HomePage(id: 'sa7myom',));
        }
        if (settings.name == '/MyProfilePage') {
          return MaterialPageRoute(builder: (context) => ProfilePageSelf());
        }
        if (settings.name == '/ProfilePage') {
          return MaterialPageRoute(builder: (context) => ProfilePageOther());
        }

          
        // Handle '/details/:id'
        var uri = Uri.parse(settings.name as String);
        print(uri);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'HomePage') {
          var id = uri.pathSegments[1];
          return MaterialPageRoute(builder: (context) => HomePage(id: id));
        }

        
      },
    );
  }
}
