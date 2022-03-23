import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'contacts/contacts.dart';
import 'edit_contact.dart';

var data = FirebaseFirestore.instance;

class contactHomePage extends StatefulWidget {
  const contactHomePage({Key? key}) : super(key: key);

  @override
  _TestFireBaseState createState() => _TestFireBaseState();
}

class _TestFireBaseState extends State<contactHomePage> {
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
                    child: Text(
                      "Contacts",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Rechercher",
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.orange,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                  color: Colors.orange, width: 1.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Container(
                        height: size.height * 0.075,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () async {},
                            child: Text("Rechercher")),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: data.collection("contacts").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.size,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  secondaryActions: [
                                    IconSlideAction(
                                      caption: "Supprimer",
                                      icon: Icons.delete,
                                      color: Colors.red,
                                      onTap: () {
                                        snapshot.data!.docs[index].reference
                                            .delete();
                                      },
                                    ),
                                    IconSlideAction(
                                      onTap: () {
                                        Get.to(EditContact(snapshot
                                            .data!.docs[index].reference.id));
                                      },
                                      caption: "Modifier",
                                      icon: Icons.edit,
                                      color: Colors.green,
                                    ),
                                  ],
                                  child: Padding(
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
                                              CircleAvatar(
                                                radius: 45,
                                                backgroundColor: Colors.green,
                                                child: CircleAvatar(
                                                  radius: 40,
                                                  backgroundImage: NetworkImage(
                                                      "${snapshot.data!.docs[index].get("urlImage")}"),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.07,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      " Nom :   ${snapshot.data!.docs[index].get("name")}"),
                                                  Text(
                                                      " Adresse :   ${snapshot.data!.docs[index].get("adresse")}"),
                                                  Text(
                                                      " Email :   ${snapshot.data!.docs[index].get("email")}"),
                                                  Text(
                                                      " Type :   ${snapshot.data!.docs[index].get("type")}"),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
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
                  onTap: () {
                    Get.to(Contact());
                  },
                  label: "Ajouter Contact",
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.orange,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
