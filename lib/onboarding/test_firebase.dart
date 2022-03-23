import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../add_contact.dart';

var data = FirebaseFirestore.instance;

class TestFireBase extends StatefulWidget {
  const TestFireBase({Key? key}) : super(key: key);

  @override
  _TestFireBaseState createState() => _TestFireBaseState();
}

class _TestFireBaseState extends State<TestFireBase> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0); // sortie de l'application
          },
          child: const Text(
            " Oui",
            style: TextStyle(
              color: Color(0xffEAEDEF),
            ),
          )),
    );
  }

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context); //  distruction de widget de courant
        },
        child: Text(" Non"));
  }

  Future<bool> avoidReturnButton() async {
    // async pour l'ouverture de thread
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text(" êtes-vous sûr de sortir ?"),
            actions: [Negative(context), Positive()],
          );
        });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: avoidReturnButton,
        child: Scaffold(
            backgroundColor: Colors.white70.withOpacity(0.9),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    height: size.height * 0.1,
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "List de clients",
                          style: TextStyle(fontSize: 25),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Get.to(UploadImage());
                            },
                            child: Text("Ajouter un compte"))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: data.collection("clients").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.size,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  " Nom :   ${snapshot.data!.docs[index].get("name")}"),
                                              Text(
                                                  " Prénom :   ${snapshot.data!.docs[index].get("lastname")}"),
                                              Text(
                                                  " Age :   ${snapshot.data!.docs[index].get("age")}"),
                                              Text(
                                                  " Role :   ${snapshot.data!.docs[index].get("role")}"),
                                            ],
                                          ),
                                          Spacer(),
                                          CircleAvatar(
                                            radius: 45,
                                            backgroundColor: Colors.green,
                                            child: CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                  "${snapshot.data!.docs[index].get("url")}"),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: SpeedDial(
              icon: Icons.add,
              children: [
                SpeedDialChild(
                    /*  onTap: () {
                      Get.to(DropDownButton());
                    },*/
                    label: "Drop Down Button",
                    child: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green),
                SpeedDialChild(
                    label: "Checkbox",
                    child: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green),
                SpeedDialChild(
                    label: "Radio",
                    child: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green),
                SpeedDialChild(
                    label: "Switch",
                    child: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green),
              ],
            )),
      ),
    );
  }
}

/*void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: new Text("Alert!!"),
        content: Container(
          height: 100,
          child: Column(
            children: [],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}*/
/* StreamBuilder<QuerySnapshot>(
              stream: data.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        return Text(
                            "${snapshot.data!.docs[index].get("name")}");
                      });
                } else {
                  return CircularProgressIndicator();
                }
              },
            )*/
