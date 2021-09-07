import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/option_container.dart';


typedef Iterable<T> IterableCallback<T>();

typedef void BoolCallback(bool viewComment, String pollId);

List<T> toList<T>(IterableCallback<T> cb) {
  return List.unmodifiable(cb());
}

class CardPreview extends StatefulWidget {
  final double width;
  final double height;
  String imageUrl ;
  String question;

  CardPreview(this.width, this.height, this.imageUrl, this.question);
  @override
  _CardPreviewState createState() => _CardPreviewState();
}

class _CardPreviewState extends State<CardPreview> {

  @override
  Widget build(BuildContext context) {
    Container _createProfilePicture(double width, double height) {
      return Container(
        width: width,
        height: height ,
        color: Colors.transparent,
        //margin: EdgeInsets.symmetric(vertical: 6),
        child: Image.network(
          widget.imageUrl == "" ? 'https://i.natgeofe.com/n/6490d605-b11a-4919-963e-f1e6f3c0d4b6/sumatran-tiger-thumbnail-nationalgeographic_1456276.jpg' : widget.imageUrl, 
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
              'This is the poll title',
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
          widget.question,
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
        width: width * 0.8,
        child: ElevatedButton(
          child: Text(optionText,
              style: TextStyle(fontFamily: 'Leto', fontSize: fontSize)),
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.black, primary: Color(0xfff7f7f7)),
          onPressed: () async {
            // Call Rest API to register vote
          },
        ),
      ));
    }

    Container _createPollSection(double width, double height) {
      return Container(
        width: width,
        height: height * 0.9,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  toList(() sync* {
            if (optionList.length == 2){
              yield _createPollOption(width, height, optionList[0], 1);
              yield _createPollOption(width, height, optionList[1], 1);
                  
            }
            else if (optionList.length == 3){
              yield _createPollOption(width, height, optionList[0], 1);
              yield _createPollOption(width, height, optionList[1], 1);
              yield _createPollOption(width, height, optionList[2], 1);
                  
            }
            else if (optionList.length == 4){
              yield _createPollOption(width, height, optionList[0], 1);
              yield _createPollOption(width, height, optionList[1], 1);
              yield _createPollOption(width, height, optionList[2], 1);
              yield _createPollOption(width, height, optionList[3], 1);                  
            }
          }
          )
        ),
      );
    }

    Container _createMiddleSection(double width, double height) {
      Widget _PollSection;

      _PollSection = _createPollSection(width, height * 0.75);

      return Container(
        width: width,
        height: height,
        color: Color(0xfff4f4f4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_createQuestionText(width, height * 0.15), _PollSection],
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
