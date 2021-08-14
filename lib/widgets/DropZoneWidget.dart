import 'dart:io';

import '../model/file_DataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const Color buttoncolor = Color(0xff102c34);
String previewImgUrl = "";
bool isPreviewmode = false;

GlobalKey<_DropZoneWidgetState> widgetKey = GlobalKey<_DropZoneWidgetState>();

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<File_Data_Model> onDroppedFile;

  const DropZoneWidget({Key? key, required this.onDroppedFile})
      : super(key: key);
  @override
  _DropZoneWidgetState createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  late DropzoneViewController controller;
  bool highlight = false;
  bool isImgUrl = false;

  var imageFile;
  File_Data_Model? file;

  Future<void> getImgUrl() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://qonway.com:8089/api/v1/media/upload'));

    request.files.add(await http.MultipartFile.fromPath(
        'input_file', '/C:/Users/GigaB/Desktop/blue.png'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile('image',
        File(filepath).readAsBytes().asStream(), File(filepath).lengthSync(),
        filename: filepath.split("/").last));
    // ignore: unused_local_variable
    var res = await request.send();
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    print(imageFile.runtimeType);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double _uploadwidth = kIsWeb? width*0.4 : width*0.8;
      return (Container(
          
          height: height*0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: _uploadwidth,
                      height: height * 0.1,
                    child: DropzoneView(
                    onCreated: (controller) => this.controller = controller,
                    onDrop: UploadedFile,
                ),
                  ),
                  Container(
                      width: _uploadwidth,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: "Drag and drop a photo",
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (!Uri.parse(value!).isAbsolute) {
                        return "Please enter valid URL";
                      } else {
                        isImgUrl = true;
                        return null;
                      }
                    },
                  ),),
                ],
              ),
              Container(
                width: _uploadwidth,
                height: height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: Colors.white,
                ),
                child: ElevatedButton(
              child: Text('Upload', style: TextStyle(fontFamily: 'Leto')),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.white,
              ),
              onPressed: () async {
                final events = await controller.pickFiles();
                if (events.isEmpty) return;
                UploadedFile(events.first);

                setState(() {
                  isPreviewmode = true;
                });
                /*setState(() async {
                previewImgUrl = await openGallery();
              });*/
              },
            ),
              )
            ],
          )));
  }

  // ignore: non_constant_identifier_names
  Future UploadedFile(dynamic event) async {
    final name = event.name;

    final mime = await controller.getFileMIME(event);
    final byte = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);

    print('Name : $name');
    print('Mime: $mime');

    print('Size : ${byte / (1024 * 1024)}');
    print('URL: $url');

    final droppedFile =
        File_Data_Model(name: name, mime: mime, bytes: byte, url: url);

    widget.onDroppedFile(droppedFile);
    setState(() {
      highlight = false;
    });
  }
}

@override
Widget build(BuildContext context) {
  // ignore: todo
  // TODO: implement build
  throw UnimplementedError();
}
