import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:newsexample/auth/signin_screen.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // startTimeout();
  }

  handleTimeout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  startTimeout() {
    var duration = const Duration(seconds: 2);
    return Timer(duration, handleTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            HexColor("#203F3B"),
            HexColor("#3F3F3F"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.0,
              // height: 100.0,
              child: Shimmer.fromColors(
                baseColor: Colors.redAccent,
                highlightColor: Colors.white38,
                child: const Text(
                  'News App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            const Text("using newsapi.org",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white30)),
          ],
        )),
      ),
    );
  }
}
