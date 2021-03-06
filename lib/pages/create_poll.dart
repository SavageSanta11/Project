import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import '../widgets/cardPreview_widget.dart';
import '../widgets/duration_widget.dart';
import '../model/file_DataModel.dart';
import '../widgets/option_container.dart';
import '../widgets/previewMode.dart';
import '../widgets/uploadMedia.dart';
import 'home_page.dart';

bool isPreviewMode = false;
bool previewFromUpload = true;

String question = "";

int days = 0;
int hours = 0;
int minutes = 0;
int options = 2;
String option = "";
String previewImgUrl = "";
String contentUrl = "";
String mediaUrl = "";
String pollID = "";


setPollID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('pollID', pollID);
}

getPollID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('pollID');
  return stringValue;
}


class CreatePoll extends StatefulWidget {
  static const String route = '/CreatePoll';
  @override
  State<CreatePoll> createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  GlobalKey<FormState> _key = new GlobalKey();

  var children = <Widget>[];

  SharedPreferences? preferences;

  File_Data_Model? file;

  
String writeBody() {
  String body;
  if (optionList.length == 2) {
    body = json.encode(<String, dynamic>{
      "mediaUrl": mediaUrl,
      //"screenName": (this.preferences!.getString('displayName') ?? " "),
      "contentUrl": contentUrl,
      "previewUrls": [previewImgUrl],
      "title": 'Title',
      "email": (this.preferences!.getString('email') ?? " "),
      "question": question,
      "answers": {
        "options": options,
        "option_1": optionList[0],
        "option_2": optionList[1],
      },
      "duration": {"days": days, "hours": hours, "minutes": minutes},
      "tags": ["delhi", "metro", "mumbai", "rail"]
    });
  } else if (optionList.length == 3) {
    body = json.encode(<String, dynamic>{
      "mediaUrl": mediaUrl,
      //"screenName": getDisplayName(),
      "contentUrl": contentUrl,
      "previewUrls": [previewImgUrl],
      "title": 'Title',
     "email": (this.preferences!.getString('email') ?? " "),
      "question": question,
      "answers": {
        "options": options,
        "option_1": optionList[0],
        "option_2": optionList[1],
        "option_3": optionList[2],
      },
      "duration": {"days": days, "hours": hours, "minutes": minutes},
      "tags": ["delhi", "metro", "mumbai", "rail"]
    });
  } else {
    body = json.encode(<String, dynamic>{
      "mediaUrl": mediaUrl,
      //"screenName": (this.preferences!.getString('displayName') ?? " "),
      "contentUrl": contentUrl,
      "previewUrls": [previewImgUrl],
      "title": 'Title',
      "email": (this.preferences!.getString('email') ?? " "),
      "question": question,
      "answers": {
        "options": options,
        "option_1": optionList[0],
        "option_2": optionList[1],
        "option_3": optionList[2],
        "option_4": optionList[3],
      },
      "duration": {"days": days, "hours": hours, "minutes": minutes},
      "tags": ["delhi", "metro", "mumbai", "rail"]
    });
  }
  return body;
}

Future<String> createPollRest() async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTI4MjQyMiwianRpIjoiNWMyZmNkYTQtZjgyZS00ODhlLWFmZGEtNTFiZmEyYmZlMzJkIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTI4MjQyMiwiZXhwIjoxNjI5MjgzMzIyfQ.L6O-rXKbo8vtcyT0K071o108Lljpr_PjLmw14rDHVvI',
    'Content-Type': 'application/json'
  };

  http.Response response = await http.post(
      Uri.parse('http://qonway.com:7002/api/access/poll/create'),
      headers: headers,
      body: writeBody());

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
  String pollID = convertDataToJson['data']['pollId'];
  return pollID;
}

Future<String> crawlUrl(String url) async {
  var headers = {
    'Authorization':
        'Bearer  eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTI4MjQyMiwianRpIjoiNWMyZmNkYTQtZjgyZS00ODhlLWFmZGEtNTFiZmEyYmZlMzJkIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTI4MjQyMiwiZXhwIjoxNjI5MjgzMzIyfQ.L6O-rXKbo8vtcyT0K071o108Lljpr_PjLmw14rDHVvI'
  };
  String baseUri = 'http://qonway.com:7002/api/access/crawl/url?url=';
  http.Response response = await http.get(
    Uri.parse(baseUri + url),
    headers: headers,
  );

  var convertDataToJson = json.decode(response.body);
  previewImgUrl = convertDataToJson["data"]["preview_image_url"];
  mediaUrl = convertDataToJson["data"]["media_url"];
  return (previewImgUrl);
}

Future<void> publishPoll(String pollID) async {
  String uri =
      'http://qonway.com:7002/api/access/poll/publish?poll_id=' + pollID;

  http.Response response = await http.get(
    Uri.parse(uri),
  );

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

  void updateDays(int duration) {
    setState(() {
      days = duration;
    });
  }

  void updateHours(int duration) {
    setState(() {
      hours = duration;
    });
  }

  void updateMinutes(int duration) {
    setState(() {
      minutes = duration;
    });
  }

  void updateOptions(int num) {
    setState(() {
      options = num;
    });
  }

  void updatePreviewMode(bool flag) {
    setState(() {
      isPreviewMode = flag;
      if (flag == false) {
        previewImgUrl = "";
      }
    });
  }

  void updateValidUrl(String previewUrl, String enteredUrl) async {
    previewImgUrl = previewUrl;
    if (enteredUrl == "") {
      contentUrl = previewImgUrl;
    } else {
      contentUrl = enteredUrl;
    }
    setState(() {
      isPreviewMode = true;
    });
  }

  var listDays = [for (var i = 0; i < 8; i += 1) i];
  var listHours = [for (var i = 0; i < 24; i += 1) i];
  var listMinutes = [for (var i = 0; i < 60; i += 1) i];

  String opText = 'What Do you want to poll?';

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete((){
       setState(() {});
     });
    
  }

  Future<void> initializePreference() async{
     this.preferences = await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    Widget _uploadMediaWidget;

    Container _createUploadMedia(double width, double height) {
      double _uploadwidth = width * 0.8;

      _uploadMediaWidget = uploadMode(
        width * 0.8,
        height * 0.8,
        updatePreviewMode,
        updateValidUrl,
      );

      return (Container(
          color: Colors.transparent,
          height: height,
          width: _uploadwidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(child: _uploadMediaWidget),
            ],
          )));
    }

    Container _createQuestionField(double width, double height) {
      double _questionWidth = width * 0.8;
      return (Container(
        child: Column(
          children: [
            Container(
              width: _questionWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Form(
                key: _key,
                child: TextFormField(
                  onChanged: (val) {
                    setState(() {
                      question = val;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Fill this";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    hintText: opText,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    }

    Container _createDurationContainer(double width, double height) {
      double _durationWidth = width * 0.9;
      return (Container(
        child: Center(
          child: Container(
            width: _durationWidth,
            height: height * 0.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DurationWidget('Days', _durationWidth * 0.29, height * 0.07,
                    listDays, updateDays),
                DurationWidget('Hours', _durationWidth * 0.29, height * 0.07,
                    listHours, updateHours),
                DurationWidget('Minutes', _durationWidth * 0.29, height * 0.07,
                    listMinutes, updateMinutes),
              ],
            ),
          ),
        ),
      ));
    }

    Container _createPublishButton(double width, double height) {
      return (Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        child: ElevatedButton(
          child: Text(
            'PUBLISH',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            primary: Color(0xff092836),
          ),
          onPressed: () async {
            if (_key.currentState!.validate()) {
              pollID = await createPollRest();
              setPollID();
              publishPoll(pollID);
              Navigator.of(context).pushNamed(HomePage.route);
            }
          },
        ),
      ));
    }

    Container _createPublishContainer(double width, double height) {
      return (Container(
        width: width,
        height: height,
        color: Colors.transparent,
        child: Container(
          width: width * 0.5,
          height: height * 0.5,
          color: Colors.transparent,
          child: Row(
            children: [
              Container(width: width * 0.1),
              _createPublishButton(width * 0.5, height * 0.5),
            ],
          ),
        ),
      ));
    }

    Widget _buildCreatePollState(double width, double height) {
      return (ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            isPreviewMode
                ? PreviewMode(width * 0.8, double.infinity, updatePreviewMode,
                    previewImgUrl)
                : _createUploadMedia(width, height * 0.4),

            //DroppedFileWidget(file: file,),

            _createQuestionField(width, height),

            OptionContainer(width, height, updateOptions),
            _createDurationContainer(width, height),
            _createPublishContainer(width, height * 0.1)
          ]));
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
            Container(
              color: Colors.transparent,
              width: width * 0.5,
              child: _buildCreatePollState(width * 0.5, height),
            ),
            Container(
              color: Colors.amber,
              width: width * 0.5,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: height * 0.9,
                  width: width * 0.3,
                  color: Colors.pink,
                  child: CardPreview(
                      width * 0.3, height * 0.8, previewImgUrl, question),
                ),
              ),
            )
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
            Container(
              color: Colors.transparent,
              height: height,
              child: _buildCreatePollState(width, height),
            ),
          ],
        ),
      ));
    }

    Widget _createPollPage;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
      _createPollPage = _buildDesktopView();
    } else {
      print('This is mobile');
      _createPollPage = _buildMobileView();
    }

    return Scaffold(
        body: Container(
      color: Colors.blueGrey,
      child: _createPollPage,
    ));
  }
}
