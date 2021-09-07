import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/widgets/carousel/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pollCard.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

List polls = [];

class HomeBody extends StatefulWidget {
  final double width;
  final double height;
  final String id;

  const HomeBody(this.width, this.height, this.id);
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  int itemCount = polls.length;
  bool pollsLoaded = false;
  bool commentPressed = false;
  SharedPreferences? preferences;

  

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
    print(uri);
    var convertDataToJson = json.decode(response.body);

    setState(() {
      pollsLoaded = true;
      polls = convertDataToJson['data'];
    });
   
  }

  @override
  void initState() {
    super.initState();
    //this.getPollRecommendations('awyluvw', 5, 5);
     initializePreference().whenComplete((){
       setState(() {});
     });
    this.getPollRecommendations((this.preferences!.getString('email') ?? " "), 5, 5);
  }
   Future<void> initializePreference() async{
     this.preferences = await SharedPreferences.getInstance();
  }
  Widget build(BuildContext context) {
    Container _buildDesktopView(double width, double height) {
      return pollsLoaded ? (Container(
          width: width,
          height: height,
          color: Colors.lightBlue,
          child: CarouselSlider.builder(
            itemCount: itemCount,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    PollCard(width * 0.33, height * 0.885, polls, itemIndex, polls[itemIndex]['poll_id'],),
            options: CarouselOptions(
              height: height * 0.9,
              viewportFraction: 0.35,
              enableInfiniteScroll: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              
            ),
          ))) : Container(child: Text('loading...'),);
    }

    Container _buildMobileView(double width, double height) {
      return (Container());
    }

    Widget _homebody;

    double width = widget.width;
    double height = widget.height;

    double aspectRatio = width / height;

    if (aspectRatio >= 1.5) {
      _homebody = _buildDesktopView(width, height);
    } else {
      _homebody = _buildMobileView(width, height);
    }
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.amber,
      child: _homebody,
    );
  }
}
