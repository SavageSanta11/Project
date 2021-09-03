import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef void IntCallback(int length);

List<String> optionList = ["Option 1", "Option 2"];

class OptionContainer extends StatefulWidget {
  final double width;
  final double height;

  final IntCallback onLengthChanged;
  OptionContainer(this.width, this.height, this.onLengthChanged);

  @override
  _OptionContainerState createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer> {
  var children = <Widget>[];

  Container _createSizing(double height) {
    return (Container(
      color: Colors.transparent,
      height: height * 0.05,
    ));
  }

  Container _createOptionEntry(double width, int index) {
    return (Container(
        width: width,
        child: Row(
          children: [
            Container(
                width: width,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      optionList[index - 1] = val;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.delete_outlined),
                        onPressed: () {
                          setState(() {
                            if (optionList.length > 2)
                              optionList.removeAt(index - 1);
                            widget.onLengthChanged(optionList.length);
                          });
                        },
                      ),
                      hintText: 'Option ' + index.toString()),
                )),
          ],
        )));
  }

  Container _createButton(double width, double height) {
    return (Container(
      width: width,
      alignment: Alignment.topCenter,
      height: height * 0.07,
      child: Row(
        children: [
          Container(
            width: width * 0.30,
            height: height * 0.03,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(0xffb8cac8),
                  onPrimary: Colors.black,
                  shadowColor: Colors.transparent),
              child: Text(
                '+ Add another Option',
                style:  GoogleFonts.lato(
                  color: Color(0xff092836),
                  fontSize: 15,
                  ),
            
              ),
              onPressed: () {
                setState(() {
                  optionList
                      .add('Option ' + (optionList.length + 1).toString());
                  widget.onLengthChanged(optionList.length);
                });
              },
            ),
          ),
          Container(
            width: width * 0.5,
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.transparent,
          ),
        ],
      ),
    ));
  }

  Container _createOptionContainer(double width, double height) {
    double localwidth = width * 0.8;
    children = [];

    for (var i = 0; i < optionList.length; i++) {
      children.add(_createSizing(height));
      children.add(_createOptionEntry(localwidth, i + 1));
    }

    if (optionList.length < 4) {
      children.add(_createButton(localwidth, height));
    }

    return (Container(
      child: Column(
        children: children,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _createOptionContainer(widget.width, widget.height);
  }
}
