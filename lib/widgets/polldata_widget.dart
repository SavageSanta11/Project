import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'polls.dart';

// ignore: camel_case_types

GlobalKey key = GlobalKey();

typedef void BoolCallback(bool viewComment);

Widget selectedCard = SizedBox();

class polldata_widget extends StatefulWidget {
  final String previewUrl;
  final String pollTitle;
  final String username;
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
      required this.optionsLength, required this.options})
      : super(key: key);

  @override
  _polldata_widgetState createState() => _polldata_widgetState();
}

// ignore: camel_case_types
class _polldata_widgetState extends State<polldata_widget> {
  double option1 = 1.0;
  double option2 = 0.0;
  double option3 = 1.0;
  double option4 = 1.0;

  String previewImgUrl =
      "https://img.etimg.com/thumb/msid-75572296,width-640,resizemode-4,imgsize-507941/bmw-ninet.jpg";

  String username = "SURESH GOPI";
  int votes = 13;
  String questionText = "Bangalore's metro is quite useless";
  int time = 3;

  String user = "king@mail.com";
  Map usersWhoVoted = {
    'sam@mail.com': 3,
    'mike@mail.com': 4,
    'john@mail.com': 1,
    'kenny@mail.com': 1
  };
  String creator = "eddy@mail.com";

  List<String> pollOptions = ["Option1", "Option2", "Option3"];

  bool viewComment = false;
  @override
  Widget build(BuildContext context) {
    Container _createShareButton(double width, double height, bool isWeb) {
      return (Container(
        width: isWeb ? width * 0.4 : width * 0.4,
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
          onPressed: () {},
        ),
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
                        image: NetworkImage(
                            "https://files.worldwildlife.org/wwfcmsprod/images/Tiger_resting_Bandhavgarh_National_Park_India/hero_small/6aofsvaglm_Medium_WW226365.jpg"),
                        fit: BoxFit.cover),
                  )),
              Padding(
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 0),
                child: Text(
                  widget.username,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: isWeb ? 14.0 : 12.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Container(
                  height: height * 0.5,
                  child: Polls(
                    isWeb: isWeb,
                    children: [
                      // This cannot be less than 2, else will throw an exception
                      Polls.options(title: widget.options['option_1'], value: option1),
                      Polls.options(title: widget.options['option_2'], value: option2),
                      Polls.options(title: widget.options['option_3'], value: option3),
                      Polls.options(title: widget.options['option_4'], value: option4),
                      
                    ],
                    question: Text(
                      widget.question,
                      style: GoogleFonts.lato(
                          fontSize: isWeb ? 22.0 : 18.0,
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
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 0, 10),
                child: Row(
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          setState(() {
                            viewComment = !viewComment;
                          });
                          widget.onViewcomment(viewComment);
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
      pollcard = _getCardData(width * 0.25, height * 0.8, isWeb);
    } else {
      isWeb = false;
      pollcard = _getCardData(width * 0.95, height * 0.85, isWeb);
    }

    return pollcard;
  }
}
