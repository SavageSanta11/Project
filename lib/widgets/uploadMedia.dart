import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../model/file_DataModel.dart';

import 'DropZoneWidget.dart';
import 'dart:typed_data';
import 'dart:async';

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

typedef void BoolCallback(bool flag);
typedef void StringCallback(String url);

String uploadUrl = "";

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

  startWebFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = new html.FileReader();

      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result);
      });
      reader.readAsDataUrl(file);
    });
  }

  void _handleResult(var result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
      makeRequest();
    });
  }

  Future<void> makeRequest() async {
    var url = Uri.parse("http://164.52.212.151:7002/api/access/upload/media");
    var request = new http.MultipartRequest("POST", url);
    request.files.add(http.MultipartFile.fromBytes(
        'input_file', _selectedFile,
        contentType: new MediaType('image', 'png'), filename: "file_up"));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    var decode = jsonDecode(respStr);
     uploadUrl = decode['data']['media_url'];
    print(uploadUrl);
    widget.setPreviewMode(true);
    widget.onSubmitted(uploadUrl);
  }

  Future<String> crawlUrl(String url) async {
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
  return previewImgUrl;
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
                      widget.onSubmitted(file.url);
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
              onFieldSubmitted: (value) async {
                 previewImgUrl = await crawlUrl(value);
                
                widget.onSubmitted(previewImgUrl);
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
          onPressed: ()  {
            startWebFilePicker();
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
