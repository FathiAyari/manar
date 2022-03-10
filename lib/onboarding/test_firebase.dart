import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var data = FirebaseFirestore.instance;

class TestFireBase extends StatefulWidget {
  const TestFireBase({Key? key}) : super(key: key);

  @override
  _TestFireBaseState createState() => _TestFireBaseState();
}

class _TestFireBaseState extends State<TestFireBase> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await data
                        .collection("users")
                        .doc()
                        .collection("test")
                        .doc("test document")
                        .set({"test": "success"});
                    /* await data
                        .collection("users")
                        .doc("Manar")
                        .set({"name": "manar", "age": "22"});*/
                  },
                  child: Text("Test"))
            ],
          ),
        ),
      ),
    );
  }
}
