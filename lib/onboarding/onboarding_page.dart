import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              width: 300,
              height: 300,
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/* Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              width: 300,
              height: 300,
              color: Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.green,
              ),
            ),
          ],
        )*/
