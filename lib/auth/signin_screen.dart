// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:newsexample/models/user.dart';
import 'package:newsexample/screens/home_screen.dart';
import 'package:shimmer/shimmer.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');
DateTime timestamp = DateTime.now();

Users currentUser = Users(displayName: '', photoUrl: '', email: '', id: '');

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();

    // // Detects When User Sign in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account!);
    }, onError: (err) {
      print(err);
    });
    // ReAuthenticate When User Opened App

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account!);
    });
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      await createUserInFireStore();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      signinfailed();
    }
  }

  createUserInFireStore() async {
    //1) check if user exists in users collection in database
    //(according to their id)

    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.id).get();

    if (!doc.exists) {
      usersRef.doc(user.id).set({
        "id": user.id,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "timestamp": timestamp,
      });

      doc = await usersRef.doc(user.id).get();
    }
    currentUser = Users.fromDocument(doc);
  }

  signinfailed() {
    final snackBar = SnackBar(
      content: Text("Sign in failed"),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  login() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    _auth
        .signInWithCredential(credential)
        .whenComplete(() => handleSignIn(googleSignInAccount));
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
            const SizedBox(
              height: 250,
            ),
            InkWell(
              onTap: login,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.asset(
                  "assets/images/google.png",
                  // width: 200,
                  // height: 100,
                  scale: 1.5,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
