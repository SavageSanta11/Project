import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

List<dynamic> polls = [];

typedef Iterable<T> IterableCallback<T>();

typedef void BoolCallback(bool viewComment, String pollId);

List<T> toList<T>(IterableCallback<T> cb) {
  return List.unmodifiable(cb());
}

Future<void> recordVote(
  String poll_id,
  int optionNo,
  String optionText,
) async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYzMDU3NDk0NSwianRpIjoiMDMwYzQ2NzYtNGZjYi00MWUyLWE3ZmQtZTBhYTEzOWU0YTIwIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Im9uYWsxN0Bxb253YXkuY29tIiwibmJmIjoxNjMwNTc0OTQ1LCJleHAiOjE2MzA1NzU4NDV9.q4G9Q9ZAvdv-cCK0ITwasNy8iewvW4qMts7gTgFsYz4',
    'Content-Type': 'application/json'
  };

  String body = json.encode(<String, dynamic>{
    "poll_id": poll_id,
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
  final String pollId;

  PollCard(this.width, this.height, this.params, this.index, this.pollId);
  @override
  _PollCardState createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  bool isVoted = false;
  int votedOptionIndex = 0;
  bool viewComment = false;

  int option1 = 0;
  int option2 = 0;
  int option3 = 0;
  int option4 = 0;

  Future<void> getPollResult(String pollId) async {
    String uri =
        'http://164.52.212.151:7002/api/access/poll/result?poll_id=' + pollId;

    http.Response response = await http.get(
      Uri.parse(uri),
    );

    var convertDataToJson = json.decode(response.body);

    setState(() {
      option1 = convertDataToJson['data']['option_1']['voteCount'];
      option2 = convertDataToJson['data']['option_2']['voteCount'];
      option3 = convertDataToJson['data']['option_3']['voteCount'];
      option4 = convertDataToJson['data']['option_4']['voteCount'];
    });
  }

  @override
  void initState() {
    super.initState();
    //this.getPollRecommendations('awyluvw', 5, 5);
    this.getPollResult(widget.pollId);
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
      'option1votes': option1,
      'option2votes': option2,
      'option3votes': option3,
      'option4votes': option4,
    });

    var convertdata = jsonDecode(body);
    print(convertdata['option1votes']);

    Container _createProfilePicture(double width, double height) {
      return Container(
        width: width ,
        height: height*1.1,
        color: Colors.transparent,
        //margin: EdgeInsets.symmetric(vertical: 6),
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
              style: TextStyle(
                fontFamily: 'Leto',
                fontSize: 20,
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
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _createProfilePicture(width, height * 0.8),
              _createTitleForPollcard(width, height * 0.2)
            ],
          ));
    }

    Container _createQuestionText(double width, double height) {
      return Container(
        width: width,
        color: Colors.transparent,
        margin: EdgeInsets.all(20),
        child: Text(
          convertdata['question'],
          style: TextStyle(fontFamily: 'Leto', fontSize: 20),
        ),
      );
    }

    Container _createShareButton(double width, double height) {
      double fontSize = width * 0.03;

      return (Container(
        width: width * 0.45,
        height: height * 0.8,
        color: Colors.pink,
        child: OutlinedButton(
            child: Text(
              'SHARE',
              style: GoogleFonts.lato(
                  fontSize: fontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {}),
      ));
    }

    Container _createCommentButton(double width, double height) {
      return Container(
        width: width * 0.45,
        height: height * 0.8,
        color: Colors.orange,
        child: TextButton.icon(
            onPressed: () {
              setState(() {
                viewComment = !viewComment;
                
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
        int optionIndex, int voteCount) {
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
              Text(
                optionText + " " + voteCount.toString(),
                style: TextStyle(fontFamily: 'Leto', fontSize: fontSize),
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
        int pollCount) {
      double fontSize = width * 0.03;

      return (Container(
        color: Color(0xfff7f7f7),
        width: width * 0.8,
        child: ElevatedButton(
          child: Text(optionText,
              style: TextStyle(fontFamily: 'Leto', fontSize: fontSize)),
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.black, primary: Color(0xfff7f7f7)),
          onPressed: () async {
            // Call Rest API to register vote
            setState(() {
              recordVote(widget.pollId, optionIndex, optionText);
              getPollResult(widget.pollId);
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
        height: height * 0.9,
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
        height: height * 0.9,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: toList(() sync* {
            if (convertdata['optionCount'] == 2) {
              yield _createPollOption(
                  width, height, convertdata['option1'], 1, option1);
              yield _createPollOption(
                  width, height, convertdata['option2'], 2, option2);
            } else if (convertdata['optionCount'] == 3) {
              yield _createPollOption(
                  width, height, convertdata['option1'], 1, option1);
              yield _createPollOption(
                  width, height, convertdata['option2'], 2, option2);
              yield _createPollOption(
                  width, height, convertdata['option3'], 3, option3);
            } else if (convertdata['optionCount'] == 4) {
              yield _createPollOption(
                  width, height, convertdata['option1'], 1, option1);
              yield _createPollOption(
                  width, height, convertdata['option2'], 2, option2);
              yield _createPollOption(
                  width, height, convertdata['option3'], 3, option3);
              yield _createPollOption(
                  width, height, convertdata['option4'], 4, option4);
            }
          }),
        ),
      );
    }

    Container _createMiddleSection(double width, double height) {
      Widget _PollSection;

      if (isVoted) {
        _PollSection = _createVotedSection(width, height * 0.8);
      } else {
        _PollSection = _createPollSection(width, height * 0.8);
      }

      return Container(
        width: width,
        height: height,
        color: Color(0xfff4f4f4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_createQuestionText(width, height * 0.2), _PollSection],
        ),
      );
    }

    Container _createBottomSection(double width, double height) {
      return Container(
        width: width,
        height: height,
        color: Colors.blueGrey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _createCommentButton(width, height),
            _createShareButton(width, height)
          ],
        ),
      );
    }

    Container _buildDesktopView(double width, double height) {
      return (Container(
        width: width,
        height: height,
        color: Colors.red,
        child: Card(
            child: Column(
          children: [
            _createTopSection(width, height * 0.402),
            _createMiddleSection(width, height * 0.5355),
            _createBottomSection(width, height * 0.1)
          ],
        )),
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
