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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart';

var data = FirebaseFirestore.instance;

class EditContact extends StatefulWidget {
  final String id;
  const EditContact(this.id);

  @override
  Contacts createState() => Contacts();
}

class Contacts extends State<EditContact> {
  Future<void> getUserData() async {
    setState(() {
      loading = true;
    });
    var snapshotName = await FirebaseFirestore.instance
        .collection('contacts')
        .doc(widget.id)
        .get();
    setState(() {
      emailController.text = snapshotName["email"];
      nameController.text = snapshotName["name"];
      adresscontroller.text = snapshotName["adresse"];
      phoneController.text = snapshotName["phone"];
      etiquetteController.text = snapshotName["etiquette"];
      radio = snapshotName["type"];
      url = snapshotName["urlImage"];
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  late String url;
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
          title: Text("Modifier un  contact "),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Container(
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
                                    ? NetworkImage(url) as ImageProvider
                                    : FileImage(_image!),
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                    onPressed: () async {
                                      var image = await ImagePicker().pickImage(
                                          source: ImageSource.gallery);
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
                          buildTextFormField(
                              Icons.vertical_distribute_sharp,
                              "Etiquette",
                              TextInputType.text,
                              etiquetteController),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          /* var image = FirebaseStorage.instance
                                              .ref(_image!.path);
                                          var task = image.putFile(
                                              _image!); //upload au Storage
                                          var imageUrl = await (await task)
                                              .ref
                                              .getDownloadURL();*/
                                          await data
                                              .collection('contacts')
                                              .doc(widget.id)
                                              .update({
                                            "name": nameController.text,
                                            "adresse": adresscontroller.text,
                                            "email": emailController.text,
                                            "phone": phoneController.text,
                                            "etiquette":
                                                etiquetteController.text,
                                            "type": radio,
                                          });
                                          Get.snackbar(
                                            "Store 2000",
                                            "Contact modifié avec success",
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
                                      },
                                      child: Text("Modifier le contact")),
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
        } else
          return null;
      },
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

  InputDecoration buildInputDecoration(IconData icons, String hinttext,
      {required Color color}) {
    return InputDecoration(
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
