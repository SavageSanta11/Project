import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:social_share/social_share.dart';

List<dynamic> polls = [];

typedef Iterable<T> IterableCallback<T>();

typedef void BoolCallback(bool viewComment, String pollID);

List<T> toList<T>(IterableCallback<T> cb) {
  return List.unmodifiable(cb());
}

Future<void> recordVote(
  String pollID,
  int optionNo,
  String optionText,
) async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYzMDU3NDk0NSwianRpIjoiMDMwYzQ2NzYtNGZjYi00MWUyLWE3ZmQtZTBhYTEzOWU0YTIwIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Im9uYWsxN0Bxb253YXkuY29tIiwibmJmIjoxNjMwNTc0OTQ1LCJleHAiOjE2MzA1NzU4NDV9.q4G9Q9ZAvdv-cCK0ITwasNy8iewvW4qMts7gTgFsYz4',
    'Content-Type': 'application/json'
  };

  String body = json.encode(<String, dynamic>{
    "poll_id": pollID,
    "opt_num": optionNo,
    "opt_text": optionText,
    "email": "onak17@qonway.com"
  });

  http.Response response = await http.post(
      Uri.parse('http://164.52.212.151:7002/api/access/record/vote'),
      headers: headers,
      body: body);

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

class PollCard extends StatefulWidget {
  final double width;
  final double height;
  final List params;
  final int index;
  final String pollID;
  final BoolCallback isCommentPressed;

  PollCard(
      {required this.width,
      required this.height,
      required this.params,
      required this.index,
      required this.pollID,
      required this.isCommentPressed});
  @override
  _PollCardState createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  bool isVoted = false;
  int votedOptionIndex = 0;
  bool viewComment = false;

  String option1 = "0.0%";
  String option2 = "0.0%";
  String option3 = "0.0%";
  String option4 = "0.0%";

  Future<void> getPollResult(String pollID) async {
    String uri =
        'http://164.52.212.151:7002/api/access/poll/result?poll_id=' + pollID;

    http.Response response = await http.get(
      Uri.parse(uri),
    );

    var convertDataToJson = json.decode(response.body);

    setState(() {
      option1 = convertDataToJson['data']['option_1']['votePrct'];
      option2 = convertDataToJson['data']['option_2']['votePrct'];
      option3 = convertDataToJson['data']['option_3']['votePrct'];
      option4 = convertDataToJson['data']['option_4']['votePrct'];
    });
  }

  @override
  void initState() {
    super.initState();
    //this.getPollRecommendations('awyluvw', 5, 5);
    this.getPollResult(widget.pollID);
  }

  Widget build(BuildContext context) {
    String body = json.encode(<String, dynamic>{
      "pollId": widget.params[widget.index]['poll_id'],
      "previewUrl": widget.params[widget.index]['poll_data']['previewUrls']
          ['previewUrl_1'],
      "pollTitle": 'This is the poll title',
      "username": widget.params[widget.index]['poll_user'],
      'question': widget.params[widget.index]['poll_data']['question'],
      'optionCount': widget.params[widget.index]['poll_data']['answers']
          ['options'],
      'option1': widget.params[widget.index]['poll_data']['answers']
          ['option_1'],
      'option2': widget.params[widget.index]['poll_data']['answers']
          ['option_2'],
      'option3': widget.params[widget.index]['poll_data']['answers']
          ['option_3'],
      'option4': widget.params[widget.index]['poll_data']['answers']
          ['option_4'],
      'option1percent': option1,
      'option2percent': option2,
      'option3percent': option3,
      'option4percent': option4,
    });

    var convertdata = jsonDecode(body);

    Container _createUserProfilePic(double width, double height) {
      return Container(
          width: width,
          height: height,
          color: Colors.transparent,
          //margin: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                      'https://i.natgeofe.com/n/6490d605-b11a-4919-963e-f1e6f3c0d4b6/sumatran-tiger-thumbnail-nationalgeographic_1456276.jpg')),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tiger",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Tiger Zinda Hai"),
                ],
              ),
            ],
          ));
    }

    Container _createPreviewPicture(double width, double height) {
      return Container(
        width: width,
        height: height,
        color: Colors.transparent,
        
        child: Image.network(
          convertdata['previewUrl'],
          fit: BoxFit.cover,
        ),
      );
    }

    Container _createTitleForPollcard(double width, double height) {
      return Container(
        width: width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              convertdata['pollTitle'],
             style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            ),
          ],
        ),
      );
    }

    Container _createTopSection(double width, double height) {
      return Container(
          width: width,
          height: height,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _createUserProfilePic(width, height * 0.15),
              _createPreviewPicture(width, height * 0.8),
              //_createTitleForPollcard(width, height * 0.2)
            ],
          ));
    }

    Container _createQuestionText(double width, double height) {
      String trimmedOutput = convertdata['question'];
      return Container(
        width: width,
        height: height,
        color: Colors.transparent,
        margin: EdgeInsets.all(7),
        child: Text(
          
          trimmedOutput,
          style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            
        ),
      );
    }

    Container _createShareButton(double width, double height) {
      double fontSize = width * 0.03;

      return (Container(
        width: width * 0.9,
        height: height,
        child: OutlinedButton(
            child: Text(
              'SHARE',
              style: GoogleFonts.lato(
                  fontSize: fontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              SocialShare.shareWhatsapp("Hello World");
            }),
      ));
    }

    Container _createCommentButton(double width, double height) {
      return Container(
        width: width,
        height: height,
        color: Colors.orange,
        child: TextButton.icon(
            onPressed: () {
              setState(() {
                viewComment = !viewComment;
                widget.isCommentPressed(viewComment, convertdata['pollId']);
              });
            },
            icon: Icon(
              Icons.comment,
              color: Colors.black,
            ),
            label: Text(
              '13',
              style: TextStyle(color: Colors.black),
            )),
      );
    }

    Container _createVotedOption(double width, double height, String optionText,
        int optionIndex, String votePercent) {
      double fontSize = width * 0.03;
      int color = 0xfff7f7f7;

      if (votedOptionIndex == optionIndex) {
        color = 0xffeffae5;
      } else {
        color = 0xffffe5e5;
      }

      return (Container(
          color: Color(color),
          width: width * 0.8,
          height: height * 0.16,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                    child: Text(
                      optionText,
                      style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                    child: Text(
                      votePercent,
                      style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
                    ),
                  ),
                ],
              ),
            ],
          )));
    }

    Container _createPollOption(
      // ignore: non_constant_identifier_names
      double width,
      double height,
      String optionText,
      int optionIndex,
    ) {
      double fontSize = width * 0.03;

      return (Container(
        color: Color(0xfff7f7f7),
        width: width ,
        child: ElevatedButton(
          child: Text(optionText,
              style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              
            ),
            textAlign: TextAlign.left,
            ),
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.black, primary: Color(0xffedf0f3)),
          onPressed: () async {
            // Call Rest API to register vote
            setState(() {
              recordVote(widget.pollID, optionIndex, optionText);
              getPollResult(widget.pollID);
              votedOptionIndex = optionIndex;
              isVoted = true;
            });
          },
        ),
      ));
    }

    Container _createVotedSection(double width, double height) {
      return Container(
        width: width,
        height: height ,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: toList(() sync* {
            if (convertdata['optionCount'] == 2) {
              yield _createVotedOption(
                  width, height, convertdata['option1'], 1, option1);
              yield _createVotedOption(
                  width, height, convertdata['option2'], 2, option2);
            } else if (convertdata['optionCount'] == 3) {
              yield _createVotedOption(
                  width, height, convertdata['option1'], 1, option1);
              yield _createVotedOption(
                  width, height, convertdata['option2'], 2, option2);
              yield _createVotedOption(
                  width, height, convertdata['option3'], 3, option3);
            } else if (convertdata['optionCount'] == 4) {
              yield _createVotedOption(
                  width, height, convertdata['option1'], 1, option1);
              yield _createVotedOption(
                  width, height, convertdata['option2'], 2, option2);
              yield _createVotedOption(
                  width, height, convertdata['option3'], 3, option3);
              yield _createVotedOption(
                  width, height, convertdata['option4'], 4, option4);
            }
          }),
        ),
      );
    }

    Container _createPollSection(double width, double height) {
      return Container(
        width: width,
        height: height ,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: toList(() sync* {
            if (convertdata['optionCount'] == 2) {
              yield _createPollOption(
                width,
                height,
                convertdata['option1'],
                1,
              );
              yield _createPollOption(
                width,
                height,
                convertdata['option2'],
                2,
              );
            } else if (convertdata['optionCount'] == 3) {
              yield _createPollOption(
                width,
                height,
                convertdata['option1'],
                1,
              );
              yield _createPollOption(
                width,
                height,
                convertdata['option2'],
                2,
              );
              yield _createPollOption(
                width,
                height,
                convertdata['option3'],
                3,
              );
            } else if (convertdata['optionCount'] == 4) {
              yield _createPollOption(
                width,
                height,
                convertdata['option1'],
                1,
              );
              yield _createPollOption(
                width,
                height,
                convertdata['option2'],
                2,
              );
              yield _createPollOption(
                width,
                height,
                convertdata['option3'],
                3,
              );
              yield _createPollOption(
                width,
                height,
                convertdata['option4'],
                4,
              );
            }
          }),
        ),
      );
    }

    Container _createMiddleSection(double width, double height) {
      Widget pollSection;

      if (isVoted) {
        pollSection = _createVotedSection(width, height * 0.75);
      } else {
        pollSection = _createPollSection(width, height * 0.75);
      }

      return Container(
        width: width,
        height: height,
        color: Color(0xfff4f4f4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_createQuestionText(width, height * 0.15), pollSection],
        ),
      );
    }

    Container _createBottomSection(double width, double height) {
      return Container(
        width: width,
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _createCommentButton(width * 0.3, height),
            _createShareButton(width * 0.7, height)
          ],
        ),
      );
    }

    Container _buildDesktopView(double width, double height) {
      return (Container(
        width: width,
        height: height,
        
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Card(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
            children: [
                _createTopSection(width, height * 0.60),
                _createMiddleSection(width, height * 0.35),
                _createBottomSection(width, height * 0.05)
            ],
          ),
              )),
        ),
      ));
    }

    double width = widget.width;
    double height = widget.height;

    return Container(
      width: widget.width,
      height: widget.height,
      child: _buildDesktopView(width, height),
    );
  }
}
