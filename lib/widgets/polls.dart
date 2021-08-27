library polls;

import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> recordVote(String poll_id, int optionNo, String optionText) async {
  var headers = {
    'Authorization':
        'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTQzMjgwMSwianRpIjoiNjhlNmU0OGUtNmFmNS00ZDhlLTgzMTItMDdiODgzMjRhM2Y1IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTQzMjgwMSwiZXhwIjoxNjI5NDMzNzAxfQ.9-RgnOEkhbA28A22h_tu_6J_syc2YqHYR9rQ1M1NVYE',
    'Content-Type': 'application/json'
  };
  
  String body = json.encode(<String, dynamic>{
    "poll_id": poll_id,
    "opt_num": optionNo,
    "opt_text": optionText
  });

  http.Response response = await http.post(
      Uri.parse('http://164.52.212.151:3012/api/access/record/vote'),
      headers: headers,
      body: body);

  var convertDataToJson = json.decode(response.body);
  print(convertDataToJson);
}

typedef void PollCallBack(int choice);

typedef void PollTotal(int total);

late int userPollChoice;

class Polls extends StatefulWidget {

  final bool isWeb;
  /// this takes the question on the poll
  final Text question;

  ///this determines what type of view user should see
  ///if its creator, or view requiring you to vote or view showing your vote
  final PollsType? viewType;

  ///this takes in vote data which should be a Map
  /// with this, polls widget determines what type of view the user should see
  final Map? voteData;

  final String? currentUser;

  final String? creatorID;

  /// this takes in poll options array
  final List children;

  /// this call back returns user choice after voting
  final PollCallBack? onVote;

  /// this is takes in current user choice
  final int? userChoice;

  /// this determines if the creator of the poll can vote or not
  final bool allowCreatorVote;

  /// this returns total votes casted
  final PollTotal? getTotal;

  /// this returns highest votes casted
  final PollTotal? getHighest;

  @protected
  final double? highest;

  /// style

  ///colors setting for polls widget
  final Color outlineColor;
  final Color backgroundColor;
  final Color? onVoteBackgroundColor;
  final Color? iconColor;
  final Color? leadingBackgroundColor;

  /// Polls contruct by default get view for voting
  Polls({
    required this.children,
    required this.question,
    required this.voteData,
    required this.currentUser,
    required this.creatorID,
    this.userChoice,
    this.allowCreatorVote = false,
    this.onVote,
    this.outlineColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.onVoteBackgroundColor = Colors.blue,
    this.iconColor = Colors.black,
    this.leadingBackgroundColor = Colors.white, required this.isWeb,
  })  : highest = null,
        getHighest = null,
        getTotal = null,
        viewType = null,
        assert(onVote != null),
        // ignore: unnecessary_null_comparison
        assert(question != null),
        // ignore: unnecessary_null_comparison
        assert(children != null),
        assert(voteData != null),
        assert(currentUser != null),
        assert(creatorID != null);

  /// Polls.option is used to set polls options
  static List options({required String title, required double value}) {
    // ignore: unnecessary_null_comparison
    if (title != null && value != null) {
      return [title, value];
    } else {
      throw 'Poll Option(title or Value is equal to )';
    }
  }

  /// this creates view for see polls result
  Polls.viewPolls(
      {required this.children,
      required this.question,
      this.userChoice,
      this.backgroundColor = Colors.blue,
      this.leadingBackgroundColor = Colors.blueAccent,
      this.onVoteBackgroundColor,
      this.iconColor = Colors.black, required this.isWeb})
      : allowCreatorVote = false,
        getTotal = null,
        highest = null,
        voteData = null,
        currentUser = null,
        creatorID = null,
        getHighest = null,
        outlineColor = Colors.transparent,
        viewType = PollsType.readOnly,
        onVote = null,
        // ignore: unnecessary_null_comparison
        assert(children != null),
        // ignore: unnecessary_null_comparison
        assert(question != null);

  /// This creates view for the creator of the polls
  Polls.creator(
      {required this.children,
      required this.question,
      this.backgroundColor = Colors.blue,
      this.leadingBackgroundColor = Colors.blueAccent,
      this.onVoteBackgroundColor = Colors.white,
      this.allowCreatorVote = false, required this.isWeb})
      : viewType = PollsType.creator,
        onVote = null,
        userChoice = null,
        highest = null,
        getHighest = null,
        voteData = null,
        currentUser = null,
        creatorID = null,
        getTotal = null,
        iconColor = null,
        outlineColor = Colors.transparent,
        // ignore: unnecessary_null_comparison
        assert(children != null),
        // ignore: unnecessary_null_comparison
        assert(question != null);

  /// this creates view for users to cast votes
  Polls.castVote({
    required this.children,
    required this.question,
    required this.onVote,
    this.allowCreatorVote = false,
    this.outlineColor = Colors.blue,
    this.backgroundColor = Colors.white, required this.isWeb,
  })  : viewType = PollsType.voter,
        userChoice = null,
        highest = null,
        getHighest = null,
        getTotal = null,
        iconColor = null,
        voteData = null,
        currentUser = null,
        creatorID = null,
        leadingBackgroundColor = null,
        onVoteBackgroundColor = null,
        assert(onVote != null),
        // ignore: unnecessary_null_comparison
        assert(question != null),
        // ignore: unnecessary_null_comparison
        assert(children != null);

  @override
  _PollsState createState() => _PollsState();
}

class _PollsState extends State<Polls> {
  /// c1 stands for choice 1
  @protected
  late String c1;

  /// c2 stands for choice 2
  @protected
  late String c2;

  /// c3 stands for choice 3
  @protected
  late String c3;

  /// c4 stands for choice 4
  @protected
  late String c4;

  /// c3 stands for choice 5
 

  /// v1 stands for value 1
  @protected
  late double v1;

  /// v2 stands for value 2
  @protected
  late double v2;

  @protected
  double? v3;

  @protected
  double? v4;

 
  /// user choices
  String choice1Title = '';

  String choice2Title = '';

  String choice3Title = '';

  String choice4Title = '';

  
  double choice1Value = 0.0;

  double choice2Value = 0.0;

  double choice3Value = 0.0;

  double choice4Value = 0.0;

  

  /// style
  late TextStyle pollStyle;
  late TextStyle leadingPollStyle;

  ///colors setting for polls widget
  Color? outlineColor;
  Color? backgroundColor;
  Color? onVoteBackgroundColor;
  Color? iconColor;
  Color? leadingBackgroundColor;

  late double highest;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    /// if polls style is null, it sets default pollstyle and leading pollstyle

    /// choice values are set from children
    this.choice1Value = widget.children[0][1];
    this.choice1Title = widget.children[0][0];
    this.v1 = widget.children[0][1];
    this.c1 = widget.children[0][0];

    this.choice2Value = widget.children[1][1];
    this.choice2Title = widget.children[1][0];
    this.v2 = widget.children[1][1];
    this.c2 = widget.children[1][0];

    if (widget.children.length > 2) {
      this.choice3Value = widget.children[2][1];
      this.choice3Title = widget.children[2][0];
      this.v3 = widget.children[2][1];
      this.c3 = widget.children[2][0];
    }

    if (widget.children.length > 3) {
      this.choice4Value = widget.children[3][1];
      this.choice4Title = widget.children[3][0];
      this.v4 = widget.children[3][1];
      this.c4 = widget.children[3][0];
    }

    
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewType == null) {
      var viewType = (widget.voteData?.containsKey(widget.currentUser) ?? false)
          ? PollsType.readOnly
          : widget.currentUser == widget.creatorID
              ? PollsType.creator
              : PollsType.voter;
      if (viewType == PollsType.voter) {
        //user can cast vote with this widget
        return voterWidget(context);
      }
      if (viewType == PollsType.creator) {
        //mean this is the creator of the polls and cannot vote
        if (widget.allowCreatorVote) {
          return voterWidget(context);
        }
        return pollCreator(context);
      }

      if (viewType == PollsType.readOnly) {
        //user can view his votes with this widget
        return voteCasted(context);
      }
    } else {
      if (widget.viewType == PollsType.voter) {
        //user can cast vote with this widget
        return voterWidget(context);
      }
      if (widget.viewType == PollsType.creator) {
        //mean this is the creator of the polls and cannot vote
        if (widget.allowCreatorVote) {
          return voterWidget(context);
        }
        return pollCreator(context);
      }

      if (widget.viewType == PollsType.readOnly) {
        //user can view his votes with this widget
        return voteCasted(context);
      }
    }
    return Container();
  }

  /// voterWidget creates view for users to cast their votes
  Widget voterWidget(context) {
    
    return ListView(
      
      children: <Widget>[
        widget.question,
        Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                     "14 votes",
                    style: GoogleFonts.lato(
                      fontSize:widget.isWeb? 14.0 : 12.0,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Text(
                   "3 hours left",
                    style: GoogleFonts.lato(
                      fontSize: widget.isWeb ? 14.0 : 12.0,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
        SizedBox(
          height: 12,
        ),
        Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                margin: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(0),
                height: widget.isWeb? 40 : 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: widget.backgroundColor,
                ),
                // ignore: deprecated_member_use
                child: OutlineButton(
                  onPressed: () {
                    setState(() {
                      userPollChoice = 1;
                    });
                    recordVote('yjhhonw', userPollChoice, this.c1);
                    widget.onVote!(userPollChoice);
                  },
                  color: Colors.green,
                  padding: EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(this.c1,
                          style: GoogleFonts.lato(
                            fontSize: widget.isWeb ? 16.0 : 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  borderSide: BorderSide(
                    color: widget.outlineColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(6.0),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
               height: widget.isWeb? 40 : 35,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: widget.backgroundColor,
                ),
                // ignore: deprecated_member_use
                child: OutlineButton(
                  onPressed: () {
                    setState(() {
                      userPollChoice = 2;
                    });
                    recordVote('yjhhonw', userPollChoice, this.c2);
                    widget.onVote!(userPollChoice);
                  },
                  color: Colors.green,
                  padding: EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(this.c2,
                          style: GoogleFonts.lato(
                              fontSize: widget.isWeb ? 16.0 : 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  borderSide: BorderSide(
                    color: widget.outlineColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(6.0),
                  ),
                ),
              ),
            ),
            this.c3 != null
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      height: widget.isWeb? 40 : 35,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: widget.backgroundColor,
                      ),
                      // ignore: deprecated_member_use
                      child: OutlineButton(
                        onPressed: () {
                          setState(() {
                            userPollChoice = 3;
                          });
                          recordVote('yjhhonw', userPollChoice, this.c3);
                          widget.onVote!(userPollChoice);
                        },
                        color: Colors.green,
                        padding: EdgeInsets.all(5.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: Text(this.c3 ,
                                style: GoogleFonts.lato(
                                    fontSize: widget.isWeb ? 16.0 : 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        borderSide: BorderSide(
                          color: widget.outlineColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                  )
                : Offstage(),
            this.c4 != null
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      height: widget.isWeb? 40 : 35,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: widget.backgroundColor,
                      ),
                      // ignore: deprecated_member_use
                      child: OutlineButton(
                        onPressed: () {
                          setState(() {
                            userPollChoice = 4;
                          });
                          recordVote('yjhhonw', userPollChoice, this.c4);
                          widget.onVote!(userPollChoice);
                        },
                        color: Colors.green,
                        padding: EdgeInsets.all(5.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: Text(this.c4 ,
                                style: GoogleFonts.lato(
                                    fontSize: widget.isWeb ? 16.0 : 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        borderSide: BorderSide(
                          color: widget.outlineColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                  )
                : Offstage(),
            
          ],
        )
      ],
    );
  }

  /// pollCreator creates view for the creator of the polls,
  /// to see poll activities
  Widget pollCreator(context) {
    var sortedKeys = [
      this.v1,
      this.v2,
      this.v3,
      this.v4,
      
    ];

    double current = 0;

    for (var i = 0; i < sortedKeys.length; i++) {
      if (sortedKeys[i] != null) {
        double s = double.parse(sortedKeys[i].toString());

        if ((sortedKeys[i] ?? 0) >= current) {
          current = s;
        }
      }
    }

    this.highest = current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.question,
        SizedBox(
          height: 12,
        ),
        Container(
          margin: EdgeInsets.all(0),
          width: double.infinity,
          child: LinearPercentIndicator(
              backgroundColor: Color(0xffedf0f3),
              animation: true,
              lineHeight: widget.isWeb? 40 : 35.0,
              animationDuration: 500,
              percent: PollMath.getPerc(this.v1, this.v2, this.v3, this.v4,
                  1)[0],
              center: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(this.c1,
                            style: GoogleFonts.lato(
                                fontSize: widget.isWeb ? 16.0 : 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Text(
                        PollMath.getMainPerc(this.v1, this.v2, this.v3, this.v4,
                                    1)
                                .toString() +
                            "%",
                        style: GoogleFonts.lato(
                            fontSize: widget.isWeb ? 16.0 : 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: this.highest == this.v1
                  ? widget.leadingBackgroundColor
                  : widget.onVoteBackgroundColor),
        ),
        Container(
          margin: EdgeInsets.all(0),
          width: double.infinity,
          child: LinearPercentIndicator(
//              width: MediaQuery.of(context).size.width,
              backgroundColor: Color(0xffedf0f3),
              animation: true,
              lineHeight: widget.isWeb? 40 : 35.0,
              animationDuration: 500,
              percent: PollMath.getPerc(this.v1, this.v2, this.v3, this.v4,
                 2)[0],
              center: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(this.c2,
                            style: GoogleFonts.lato(
                                fontSize: widget.isWeb ? 16.0 : 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Text(
                        PollMath.getMainPerc(this.v1, this.v2, this.v3, this.v4,
                                    2)
                                .toString() +
                            "%",
                        style: GoogleFonts.lato(
                            fontSize: widget.isWeb ? 16.0 : 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: this.highest == this.v2
                  ? widget.leadingBackgroundColor
                  : widget.onVoteBackgroundColor),
        ),
        this.c3 != null
            ? Container(
                margin: EdgeInsets.all(0),
                width: double.infinity,
                child: LinearPercentIndicator(
                    backgroundColor: Color(0xffedf0f3),
//              width: MediaQuery.of(context).size.width,

                    animation: true,
                    lineHeight: widget.isWeb? 40 : 35.0,
                    animationDuration: 500,
                    percent: PollMath.getPerc(this.v1, this.v2, this.v3,
                        this.v4, 3)[0],
                    center: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(this.c3 ,
                                  style: GoogleFonts.lato(
                                      fontSize: widget.isWeb ? 16.0 : 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Text(
                              PollMath.getMainPerc(
                                          this.v1,
                                          this.v2,
                                          this.v3,
                                          this.v4,
                                         
                                          3)
                                      .toString() +
                                  "%",
                              style: GoogleFonts.lato(
                                  fontSize: widget.isWeb ? 16.0 : 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    linearStrokeCap: LinearStrokeCap.butt,
                    progressColor: this.highest == this.v3
                        ? widget.leadingBackgroundColor
                        : widget.onVoteBackgroundColor),
              )
            : Offstage(),
        this.c4 != null
            ? Container(
                margin: EdgeInsets.all(0),
                width: double.infinity,
                child: LinearPercentIndicator(
                    backgroundColor: Color(0xffedf0f3),
                    animation: true,
                    lineHeight: widget.isWeb? 40 : 35.0,
                    animationDuration: 500,
                    percent: PollMath.getPerc(this.v1, this.v2, this.v3, this.v4,
                        4)[0],
                    center: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(this.c4.toString(),
                                  style: GoogleFonts.lato(
                                      fontSize: widget.isWeb ? 16.0 : 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Text(
                              PollMath.getMainPerc(
                                          this.v1,
                                          this.v2,
                                          this.v3,
                                          this.v4,
                                          
                                          4)
                                      .toString() +
                                  "%",
                              style: GoogleFonts.lato(
                                  fontSize: widget.isWeb ? 16.0 : 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    linearStrokeCap: LinearStrokeCap.butt,
                    progressColor: this.highest == this.v4
                        ? widget.leadingBackgroundColor
                        : widget.onVoteBackgroundColor),
              )
            : Offstage(),
        
      ],
    );
  }

  /// voteCasted created view for user to see votes they casted including other peoples vote
  Widget voteCasted(context) {
    /// Fix by AksharPrasanna
    this.v1 = widget.children[0][1];
    this.v2 = widget.children[1][1];
    if (this.c3 != null) this.v3 = widget.children[2][1];
    if (this.c4 != null) this.v4 = widget.children[3][1];
    

    var sortedKeys = [
      this.v1,
      this.v2,
      this.v3,
      this.v4,
      
    ];
    double current = 0;
    for (var i = 0; i < sortedKeys.length; i++) {
      if (sortedKeys[i] != null) {
        double s = double.parse(sortedKeys[i].toString());
        if ((sortedKeys[i] ?? 0) >= current) {
          current = s;
        }
      }
    }
    this.highest = current;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.question,
        SizedBox(
          height: 12,
        ),
        Container(
          
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          width: double.infinity,
          child: LinearPercentIndicator(
            
            backgroundColor: Color(0xffedf0f3),
            animation: true,
            lineHeight: widget.isWeb? 40 : 35.0,
            animationDuration: 500,
            percent: PollMath.getPerc(this.v1, this.v2, this.v3, this.v4, 1)[0],
            center: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text(this.c1.toString(),
                          style: GoogleFonts.lato(
                              fontSize: widget.isWeb ? 16.0 : 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    myOwnChoice(widget.userChoice == 1)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(
                      PollMath.getMainPerc(this.v1, this.v2, this.v3, this.v4,
                                   1)
                              .toString() +
                          "%",
                      style: GoogleFonts.lato(
                          fontSize: widget.isWeb ? 16.0 : 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            linearStrokeCap: LinearStrokeCap.butt,
            progressColor: this.highest == this.v1
                ? widget.leadingBackgroundColor
                : widget.onVoteBackgroundColor,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          width: double.infinity,
          child: LinearPercentIndicator(
            backgroundColor: Color(0xffedf0f3),
//              width: MediaQuery.of(context).size.width,
            animation: true,
            lineHeight: widget.isWeb? 40 : 35.0,
            animationDuration: 500,
            percent: PollMath.getPerc(this.v1, this.v2, this.v3, this.v4,
                 2)[0],
            center: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text(this.c2.toString(),
                          style: GoogleFonts.lato(
                              fontSize: widget.isWeb ? 16.0 : 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    myOwnChoice(widget.userChoice == 2)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(
                      PollMath.getMainPerc(this.v1, this.v2, this.v3, this.v4,
                                   2)
                              .toString() +
                          "%",
                      style: GoogleFonts.lato(
                          fontSize: widget.isWeb ? 16.0 : 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            linearStrokeCap: LinearStrokeCap.butt,
            progressColor: this.highest == this.v2
                ? widget.leadingBackgroundColor
                : widget.onVoteBackgroundColor,
          ),
        ),
        this.c3 == null
            ? Offstage()
            : Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                width: double.infinity,
                child: LinearPercentIndicator(
                  backgroundColor: Color(0xffedf0f3),
//              width: MediaQuery.of(context).size.width,
                  animation: true,
                  lineHeight: widget.isWeb? 40 : 35.0,
                  animationDuration: 500,
                  percent: PollMath.getPerc(this.v1, this.v2, this.v3, this.v4,
                       3)[0],
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(this.c3.toString(),
                                style: GoogleFonts.lato(
                                    fontSize: widget.isWeb ? 16.0 : 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          myOwnChoice(widget.userChoice == 3)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Text(
                            PollMath.getMainPerc(
                                        this.v1,
                                        this.v2,
                                        this.v3,
                                        this.v4,
                                        
                                        3)
                                    .toString() +
                                "%",
                            style: GoogleFonts.lato(
                                fontSize: widget.isWeb ? 16.0 : 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  linearStrokeCap: LinearStrokeCap.butt,
                  progressColor: this.highest == this.v3
                      ? widget.leadingBackgroundColor
                      : widget.onVoteBackgroundColor,
                ),
              ),
        this.c4 == null
            ? Offstage()
            : Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                width: double.infinity,
                child: LinearPercentIndicator(
                  backgroundColor: Color(0xffedf0f3),
//              width: MediaQuery.of(context).size.width,
                  animation: true,
                  lineHeight: widget.isWeb? 40 : 35.0,
                  animationDuration: 500,
                  percent: PollMath.getPerc(this.v1, this.v2, this.v3, this.v4,
                      4)[0],
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(this.c4.toString(),
                                style: GoogleFonts.lato(
                                    fontSize: widget.isWeb ? 16.0 : 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          myOwnChoice(widget.userChoice == 4)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Text(
                            PollMath.getMainPerc(
                                        this.v1,
                                        this.v2,
                                        this.v3,
                                        this.v4,
                                       
                                        4)
                                    .toString() +
                                "%",
                            style: GoogleFonts.lato(
                                fontSize: widget.isWeb ? 16.0 : 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  linearStrokeCap: LinearStrokeCap.butt,
                  progressColor: this.highest == this.v4
                      ? widget.leadingBackgroundColor
                      : widget.onVoteBackgroundColor,
                ),
              ),
       
      ],
    );
  }

  /// simple logic to detect users choice and return a check icon
  Widget myOwnChoice(choice) {
    if (choice) {
      return Container();
    } else {
      return Container();
    }
  }
}

/// Help detect type of view user wants
enum PollsType {
  creator,
  voter,
  readOnly,
}

/// does the maths for Polls
class PollMath {
  static getMainPerc(v1, v2, v3, v4, choice) {
    var div;
    var slot1res = v1;
    var slot2res = v2;
    var slot3res = v3 == null ? 0.0 : v3;
    var slot4res = v4 == null ? 0.0 : v4;
   

    if (choice == 1) {
      var sum = slot1res +
          slot2res +
          slot3res +
          slot4res ;
      div = div = sum == 0 ? 0 : (100 / sum) * slot1res;
    }
    if (choice == 2) {
      var sum = slot1res +
          slot2res +
          slot3res +
          slot4res ;
      div = div = sum == 0 ? 0 : (100 / sum) * slot2res;
    }
    if (choice == 3) {
      var sum = slot1res +
          slot2res +
          slot3res +
          slot4res ;
      div = div = sum == 0 ? 0 : (100 / sum) * slot3res;
    }
    if (choice == 4) {
      var sum = slot1res +
          slot2res +
          slot3res +
          slot4res ;
      div = div = sum == 0 ? 0 : (100 / sum) * slot4res;
    }
    

    return div == 0 ? 0 : div.round();
  }

  static List getPerc(v1, v2, v3, v4,  choice) {
    var div;
    var slot1res = v1;
    var slot2res = v2;
    var slot3res = v3 == null ? 0.0 : v3;
    var slot4res = v4 == null ? 0.0 : v4;
    
    if (choice == 1) {
      var sum = slot1res +
          slot2res +
          slot3res +
          slot4res ;
      // ignore: empty_statements
      ;
      div = sum == 0 ? 0 : (1 / sum) * slot1res;
    }
    if (choice == 2) {
      var sum = slot1res +
          slot2res +
          slot3res +
          slot4res ;
      div = sum == 0 ? 0 : (1 / sum) * slot2res;
    }
    if (choice == 3) {
      var sum = slot1res +
          slot2res +
          slot3res +
          slot4res ;
      div = sum == 0 ? 0 : (1 / sum) * slot3res;
    }
    if (choice == 4) {
      var sum = slot1res +
          slot2res +
          slot3res +
          slot4res ;
      div = sum == 0 ? 0 : (1 / sum) * slot4res;
    }

    
    return [div == 0 ? 0.0 : div.toDouble(), div];
  }
}
