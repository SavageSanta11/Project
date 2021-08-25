// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:project/pages/create_poll.dart';
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
        HomePage.route: (context) => HomePage(),
       
      },
    );
  }
}
