import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Destination extends StatelessWidget {
  const Destination({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: [
        Container(
          color: Colors.green,
        ),
        Container(
          color: Colors.red,
        ),
        Container(
          color: Colors.blueAccent,
        ),
      ],
    ),);
  }
}
