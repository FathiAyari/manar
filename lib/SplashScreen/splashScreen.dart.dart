import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:onboarding/onboarding/test_firebase.dart';
import 'package:onboarding/onboardingPage/Onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<SplashScreen> {
  var resultSeen = GetStorage().read("seen");
  @override
  void initState() {
    // one single time
    Timer(
      Duration(seconds: 4),
      () => Get.to(() => resultSeen == 1 ? TestFireBase() : Onboarding()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset("assets/logo.png"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
              child: Container(
                child: Lottie.asset('assets/loading.json',
                    height: size.height * 0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/* Container(
          width: double.infinity,
          child: ListView.builder(itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                width: 150,
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ), // string inerpolation
                color: Colors.blue,
              ),
            );
          }),
        )*/
