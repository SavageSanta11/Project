import 'package:flutter/material.dart';
import 'package:project/DropZoneWidget.dart';

import 'DroppedFileWidget.dart';
import 'duration_widget.dart';
import 'model/file_DataModel.dart';
import 'option_container.dart';
import 'carousel_widget.dart';
import 'home_page.dart';

bool isPreviewMode = false;

class CreatePoll extends StatefulWidget {
  static const String route = '/create_poll';
  @override
  State<CreatePoll> createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  var children = <Widget>[];

  File_Data_Model? file;

  var listDays = [for (var i = 0; i < 8; i += 1) i];
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
                        )
                      : DropZoneWidget(
                          onDroppedFile: (file) => setState(() {
                            this.file = file;
                            isPreviewMode = true;
                          }),
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
                DurationWidget(
                    'Days', _durationWidth * 0.25, height * 0.07, listDays),
                DurationWidget(
                    'Hours', _durationWidth * 0.25, height * 0.07, listHours),
                DurationWidget('Minutes', _durationWidth * 0.25, height * 0.07,
                    listMinutes),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
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
            OptionContainer(width, height),
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
