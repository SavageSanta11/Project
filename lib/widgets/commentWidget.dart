import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Comments()));
}

class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final myController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  String valueText = "";
  String codeDialog = "";
  String value = "";

  bool isLoaded = true;

  List<String> _CommentList = [];

  void _addComment(String comment) {
    if (comment.length > 0) {
      setState(() => _CommentList.add(comment));
    }
  }

  void _removeComment(int index) {
    setState(() => _CommentList.removeAt(index));
  }

  Future<void> recordComment(String poll_id, String text) async {
    var headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTQzMjE5MSwianRpIjoiZTQzYjMyYmQtOGNlNS00ODU4LWFjNjQtOGJlNzBjMGI0MTY5IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTQzMjE5MSwiZXhwIjoxNjI5NDMzMDkxfQ.mMHDB_oBSxnjGK8MYXRGrVw9yV-pajJ8YOi5LLbxdII',
      'Content-Type': 'application/json'
    };
    String body =
        json.encode(<String, String>{"poll_id": poll_id, "text": text});

    http.Response response = await http.post(
        Uri.parse('http://164.52.212.151:3012/api/access/record/comment'),
        headers: headers,
        body: body);

    var convertDataToJson = json.decode(response.body);
    print(convertDataToJson);
  }

  // ignore: unused_element
  Widget _buildCommentList() {
    return new ListView.builder(itemBuilder: (context, index) {
      if (index < _CommentList.length) {
        return Dismissible(
            key: Key(_CommentList[index]),
            onDismissed: (direction) {
              setState(() {
                _CommentList.removeAt(index);
              });
            },
            child: _buildComment(_CommentList[index], index));
      } else {
        return Text('');
      }
    });
  }

  Widget _buildComment(String comment, int index, ) {
    return new Container(
      width: 300.0,
      height: 106.0,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
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
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(comment),
              SizedBox(
                width: 20.0,
              ),
              IconButton(
                  icon: Icon(Icons.thumb_up_outlined),
                  tooltip: 'Reply',
                  onPressed: () {}),
            ],
          ),
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
    this.showComments('yjhhonw', 5, 1);
  }

  List comments = [];
  String enteredText = "";

  Future<void> showComments(String poll_id, int skip, int pageSize) async {
    String uri =
        'http://164.52.212.151:3012/api/access/show/comments?poll_id=' +
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
      _addComment(comments[i]['data']);
    }

    setState(() {
      isLoaded = true;
    });

    print(comments[0]['data']);
    print(convertDataToJson);
  }

  Widget build(BuildContext context) {
    Scaffold commentSection(double height, double width) {
      if (isLoaded) {
        return Scaffold(
          body: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height * 0.15,
                  child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,

                    onChanged: (value) {
                      setState(() {
                        enteredText = value;
                      });
                    },

                    //autofocus: true,
                    onSubmitted: (val) {
                      
                    },
                  ),
                ),
                Row(
                  children: [
                    Container(
                        height: height * 0.04,
                        width: width * 0.75,
                        decoration: BoxDecoration(color: Color(0xffececec)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            enteredText.length.toString() + "/100",
                            textAlign: TextAlign.end,
                          ),
                        )),
                    Container(
                      width: width * 0.245,
                      height: height * 0.04,
                      decoration: BoxDecoration(color: Colors.black),
                      child: TextButton(
                        child: Text(
                          'Comment',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _addComment(enteredText);
                      recordComment('yjhhonw', enteredText);
                      _textFieldController.clear();
                        },
                      ),
                    )
                  ],
                ),
                Container(
                    height: height * 0.79,
                    width: width,
                    child: _buildCommentList()),
              ],
            ),
          ),
        );
      } else {
        return Scaffold();
      }
    }

    Widget commentcard;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isWeb = false;

    double aspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

    if (aspectRatio >= 1.5) {
      commentcard = commentSection(height * 0.8, width * 0.40);
    } else {
      commentcard = commentSection(height, width);
      isWeb = false;
    }

    return commentcard;
  }
}
