import '../model/file_DataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import 'package:flutter/foundation.dart';

const Color buttoncolor = Color(0xff102c34);

typedef void StringCallback(String url);


GlobalKey<_DropZoneWidgetState> widgetKey = GlobalKey<_DropZoneWidgetState>();

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<File_Data_Model> onDroppedFile;
  final StringCallback onValidUrl;

  const DropZoneWidget({Key? key, required this.onDroppedFile, required this.onValidUrl})
      : super(key: key);
  @override
  _DropZoneWidgetState createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  late DropzoneViewController controller;

 
  File_Data_Model? file;
  String url = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double _uploadwidth = kIsWeb ? width * 0.4 : width * 0.8;
    return Container(
        height: height * 0.2,
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
                        url = value;
                        
                        return null;
                      }
                    },
                    onFieldSubmitted: (value){
                      
                      widget.onValidUrl(value);
                    },
                  ),
                ),
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
                },
              ),
            )
          ],
        ));
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
  }
}

@override
Widget build(BuildContext context) {
  // ignore: todo
  // TODO: implement build
  throw UnimplementedError();
}