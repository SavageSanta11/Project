import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/file_DataModel.dart';
import 'package:flutter/foundation.dart';
import '../pages/create_poll.dart';
import 'DropZoneWidget.dart';
import 'package:http/http.dart' as http;
import 'DropZoneWidget.dart';

String previewImgUrl = "";

  Future<void> crawlUrl(String url) async {
    var headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTIwMzQyMiwianRpIjoiNTZjY2MwNTMtNTA4My00ZTRiLWFjYTUtOGM5MGYxYTQwMGZmIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTIwMzQyMiwiZXhwIjoxNjI5MjA0MzIyfQ.l2yPmjvKBZ32QLI9Y4WxcgDVAwMlL5CMu4xOX692CzY'
    };

    http.Response response = await http.get(
      Uri.parse('http://164.52.212.151:3012/api/access/crawl/url?url=' + url),
      headers: headers,
    );

    var convertDataToJson = json.decode(response.body);
    previewImgUrl = convertDataToJson["data"]["preview_image_url"];
    print(previewImgUrl);
  }
class PreviewWidget extends StatefulWidget {
  @override
  _PreviewWidgetState createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  File_Data_Model? file;
  //String previewImgUrl = "https://files.worldwildlife.org/wwfcmsprod/images/Tiger_resting_Bandhavgarh_National_Park_India/hero_small/6aofsvaglm_Medium_WW226365.jpg";

  @override
  Widget build(BuildContext context) {
    return buildImage(context);
  }

  Widget buildImage(BuildContext context) {
    return isPreviewImgUrl
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      previewImgUrl,
                      width: kIsWeb
                          ? MediaQuery.of(context).size.width * 0.4
                          : MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => buildEmptyFile(),
                    ),
                    Container(
                        width: 25,
                        height: 25,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white, onPrimary: Colors.black38),
                          child: Text(
                            'X',
                            style: TextStyle(fontFamily: 'Leto', fontSize: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              isPreviewImgUrl = false;
                            });
                          },
                        ))
                  ],
                ),
              ),
            ],
          )
        : SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }

  Widget buildEmptyFile() {
    return Container(
      width: 0,
      height: 0,
    );
  }
}
