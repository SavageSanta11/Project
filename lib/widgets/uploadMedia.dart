import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../model/file_DataModel.dart';

import 'package:image_picker/image_picker.dart';
import 'DropZoneWidget.dart';

typedef void BoolCallback(bool flag);
typedef void StringCallback(String url);

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

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  
  // Check this code working for image files or not
  Future<void> _getImage(ImageSource source) async {
    var image = await _picker.pickImage(source: source);
    if (image != null) {
      final tempImage = File(image.path);
      print('---------------->'+image.path.toString()+'<----------------');
      setState(() {
        this._imageFile = tempImage;
        //TODO: send file as _imageFile and path as image.path
      });
    }
    Navigator.pop(context);
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
              onFieldSubmitted: (value) {
                widget.onSubmitted(value);
              },
            ),
          ],
        ),
      ));
    }

    Future<void> openGallery() async {
      final picker = ImagePicker();
      var pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imageFile = File(pickedFile!.path);
      });
      print(imageFile);
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
          onPressed: () async {
            /*openGallery();
             final events = await controller.pickFiles();
                  if (events.isEmpty) return;
                  widgetKey.currentState!.UploadedFile(events.first);*/
                  _getImage(ImageSource.gallery);
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
