import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'polls.dart';


// ignore: camel_case_types
class polldata_widget extends StatefulWidget {
  const polldata_widget({Key? key}) : super(key: key);

  @override
  _polldata_widgetState createState() => _polldata_widgetState();
}

// ignore: camel_case_types
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
    Container _createShareButton(double width, double height, bool isWeb) {
      return (Container(
        width: isWeb ? width * 0.25 : width * 0.95,
        height: height * 0.05,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        child: OutlinedButton(
          child: Text('SHARE', style: GoogleFonts.lato(
                      fontSize: isWeb? 16.0 : 14.0,
                      color: Color(0xff092836),
                    ),),
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

    Container _createJoinButton(double width, double height, bool isWeb) {
      return (Container(
        width: isWeb ? width * 0.25 : width * 0.95,
        height: height * 0.05,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        child: ElevatedButton(
          child: Text("JOIN NOW",
              style: GoogleFonts.lato(
                fontSize: 16.0,
                color: Color(0xff092836),
              )),
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            primary: Colors.white,
          ),
          onPressed: () {},
        ),
      ));
    }

    Card _getCardData(double width, double height, bool isWeb) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
                height: height * 0.3,
                width: isWeb ? width * 0.25 : width * 0.95,
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
                  fontSize: isWeb? 16.0 : 14.0,
                  
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 8),
                  child: Text(
                    votes.toString() + " votes",
                    style: GoogleFonts.lato(
                      fontSize: isWeb? 16.0 : 14.0,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 8),
                  child: Text(
                    time.toString() + " hours left",
                    style: GoogleFonts.lato(
                      fontSize: isWeb? 16.0 : 14.0,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Polls(
                children: [
                  // This cannot be less than 2, else will throw an exception
                  Polls.options(title: 'I', value: option1),
                  Polls.options(title: 'Me', value: option2),
                  Polls.options(title: 'Myself', value: option3),
                ],
                question: Text(
                  questionText,
                  style: GoogleFonts.lato(
                      fontSize: isWeb? 24.0 : 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                currentUser: this.user,
                creatorID: this.creator,
                voteData: usersWhoVoted,
                userChoice: usersWhoVoted[this.user],
                onVoteBackgroundColor: Color(0xffe4ccc0),
                leadingBackgroundColor: Color(0xff8ed0e0),
                backgroundColor: Color(0xffecf0f3),
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
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
              child: _createShareButton(width, height, isWeb),
            )
          ],
        ),
      );
    }

    // ignore: unused_element
    Container _endingCard(double width, double height, bool isWeb) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 1],
                colors: [Color(0xff8dcdde), Colors.purple])),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Join",
                  style: GoogleFonts.lato(
                    fontSize: isWeb ? 66 : 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "the",
                  style: GoogleFonts.lato(
                     fontSize: isWeb ? 66 : 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  'waitlist',
                  style: GoogleFonts.lato(
                     fontSize: isWeb ? 66 : 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: isWeb? EdgeInsets.fromLTRB(20, 150, 20, 0) :  EdgeInsets.fromLTRB(5, 100, 5, 0),
                child: _createJoinButton(width , height , isWeb),
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
      pollcard = _getCardData(width, height, isWeb);
      isWeb = true;
    } else {
      pollcard = _getCardData(width, height, isWeb);
      isWeb = false;
    }

    return Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
                color: isWeb ? Colors.grey : Color(0xffedf0f3),
                blurRadius: 5.0),
          ],
        ),
        child: _getCardData(width, height, isWeb));
  }
}
