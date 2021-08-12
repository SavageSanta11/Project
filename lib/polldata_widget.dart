import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'polls.dart';

class polldata_widget extends StatefulWidget {
  const polldata_widget({Key? key}) : super(key: key);

  @override
  _polldata_widgetState createState() => _polldata_widgetState();
}

class _polldata_widgetState extends State<polldata_widget> {
  double option1 = 1.0;
  double option2 = 0.0;
  double option3 = 1.0;

  String previewImgUrl =
      "https://img.etimg.com/thumb/msid-75572296,width-640,resizemode-4,imgsize-507941/bmw-ninet.jpg";

  String username = "SURESH GOPI";
  int votes = 13;
  String questionText = "Who am I?";
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
  @override
  Widget build(BuildContext context) {
    Container _createShareButton(double width, double height) {
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
          child: Text('Share', style: TextStyle(fontFamily: 'Leto')),
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            primary: Color(0xff092836),
          ),
          onPressed: () {},
        ),
      ));
    }

    Card _getCardDataWeb(double width, double height) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
                height: height * 0.3,
                width: width * 0.25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(previewImgUrl), fit: BoxFit.cover),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 8),
              child: Text(
                username,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14.0,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 8),
                  child: Text(
                    votes.toString() + " votes",
                    style: GoogleFonts.lato(fontSize: 16.0, color: Colors.blueGrey,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 8),
                  child: Text(
                    time.toString() + " hours left",
                    style: GoogleFonts.lato(fontSize: 16.0, color: Colors.blueGrey,),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Polls(
                children: [
                  // This cannot be less than 2, else will throw an exception
                  Polls.options(title: 'I', value: option1),
                  Polls.options(title: 'Me', value: option2),
                  Polls.options(title: 'Myself', value: option3),
                ],
                question: Text(
                  questionText,
                  style: GoogleFonts.lato(fontSize: 24.0, color: Colors.black,fontWeight: FontWeight.bold),
                ),
                currentUser: this.user,
                creatorID: this.creator,
                voteData: usersWhoVoted,
                userChoice: usersWhoVoted[this.user],
                onVoteBackgroundColor: Colors.blue,
                leadingBackgroundColor: Colors.blue,
                backgroundColor: Colors.white,
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
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: _createShareButton(width*0.25, height*0.05),
            )
          ],
        ),
      );
    }

    Card _getCardDataMobile(double width, double height) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
                height: height * 0.3,
                width: width * 0.95,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(previewImgUrl), fit: BoxFit.cover),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 0, 8),
              child: Text(
                username,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14.0,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 8),
                  child: Text(
                    votes.toString() + " votes",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 14.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 8),
                  child: Text(
                    time.toString() + " hours left",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 14.0),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Polls(
                  children: [
                    // This cannot be less than 2, else will throw an exception
                    Polls.options(title: 'I', value: option1),
                    Polls.options(title: 'Me', value: option2),
                    Polls.options(title: 'Myself', value: option3),
                  ],
                  question: Text(
                    questionText,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  currentUser: this.user,
                  creatorID: this.creator,
                  voteData: usersWhoVoted,
                  userChoice: usersWhoVoted[this.user],
                  onVoteBackgroundColor: Colors.blue,
                  leadingBackgroundColor: Colors.blue,
                  backgroundColor: Colors.white,
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
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: _createShareButton(width*0.95, height*0.1),
            )
          ],
        ),
      );
    }

    Widget pollcard;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
      pollcard = _getCardDataWeb(width, height);
    } else {
      pollcard = _getCardDataMobile(width, height);
    }

    return Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: pollcard);
  }
}
