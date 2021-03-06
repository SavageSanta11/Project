import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/file_DataModel.dart';
import 'package:flutter/foundation.dart';

typedef void BoolCallback(bool previewMode);

// ignore: must_be_immutable
class DroppedFileWidget extends StatefulWidget {
  final File_Data_Model? file;
  bool previewState = false;
  final BoolCallback onPreviewStateChanged;

  DroppedFileWidget({
    Key? key,
    required this.file,
    required this.previewState,
    required this.onPreviewStateChanged,
  }) : super(key: key);

  @override
  _DroppedFileWidgetState createState() => _DroppedFileWidgetState();
}

class _DroppedFileWidgetState extends State<DroppedFileWidget> {
  File_Data_Model? file;

  @override
  Widget build(BuildContext context) {
    return buildImage(context);
  }

  Widget buildImage(BuildContext context) {
    if (widget.file == null) return buildEmptyFile();

    

    return widget.previewState
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      file!.url,
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
                              widget.previewState = false;
                            });
                            widget.onPreviewStateChanged(widget.previewState);
                          },
                        ))
                  ],
                ),
              ),
            ],
          )
        : buildEmptyFile();
  }

  Widget buildEmptyFile() {
    return Container(
      width: 0,
      height: 0,
    );
  }
}
