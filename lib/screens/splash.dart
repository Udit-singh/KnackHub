import 'package:KnackHub/Widget/allComponents.dart';
import 'package:KnackHub/Widget/top_elements.dart';
import 'package:KnackHub/screens/homepage.dart';
import 'package:KnackHub/screens/signInscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';

class AppStart extends StatefulWidget {
  AppStart({Key key}) : super(key: key);
  @override
  _AppStartState createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  @override
  void initState() {
    super.initState();
    googleSignIn
        .signInSilently(suppressErrors: false)
        .then((account) => handleSignIn(account))
        .catchError((err) => print('Error while signing in silently $err'));
  }

  void handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      final GoogleSignInAccount user = googleSignIn.currentUser;
      DocumentSnapshot doc = await usersRef.doc(user.id).get();
      if (!doc.exists) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SignIn()));
      } else {}
    } else {
      print('PROBLEM IN HANDLE SIGN IN METHOD');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
      context: context,
      gotoWidget: SignIn(),
      splashscreenWidget: ACMsplash(),
      timerInSeconds: 4,
    );
  }
}

class ACMsplash extends StatefulWidget {
  @override
  _ACMsplashState createState() => _ACMsplashState();
}

class _ACMsplashState extends State<ACMsplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.orange.shade50,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LogoSvg(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
