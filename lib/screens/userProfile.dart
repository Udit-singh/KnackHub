import 'package:KnackHub/Widget/EventCardCustom.dart';
import 'package:KnackHub/Widget/customTextField.dart';
import 'package:KnackHub/constants/text.dart';
import 'package:KnackHub/screens/signInscreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Userdata extends StatefulWidget {
  final GoogleSignInAccount user;
  Userdata({Key key, @required this.user});

  @override
  _UserdataState createState() => _UserdataState();
}

class _UserdataState extends State<Userdata> {
  TextEditingController name;
  TextEditingController emailId;
  TextEditingController image;
  List<String> docs = [];

  @override
  void initState() {
    super.initState();
    image = TextEditingController(text: widget.user.photoUrl.toString());
    emailId = TextEditingController(text: widget.user.email.toString());
    name = TextEditingController(text: widget.user.displayName.toString());
    getDocs();
  }

  void getDocs() {
    FirebaseFirestore.instance
        .collection('savedPost')
        .doc(widget.user.id)
        .get()
        .then((value) {
      value.data()['saved'].forEach((data) {
        print(data);
        docs.add(data);
      });
    });
  }

  int flag = 1;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'image',
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage('${image.text}'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: height * 0.03,
                width: width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: Colors.blue.shade300,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, size: 15, color: Colors.amberAccent),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Text(
                      "User Info",
                      style: TextStyle(
                          fontSize: height * 0.015,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: height * 0.04, bottom: height * 0.03),
              child: Text(
                widget.user.displayName,
                style: TextStyle(
                  fontSize: height * 0.04,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: height * 0.28,
              width: width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Name :",
                        textAlign: TextAlign.left,
                        style: InputLabel,
                      ),
                      CustomTextField(
                        inputType: TextInputType.text,
                        readonly: true,
                        textEditingController: name,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Email :",
                        textAlign: TextAlign.left,
                        style: InputLabel,
                      ),
                      CustomTextField(
                        inputType: TextInputType.emailAddress,
                        readonly: true,
                        textEditingController: emailId,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  MaterialButton(
                    child:
                        Text('LOG OUT', style: TextStyle(color: Colors.white)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () async {
                      await googleSignIn.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => SignIn()),
                          (route) => false);
                    },
                    color: Colors.blue[400],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
