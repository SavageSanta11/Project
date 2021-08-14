import 'package:flutter/material.dart';

class OptionContainer extends StatefulWidget {
  final double width;
  final double height;
  OptionContainer(this.width, this.height);

  @override
  _OptionContainerState createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer> {
  var children = <Widget>[];
  List<String> _optionList = ["Option 1", "Option 2"];

  Container _createSizing(double height) {
    return (Container(
      color: Colors.transparent,
      height: height * 0.05,
    ));
  }

  Container _createOptionEntry(double width, int index) {
    return (Container(
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.transparent),
        child: Row(
          children: [
            Container(
                width: width,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      //border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.delete_outlined),
                        onPressed: () { setState(() {
                      if (_optionList.length > 2)
                        _optionList.removeAt(index - 1);
                    });},
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
      height: height * 0.1,
      child: Row(
        children: [
          Container(
            width: width * 0.30,
            height: height * 0.04,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(0xffb8cac8),
                  onPrimary: Colors.black,
                  shadowColor: Colors.transparent),
              child: Text(
                '+ Add another Option',
                style: TextStyle(fontFamily: 'Leto', fontSize: 15),
              ),
              onPressed: () {
                setState(() {
                  _optionList
                      .add('Option ' + (_optionList.length + 1).toString());
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

    for (var i = 0; i < _optionList.length; i++) {
      children.add(_createSizing(height));
      children.add(_createOptionEntry(localwidth, i + 1));
    }

    if (_optionList.length < 4) {
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
