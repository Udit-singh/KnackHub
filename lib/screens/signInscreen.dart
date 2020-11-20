import 'package:KnackHub/Model/user.dart';
import 'package:KnackHub/Widget/customSignInButton.dart';
import 'package:KnackHub/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn();

final usersRef = FirebaseFirestore.instance.collection('users');

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //user class
  User tempuser = User();

  @override
  void initState() {
    super.initState();
  }

  // Future<bool> handleSignIn(User account) async {
  //   if (account != null) {
  //     final GoogleSignInAccount user = googleSignIn.currentUser;
  //     DocumentSnapshot doc = await usersRef.doc(user.id).get();
  //     if (!doc.exists) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     print('PROBLEM IN HANDLE SIGN IN METHOD');
  //     return false;
  //   }
  // }
  void githubLogIn() {}

  void logIn() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final user = await googleSignIn.signIn();
      DocumentSnapshot doc = await usersRef.doc(user.id).get();
      if (doc.exists) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Homepage(user: user)),
            (route) => false);
      } else {
        usersRef.doc(user.id).set({
          'id': user.id,
          'username': user.displayName,
          'email': user.email,
          'photoUrl': user.photoUrl,
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Homepage(user: user)),
            (route) => false);
      }
    } else {
      SnackBar snackbar = SnackBar(
        content: Text('Check your internet connection'),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(
              child: Card(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                color: Colors.orange.shade50, //grey[900],
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.orange.shade50, //grey[900],
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(30),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'Assets/Images/logo.png',
                        alignment: Alignment.topCenter,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      // Text(
                      //   'KnackHub',
                      //   style: TextStyle(
                      //     color: Colors.orange.shade800,
                      //     fontSize: 26,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      Text(
                        'SignIn To KnackHub',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomSignInButton(
                  imageStringUrl: 'Assets/Images/google.png',
                  label: 'SignIn with Google',
                  function: logIn,
                ),
                Text(
                  "OR",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                CustomSignInButton(
                  imageStringUrl: 'Assets/Images/github.png',
                  label: 'SignIn with Github',
                  function: githubLogIn,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
