import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownButton extends StatefulWidget {
  late final String hint;
  DropDownButton({required this.hint});

  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(" Drop down button"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  hint: Text(widget.hint),
                  onChanged: (value) {
                    setState(() {
                      widget.hint = value!;
                    });
                  },
                  items: <String>[
                    "Role admin",
                    "Role user",
                  ].map((String conetnt) {
                    return DropdownMenuItem(
                        value: conetnt, child: Text(" ${conetnt}"));
                  }).toList(),
                ))),
          ),
        ),
      ),
    ));
  }
}
