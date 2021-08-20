import '../model/file_DataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import 'package:flutter/foundation.dart';

const Color buttoncolor = Color(0xff102c34);
File_Data_Model? file;


GlobalKey<_DropZoneWidgetState> widgetKey = GlobalKey<_DropZoneWidgetState>();
class DropZoneWidget extends StatefulWidget {
  final ValueChanged<File_Data_Model> onDroppedFile;
  final double width;
  final double height;

  const DropZoneWidget({Key? key, required this.onDroppedFile, required this.width, required this.height})
      : super(key: key);
  @override
  _DropZoneWidgetState createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  late DropzoneViewController controller;
  @override
  Widget build(BuildContext context) {
    
    Container _createDropzoneSection(double width, double height){
      return Container(
        width: width,
        height: height ,
        child: DropzoneView(
          onCreated: (controller) => this.controller = controller,
          onDrop: UploadedFile,
        ),
      );
    }

    return _createDropzoneSection(widget.width, widget.height);

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
