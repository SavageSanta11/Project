import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/widgets/DropZoneWidget.dart';
import 'package:http/http.dart' as http;

import '../widgets/DroppedFileWidget.dart';
import '../widgets/duration_widget.dart';
import '../model/file_DataModel.dart';
import '../widgets/option_container.dart';
import 'home_page.dart';

bool isPreviewMode = false;

String question = "";
String previewImgUrl = "";
String urlParam = "";

bool isImgUrl = false;

int days = 0;
int hours = 0;
int minutes = 0;
int options = 2;
String option = "";

String body = json.encode(<String, dynamic>{
  "contentUrl": "http://164.52.212.151:8089/api/v1/media/content/ypannx5.png",
  "previewUrls": [
    "http://164.52.212.151:8089/api/v1/media/preview/ypannx5.png",
    "http://164.52.212.151:8089/api/v1/media/preview/ypannx5.png"
  ],
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

Future<void> createPollRest() async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTE5MjA5OCwianRpIjoiNzg5NWU0YjItZDc1Yy00YzcyLTg5NDMtNzU4ZTRlYTM4OTRhIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTE5MjA5OCwiZXhwIjoxNjI5MTkyOTk4fQ.TNkqBuWYP-IYyyoehijcjogIZMAyB9cfMTOWNHYRwlo',
    'Content-Type': 'application/json'
  };

  http.Response response = await http.post(
      Uri.parse('http://164.52.212.151:3012/api/access/poll/create'),
      headers: headers,
      body: body);

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

Future<String> crawlUrl(String url) async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTI4Njg2NywianRpIjoiMWZkYmQ0OWMtNmI5Mi00OWJjLTlhMGUtYzEwNTZlOWFmYWY5IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTI4Njg2NywiZXhwIjoxNjI5Mjg3NzY3fQ.Gq7mXuF7UWd42kn1EyduiNv7HEY_UPbv8LI3VpZf_NU'
  };

  http.Response response = await http.get(
    Uri.parse('http://164.52.212.151:3012/api/access/crawl/url?url=' + url),
    headers: headers,
  );

  var convertDataToJson = json.decode(response.body);
  previewImgUrl = convertDataToJson["data"]["preview_image_url"];
  return (previewImgUrl);
}

class CreatePoll extends StatefulWidget {
  static const String route = 'CreatePoll';
  @override
  State<CreatePoll> createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  var children = <Widget>[];

  File_Data_Model? file;

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

  void updatePreviewMode(bool previewMode) {
    setState(() {
      isPreviewMode = previewMode;
      isImgUrl = false;
    });
  }

  void updateValidUrl(String url) async{

    previewImgUrl = await crawlUrl(url);
    
    setState(() {
      isImgUrl = true;
      isPreviewMode = true;
    });
    print(previewImgUrl);
  }

  

  var listDays = [for (var i = 0; i < 22; i += 1) i];
  var listHours = [for (var i = 0; i < 24; i += 1) i];
  var listMinutes = [for (var i = 0; i < 60; i += 1) i];

  String opText = 'What Do you want to poll?';

  @override
  Widget build(BuildContext context) {
    Container _createUploadMedia(double width, double height) {
      double _uploadwidth = width * 0.8;
      return (Container(
          color: Colors.transparent,
          height: height,
          width: _uploadwidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  child: isPreviewMode
                      ? DroppedFileWidget(
                          file: file,
                          previewState: isPreviewMode,
                          onPreviewStateChanged: updatePreviewMode,
                          previewImgUrl: isImgUrl? previewImgUrl : "https://files.worldwildlife.org/wwfcmsprod/images/Tiger_resting_Bandhavgarh_National_Park_India/hero_small/6aofsvaglm_Medium_WW226365.jpg",
                        )
                      : DropZoneWidget(
                          onDroppedFile: (file) => setState(() {
                            this.file = file;
                            isPreviewMode = true;
                          }),
                          onValidUrl: updateValidUrl,
                        )),
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
              child: TextField(
                onChanged: (val) {
                  question = val;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: opText,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0))),
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
            height: height * 0.2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DurationWidget('Days', _durationWidth * 0.25, height * 0.07,
                    listDays, updateDays),
                DurationWidget('Hours', _durationWidth * 0.25, height * 0.07,
                    listHours, updateHours),
                DurationWidget('Minutes', _durationWidth * 0.25, height * 0.07,
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
          child: Text('Publish', style: TextStyle(fontFamily: 'Leto')),
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            primary: Color(0xff092836),
          ),
          onPressed: () {
            createPollRest();

            Navigator.of(context).pushNamed(HomePage.route);
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

    ListView _buildCreatePollState(double width, double height) {
      return (ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _createUploadMedia(width, height * 0.4),
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