import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:image_picker/image_picker.dart';
import '../model/file_DataModel.dart';

import 'DropZoneWidget.dart';
import 'dart:typed_data';
import 'dart:async';

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

typedef void BoolCallback(bool flag);
typedef void StringCallback(String previewUrl, String contentUrl);

String uploadUrl = "";
String mediaUrl = "";

// ignore: camel_case_types

class uploadMode extends StatefulWidget {
  final double width;
  final double height;
  final BoolCallback setPreviewMode;
  final StringCallback onSubmitted;

  uploadMode(this.width, this.height, this.setPreviewMode, this.onSubmitted);
  @override
  _uploadModeState createState() => _uploadModeState();
}

// ignore: camel_case_types
class _uploadModeState extends State<uploadMode> {
  late DropzoneViewController controller;
  bool isPreviewMode = false;
  var imageFile;
  File_Data_Model? file;

  late List<int> _selectedFile;
  late Uint8List _bytesData;

  String previewImgUrl = "";

  var image;

  void _uploadImage() async {
    final _picker = ImagePicker();

    var _pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      image = _pickedImage!.path;
    });
    sendImage(image);
  }

  Future<void> sendImage(filepath) async {
    var request = http.MultipartRequest('POST',
        Uri.parse("http://164.52.212.151:7002/api/access/upload/media"));
    request.files.add(await http.MultipartFile.fromPath(
      'input_file',
      image,
      contentType: new MediaType('image', 'png'),
    ));
    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    var decode = jsonDecode(respStr);
    uploadUrl = decode['data']['preview_image_url'];
    mediaUrl = decode['data']['media_url'];

    widget.setPreviewMode(true);
    widget.onSubmitted(uploadUrl, mediaUrl);
  }

  Future<List> crawlUrl(String url) async {
    var headers = {
      'Authorization':
          'Bearer  eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTYyOTI4MjQyMiwianRpIjoiNWMyZmNkYTQtZjgyZS00ODhlLWFmZGEtNTFiZmEyYmZlMzJkIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6Imthbm9AcW9ud2F5LmNvbSIsIm5iZiI6MTYyOTI4MjQyMiwiZXhwIjoxNjI5MjgzMzIyfQ.L6O-rXKbo8vtcyT0K071o108Lljpr_PjLmw14rDHVvI'
    };

    http.Response response = await http.get(
      Uri.parse('http://164.52.212.151:7002/api/access/crawl/url?url=' + url),
      headers: headers,
    );

    var convertDataToJson = json.decode(response.body);
    previewImgUrl = convertDataToJson["data"]["preview_image_url"];
    String mediaUrl = convertDataToJson["data"]["media_url"];
    return [previewImgUrl, mediaUrl];
  }

  @override
  Widget build(BuildContext context) {
    Widget uploadMedia;

    Container _createEditSection(double width, double height) {
      return (Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white), color: Colors.white),
        child: Stack(
          children: [
            DropZoneWidget(
                onDroppedFile: (file) => setState(() {
                      this.file = file;
                      isPreviewMode = true;
                      widget.onSubmitted(file.url, "");
                    }),
                width: width,
                height: height),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: "Drag and drop a photo or insert a link",
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (!Uri.parse(value!).isAbsolute) {
                  return "Please enter valid URL";
                } else {
                  return null;
                }
              },
              onFieldSubmitted: (contentUrl) async {
                previewImgUrl = (await crawlUrl(contentUrl))[0];
                mediaUrl = (await crawlUrl(contentUrl))[1];
                widget.onSubmitted(previewImgUrl, mediaUrl);
              },
            ),
          ],
        ),
      ));
    }

    Container _createUploadButton(double width, double height) {
      return (Container(
        width: width,
        height: height,
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: ElevatedButton(
          child: Text('Upload', style: TextStyle(fontFamily: 'Leto')),
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.white,
          ),
          onPressed: () {
           _uploadImage();
            /*openGallery();
             final events = await controller.pickFiles();
                  if (events.isEmpty) return;
                  widgetKey.currentState!.UploadedFile(events.first);*/
          },
        ),
      ));
    }

    Container _buildDesktopView(double width, double height) {
      return (Container(
        width: width,
        height: height,
        child: Column(
          children: [
            _createEditSection(width, height * 0.25),
            _createUploadButton(width, height * 0.75)
          ],
        ),
      ));
    }

    uploadMedia = _buildDesktopView(widget.width, widget.height);

    return uploadMedia;
  }
}
