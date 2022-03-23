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
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart';

var data = FirebaseFirestore.instance;

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  Contacts createState() => Contacts();
}

class Contacts extends State<Contact> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController adresscontroller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController etiquetteController = TextEditingController();
  bool isLoading = false;
  bool isSelected = false;
  var radio;
  String client = "client";
  String fournisseur = "fournisseur";
  File? _image; // fichier de l'image à selectionnée
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Les contacts "),
        ),
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                right: size.height * 0.05, left: size.height * 0.05),
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
                    sizedBox(size: size),
                    buildTextFormField(Icons.account_circle_sharp, "Nom",
                        TextInputType.text, nameController),
                    sizedBox(size: size),
                    buildTextFormField(Icons.location_on, "Adresse",
                        TextInputType.text, adresscontroller),
                    sizedBox(size: size),
                    buildTextFormField(Icons.email, "Adresse email",
                        TextInputType.emailAddress, emailController),
                    sizedBox(size: size),
                    buildTextFormField(Icons.phone, "Tél portable",
                        TextInputType.phone, phoneController),
                    sizedBox(size: size),
                    buildTextFormField(Icons.vertical_distribute_sharp,
                        "Etiquette", TextInputType.text, etiquetteController),
                    RadioListTile(
                        title: Text("Client"),
                        value: client,
                        groupValue: radio,
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            radio = value;
                          });
                        }),
                    RadioListTile(
                        title: Text("Fornissuer"),
                        value: fournisseur,
                        groupValue: radio,
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            radio = value;
                          });
                        }),
                    isLoading
                        ? CircularProgressIndicator()
                        : Container(
                            height: size.height * 0.07,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_image == null) {
                                      Get.snackbar(
                                        "Store 2000",
                                        "Image Obligatoire",
                                        icon: Icon(Icons.error,
                                            color: Colors.white),
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
                                      var imageUrl = await (await task)
                                          .ref
                                          .getDownloadURL();
                                      await data
                                          .collection('contacts')
                                          .doc()
                                          .set({
                                        "name": nameController.text,
                                        "adresse": adresscontroller.text,
                                        "email": emailController.text,
                                        "phone": phoneController.text,
                                        "etiquette": etiquetteController.text,
                                        "type": radio,
                                        'urlImage': imageUrl.toString()
                                      });
                                      Get.snackbar(
                                        "Store 2000",
                                        "Contact ajouté avec success",
                                        icon: Icon(Icons.done_all,
                                            color: Colors.white),
                                        backgroundColor:
                                            Colors.green.withOpacity(0.5),
                                        snackPosition: SnackPosition.TOP,
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                                child: Text("Ajouter le contact")),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(IconData icons, String hinttext,
      TextInputType keyboardType, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hinttext,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          icons,
          color: Colors.orange,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.orange, width: 1.5),
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
      validator: (value) {
        if (value!.isEmpty) {
          return "Veuillez entrer votre ${hinttext} ";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value) &&
            hinttext == "Adresse email") {
          return "Veuillez entrer  adresse e-mail  valide ";
        } else
          return null;
      },
    );
  }
}

class sizedBox extends StatelessWidget {
  const sizedBox({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.01,
    );
  }
}
