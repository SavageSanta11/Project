import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'polls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore: camel_case_types

getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('token');
  return stringValue;
}

GlobalKey key = GlobalKey();

typedef void BoolCallback(bool viewComment, String pollId);

Widget selectedCard = SizedBox();

class polldata_widget extends StatefulWidget {
  final String previewUrl;
  final String pollTitle;
  final String username;
  final String pollId;
  final String question;
  final int votes;
  final int time;
  final int optionsLength;
  final Map<dynamic, dynamic> options;
  final BoolCallback onViewcomment;

  const polldata_widget(
      {Key? key,
      required this.username,
      required this.question,
      required this.votes,
      required this.time,
      required this.previewUrl,
      required this.pollTitle,
      required this.onViewcomment,
      required this.optionsLength,
      required this.options,
      required this.pollId})
      : super(key: key);

  @override
  _polldata_widgetState createState() => _polldata_widgetState();
}

// ignore: camel_case_types
class _polldata_widgetState extends State<polldata_widget> {
  double option1 = 1.0;
  double option2 = 0.0;
  double option3 = 1.0;
  double option4 = 0.0;

  String user = "king@mail.com";
  Map usersWhoVoted = {};
  String creator = "eddy@mail.com";

  List<dynamic> choices = [];
  List<dynamic> results = [];

  bool viewComment = false;

  Future<void> getPollResult(String poll_id) async {
    String uri =
        'http://164.52.212.151:7002/api/access/poll/result?poll_id=yjhhonw';

    http.Response response = await http.get(
      Uri.parse(uri),
    );

    var convertDataToJson = json.decode(response.body);

    setState(() {
      option1 = convertDataToJson['data']['option_1']['voteCount'].toDouble();
      option2 = convertDataToJson['data']['option_2']['voteCount'];
      option3 = convertDataToJson['data']['option_3']['voteCount'];
      option4 = convertDataToJson['data']['option_4']['voteCount'];
    });
  }

  List<dynamic> buildList() {
    //getPollResult(widget.pollId);

    if (widget.optionsLength == 2) {
      choices.add(
          Polls.options(title: widget.options['option_1'], value: option1));

      choices.add(
          Polls.options(title: widget.options['option_2'], value: option2));
    } else if (widget.optionsLength == 3) {
      choices.add(
          Polls.options(title: widget.options['option_1'], value: option1));
      choices.add(
          Polls.options(title: widget.options['option_2'], value: option2));
      choices.add(
          Polls.options(title: widget.options['option_3'], value: option3));
    } else {
      choices.add(
          Polls.options(title: widget.options['option_1'], value: option1));
      choices.add(
          Polls.options(title: widget.options['option_2'], value: option2));
      choices.add(
          Polls.options(title: widget.options['option_3'], value: option3));
      choices.add(
          Polls.options(title: widget.options['option_4'], value: option4));
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    Container _createShareButton(double width, double height, bool isWeb) {
      return (Container(
        width:  width * 0.4,
        height: height * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        child: OutlinedButton(
            child: Text(
              'SHARE',
              style: GoogleFonts.lato(
                  fontSize: isWeb ? 16.0 : 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              primary: Colors.white,
              side: BorderSide(color: Color(0xff092836), width: 1),
            ),
            onPressed: () async {
      
            }),
      ));
    }

    Container _getCardData(
      double width,
      double height,
      bool isWeb,
    ) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset(2.0, 0),
            ),
          ],
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Container(
                  height: height * 0.5,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.previewUrl),
                        fit: BoxFit.cover),
                  )),
              /*Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 0),
                child: Text(
                  widget.pollTitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isWeb ? 18.0 : 12.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Divider(
                  color: Colors.black,
                  thickness: 3.0,
                ),
              ),*/
              Container(
                height: height*0.03,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                  child: Text(
                    widget.username,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: isWeb ? 0.023*height : 0.0198*height,
                    ),
                  ),
                ),
              ),
              Container(
                height: height * 0.40,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
                  child: Polls(
                   
                    isWeb: isWeb,
                    children: buildList(),
                    question: Text(
                      widget.question,
                      style: GoogleFonts.lato(
                          fontSize: isWeb ? 0.034*height : 0.0298*height ,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    currentUser: this.user,
                    creatorID: this.creator,
                    voteData: usersWhoVoted,
                    userChoice: usersWhoVoted[this.user],
                    onVoteBackgroundColor: Color(0xffe4ccc0),
                    leadingBackgroundColor: Color(0xff8ed0e0),
                    backgroundColor: Color(0xffedf0f3),
                    outlineColor: Color(0xffedf0f3),
                    onVote: (choice) {
                      setState(() {
                        this.usersWhoVoted[this.user] = choice;
                      });
                      if (choice == 1) {
                        setState(() {
                          option1 += 1.0;
                        });
                      }
                      if (choice == 2) {
                        setState(() {
                          option2 += 1.0;
                        });
                      }
                      if (choice == 3) {
                        setState(() {
                          option3 += 1.0;
                        });
                      }
                      if (choice == 4) {
                        setState(() {
                          option4 += 1.0;
                        });
                      }
                    },
                  ),
                ),
              ),
              Container(
                height: height*0.05,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 0, 4),
                  child: Row(
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            setState(() {
                              viewComment = !viewComment;
                            });
                            widget.onViewcomment(viewComment, widget.pollId);
                          },
                          icon: Icon(
                            Icons.comment,
                            color: Colors.black,
                          ),
                          label: Text(
                            '13',
                            style: TextStyle(color: Colors.black),
                          )),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      _createShareButton(width, height, isWeb)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    // ignore: unused_local_variable
    Widget pollcard;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isWeb = false;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
      isWeb = true;
      pollcard = _getCardData(width * 0.26, height * 0.85, isWeb);
    } else {
      isWeb = false;
      pollcard = _getCardData(width * 0.95, height * 0.85, isWeb);
    }

    return pollcard;
  }
}
