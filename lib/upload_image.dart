/*
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  final imageTemporary = File(image!.path);
                  setState(() {
                    _image = imageTemporary;
                  });
                  var iimage = FirebaseStorage.instance.ref(_image!.path);
                  var task = iimage.putFile(_image!);
                  var imageurl = await (await task)
                      .ref
                      .getDownloadURL();
                  print(imageurl);
                },
                child: Text("choisir image")),
            ElevatedButton(
              onPressed: () async {},
              child: Text("choisir image"),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

var data = FirebaseFirestore.instance;

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isLoading = false;
  File? _image; // fichier de l'image à selectionnée
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Ajouter un compte "),
        ),
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.05,
                right: size.height * 0.05,
                left: size.height * 0.05),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _image == null
                              ? AssetImage('assets/avatar.png') as ImageProvider
                              : FileImage(_image!),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: IconButton(
                              onPressed: () async {
                                var image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                final temp = File(image!.path);
                                setState(() {
                                  _image = temp;
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.blueAccent,
                              )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    buildformulaire(nameController, "Nom de client "),
                    const SizedBox(
                      height: 40,
                    ),
                    buildformulaire(lastnameController, "Prénom de client "),
                    const SizedBox(
                      height: 40,
                    ),
                    buildformulaire(ageController, "Age de client "),
                    const SizedBox(
                      height: 40,
                    ),
                    isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_image == null) {
                                  Get.snackbar(
                                    "Store 2000",
                                    "Image Obligatoire",
                                    icon:
                                        Icon(Icons.error, color: Colors.white),
                                    backgroundColor:
                                        Colors.red.withOpacity(0.5),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var image = FirebaseStorage.instance
                                      .ref(_image!.path);
                                  var task = image
                                      .putFile(_image!); //upload au Storage
                                  var imageUrl =
                                      await (await task).ref.getDownloadURL();
                                  await data.collection('clients').doc().set({
                                    "url": imageUrl.toString(),
                                    "name": nameController.text,
                                    "lastname": lastnameController.text,
                                    "age": ageController.text
                                  });
                                  Get.snackbar(
                                    "Store 2000",
                                    "image ajouté avec success",
                                    icon: Icon(Icons.done_all,
                                        color: Colors.white),
                                    backgroundColor:
                                        Colors.green.withOpacity(0.5),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: Text("Ajouter une image")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildformulaire(
      TextEditingController fieldController, String hintText) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "champ obligatoire ";
        } else {
          return null;
        }
      },
      controller: fieldController,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.blueAccent),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}