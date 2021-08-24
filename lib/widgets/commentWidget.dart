import 'dart:convert';
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
    String body = json.encode(<String, String>{
      "poll_id": poll_id,
      "text": text
    });

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

  Widget _buildComment(String comment, int index) {
    return new Container(
      width: 300.0,
      height: 106.0,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
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
    if (isLoaded) {
      return Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                width: 300.0,
                child: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  //autofocus: true,
                  onSubmitted: (val) {
                    _addComment(val);
                    recordComment('yjhhonw', val);
                    _textFieldController.clear();
                  },
                ),
              ),
              Container(
                  height: 300.0, width: 300.0, child: _buildCommentList()),
            ],
          ),
        ),
      );
    } else {
      return Text('loading comments');
    }
  }
}
