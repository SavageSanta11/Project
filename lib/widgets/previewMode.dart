import 'package:flutter/material.dart';

typedef void BoolCallback(bool flag);

// ignore: camel_case_types
class PreviewMode extends StatefulWidget {
  final double width;
  final double height;
  final BoolCallback onModeChanged;
  String imageUrl =
      "https://files.worldwildlife.org/wwfcmsprod/images/Tiger_resting_Bandhavgarh_National_Park_India/hero_small/6aofsvaglm_Medium_WW226365.jpg";

  PreviewMode(this.width, this.height, this.onModeChanged, this.imageUrl);
  @override
  _PreviewModeState createState() => _PreviewModeState();
}

// ignore: camel_case_types
class _PreviewModeState extends State<PreviewMode> {
  bool isPreviewMode = true;
  // ignore: unused_field

  @override
  Widget build(BuildContext context) {
    Widget preview;

    Align _buildDesktopView(double width, double height) {
      print('Preview Mode enabled');
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: (SizedBox(
            width: width,
            child: Stack(
              children: [
                Container(
                  width: width,
                  
                  child: Image.network(
                    widget.imageUrl,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    width: width,
                   
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
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
                            widget.onModeChanged(false);
                          });
                        },
                      )),
                )
              ],
            ),
          )),
        ),
      );
    }

    preview = _buildDesktopView(widget.width, widget.height);

    return preview;
  }
}
