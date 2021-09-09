import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  final String pollID;
  final double width;
  final double height;
  const Comments({Key? key, required this.pollID, required this.width, required this.height}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final myController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  String valueText = "";
  String codeDialog = "";
  String value = "";
  String success = "";

  bool isLoaded = true;

  // ignore: non_constant_identifier_names
  List<String> _CommentList = [];

  Future<String> recordComment(String pollID, String text) async {
    var headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTQzMjE5MSwianRpIjoiZTQzYjMyYmQtOGNlNS00ODU4LWFjNjQtOGJlNzBjMGI0MTY5IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTQzMjE5MSwiZXhwIjoxNjI5NDMzMDkxfQ.mMHDB_oBSxnjGK8MYXRGrVw9yV-pajJ8YOi5LLbxdII',
      'Content-Type': 'application/json'
    };
    String body =
        json.encode(<String, String>{"poll_id": pollID, "text": text, "email": "kano@qonway.com"});

    http.Response response = await http.post(
        Uri.parse('http://164.52.212.151:7002/api/access/record/comment'),
        headers: headers,
        body: body);

    var convertDataToJson = json.decode(response.body);
    String success = convertDataToJson["success"];
   
    return success;
  
  }

  void _addComment(String comment) {
    if (comment.length > 0) {
      setState(() => _CommentList.add(comment));
    }
  }

  // ignore: unused_element
  void _removeComment(int index) {
    setState(() => _CommentList.removeAt(index));
  }

  // ignore: non_constant_identifier_names

  // ignore: unused_element
  Widget _buildCommentList(double width, double height) {
    return Container(
      height: height,
      width: width,
      child: new ListView.builder(itemBuilder: (context, index) {
        if (index < _CommentList.length) {
          return Dismissible(
              key: Key(_CommentList[index]),
              onDismissed: (direction) {
                setState(() {
                  _CommentList.removeAt(index);
                });
              },
              child: _buildComment(width, height*0.2,_CommentList[index], index));
        } else {
          return Text('');
        }
      }),
    );
  }

  Widget _buildComment(double width,double height,String comment,int index,) {
    return new Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              '@BombayRocker',
            ),
            SizedBox(
              width: 20.0,
            ),
            Text('16 hours ago'),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(comment),
            SizedBox(
              width: width/20,
            ),
            IconButton(
                icon: Icon(Icons.thumb_up_outlined),
                tooltip: 'Reply',
                onPressed: () {}),
          ],
        ),
        TextButton.icon(
            icon: Icon(
              Icons.reply,
              color: Colors.black,
            ),
            label: Text(
              'Reply',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {}),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    this.showComments(widget.pollID, 5, 1);
  }

  List comments = [];
  String enteredText = "";

  // ignore: non_constant_identifier_names
  Future<void> showComments(String poll_id, int skip, int pageSize) async {
    String uri =
        'http://164.52.212.151:7002/api/access/show/comments?poll_id=' +
            poll_id +
            '&skip=' +
            skip.toString() +
            '&pageSize=' +
            pageSize.toString();

    http.Response response = await http.get(
      Uri.parse(uri),
    );

    var convertDataToJson = json.decode(response.body);
    comments = convertDataToJson['data'];

    for (var i = 0; i < comments.length; i++) {
      _addComment(comments[i]['text']);
    }

    setState(() {
      isLoaded = true;
    });

    print(comments[0]['text']);
   
  }

  Widget build(BuildContext context) {
    Container _createCommentField(double width, double height) {
      return Container(
        width: width,
        height: height,
        child: TextField(
          inputFormatters: [LengthLimitingTextInputFormatter(100)],
          controller: _textFieldController,
          autofocus: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Add a comment'),
          maxLines: 3,

          onChanged: (value) {
            setState(() {
              enteredText = value;
            });
          },

          //autofocus: true,
          onSubmitted: (val) {},
        ),
      );
    }

    Container _createCommentBar(double width, double height) {
      return Container(
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: height,
                  width: width * 0.69,
                  decoration: BoxDecoration(color: Color(0xffececec)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      enteredText.length.toString() + "/100",
                      textAlign: TextAlign.end,
                    ),
                  )),
              Container(
                width: width * 0.3,
                height: height,
                decoration: BoxDecoration(color: Colors.black),
                child: TextButton(
                    child: Text(
                      'Comment',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      success =  await recordComment(widget.pollID, enteredText);
                          if(success == "true")_addComment(enteredText);
                          _textFieldController.clear();
                    }),
              )
            ],
          ));
    }

    Widget commentSection(double width, double height) {
      if (isLoaded) {
        return Container(
          
            height: height,
            width: width,
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              children: [
                _createCommentField(width, height * 0.125),
                _createCommentBar(width, height * 0.035),
                _buildCommentList(width, height * 0.835),
              ],
            ),
          
        );
      } else {
        return Scaffold();
      }
    }

    Widget commentcard;

    double width = widget.width;
    double height = widget.height;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
      commentcard = commentSection(width, height);
    } else {
      commentcard = commentSection(width, height);
    }

    return commentcard;
  }
}
