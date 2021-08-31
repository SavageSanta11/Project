import 'package:flutter/material.dart';

typedef void IntCallback(int time);

class DurationWidget extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final List<int> itemList;
  final IntCallback onTimeChanged;

  DurationWidget(
      this.text, this.width, this.height, this.itemList, this.onTimeChanged);

  @override
  _DurationWidgetState createState() => _DurationWidgetState();
}

class _DurationWidgetState extends State<DurationWidget> {
  //bool _isDropdownOn = false;
  int dropdownvalue = -1;
  int elementId = 3;
  Container _createDurationButton() {
    return (Container(
      padding: EdgeInsets.fromLTRB(widget.width * 0.07, 0, 0, 0),
      width: widget.width * 0.9,
      height: widget.height * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          hint: dropdownvalue != -1
              ? Text(dropdownvalue.toString() + " " + widget.text)
              : Text(widget.text),
          onChanged: (int? newValue) {
            widget.onTimeChanged(newValue!);

            setState(() {
              dropdownvalue = newValue;
            });
          },
          items: widget.itemList.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString() + " " + widget.text),
            );
          }).toList(),
        ),
      ),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return _createDurationButton();
  }
}
