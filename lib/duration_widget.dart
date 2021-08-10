import 'package:flutter/material.dart';

class DurationWidget extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final List<int> itemList;

  DurationWidget(this.text, this.width, this.height, this.itemList);

  @override
  _DurationWidgetState createState() => _DurationWidgetState();
}

class _DurationWidgetState extends State<DurationWidget> {
  bool _isDropdownOn = false;
  int dropdownvalue = 0;
  Container _createDurationButton() {
    return (Container(
      width: widget.width,
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: widget.width * 0.9,
            height: widget.height,
            color: Colors.white,
            child: DropdownButton(
                        hint: Text(widget.text),
                        value: dropdownvalue,
                        onChanged: (int? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                        items: widget.itemList
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString() + " "+ widget.text),
                          );
                        }).toList(),
                      ),
          ),
          
        ],
      ),
    ));
  }

  Container _createDropDownEntry() {
    return (Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [_createDurationButton()],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _createDropDownEntry();
  }
}
