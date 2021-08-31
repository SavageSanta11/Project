import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'polls.dart';

GlobalKey _keyRed = GlobalKey();

double option1 = 1.0;
double option2 = 1.0;
double option3 = 1.0;
double option4 = 1.0;

String user = "king@mail.com";
Map usersWhoVoted = {};
String creator = "eddy@mail.com";

class SampleWidget extends StatefulWidget {
  const SampleWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SampleWidgetState createState() => _SampleWidgetState();
}

class _SampleWidgetState extends State<SampleWidget> {
  @override
  Widget build(BuildContext context) {
    Container _createShareButton(double width, double height) {
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
                  fontSize: 16.0 ,
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
    Widget card(double width, double height) {
      return Container(
        height: height,
        width: width,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: ListView(
            children: [
              Container(
                height: height * 0.5,
                width: width,
                child: Image.network(
                  "https://i.natgeofe.com/n/6490d605-b11a-4919-963e-f1e6f3c0d4b6/sumatran-tiger-thumbnail-nationalgeographic_1456276.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: height * 0.03,
                  width: width,
                  child: Text('username'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  height:height * 0.4,
                  
                  child: Polls(
                    isWeb: true,
                    children: [
                      Polls.options(title: "apple", value: option1),
                      Polls.options(title: "mango", value: option2),
                      Polls.options(title: "watermelon", value: option3),
                      Polls.options(title: "strawberry", value: option4),
                    ],
                    question: Text(
                      "what's your favourite fruit",
                      style: GoogleFonts.lato(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    currentUser: user,
                    creatorID: creator,
                    voteData: usersWhoVoted,
                    userChoice: usersWhoVoted[user],
                    onVoteBackgroundColor: Color(0xffe4ccc0),
                    leadingBackgroundColor: Color(0xff8ed0e0),
                    backgroundColor: Color(0xffedf0f3),
                    outlineColor: Color(0xffedf0f3),
                    onVote: (choice) {
                      setState(() {
                        usersWhoVoted[user] = choice;
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
                padding: const EdgeInsets.all(8.0),
                child: Container(height: height*0.05,width: width,child: _createShareButton(width, height),),
              )
            ],
          ),
        ),
      );
    }

     double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return card(width*0.27, height*0.8);
  }
}
