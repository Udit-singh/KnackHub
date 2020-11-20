import 'dart:io';
import 'package:KnackHub/Widget/customField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final feedRef = FirebaseFirestore.instance.collection('users');
final commonRef = FirebaseFirestore.instance.collection('allPosts');
final storageRef = FirebaseStorage.instance.ref();

class Upload extends StatefulWidget {
  final GoogleSignInAccount user;
  const Upload({@required this.image, @required this.user});

  final File image;

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey globalKey = new GlobalKey();

  File image;
  TextEditingController caption;
  TextEditingController link;
  TextEditingController topic;
  String postId = Uuid().v4();
  String imgUrl;

  String buttonText = 'Save';
  bool isLoading = false;
  String _formatted;

  @override
  void initState() {
    super.initState();
    caption = TextEditingController();
    link = TextEditingController();
    topic = TextEditingController();
    getdate();
  }

  @override
  void dispose() {
    super.dispose();
    caption.dispose();
    link.dispose();
    topic.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      primary: true,
      key: _scaffoldKey,
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Upload Post",
          style: TextStyle(
            color: Colors.teal.shade600,
            fontSize: 23,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade50,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: height * 0.35,
                width: width,
                child: Image.file(widget.image, fit: BoxFit.cover),
              ),
              SizedBox(
                height: height * .05,
              ),
              CustomField(
                controller: caption,
                label: 'Write Your Caption here !',
              ),
              SizedBox(
                height: height * .05,
              ),
              CustomField(
                controller: link,
                label: 'Source Code Link',
              ),
              SizedBox(
                height: height * .05,
              ),
              CustomField(
                controller: topic,
                label: 'Topic of your Post',
              ),
              SizedBox(
                height: height * .04,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        minWidth: MediaQuery.of(context).size.width * 0.40,
                        child: Text(
                          "Discard",
                          style: TextStyle(fontSize: 20),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: width * .01,
                      ),
                      MaterialButton(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        minWidth: MediaQuery.of(context).size.width * 0.40,
                        child: Text(
                          "Post",
                          style: TextStyle(fontSize: 20),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          saveImage();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height * .04,
              ),
            ],
          ),
        ),
      ),
    );
  }

  saveImage() async {
    SnackBar snackbar1 = SnackBar(
      content: Text('Your Post is Uploading...'),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar1);
    await uploadImage();
    await uploadData();
    setState(() {
      isLoading = false;
      buttonText = 'Saved';
    });
    Navigator.pop(context);
  }

  Future<void> uploadImage() async {
    StorageUploadTask uploadTask =
        storageRef.child("$postId/image").putFile(widget.image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    setState(() {
      imgUrl = downloadUrl;
    });
  }

  DateTime _now;
  uploadData() async {
    feedRef.doc(widget.user.id).collection('userPosts').doc(postId).set({
      'postId': postId,
      'ownerId': widget.user.id,
      'username': widget.user.displayName,
      'code': '<link>' + link.text + '</link>',
      'description': caption.text,
      'dateTime': _now,
      'imgUrl': imgUrl,
      'pdfUrl': "",
      'topic': topic.text,
      'likes': {},
    });
    commonRef.doc(postId).set({
      'postId': postId,
      'ownerId': widget.user.id,
      'username': widget.user.displayName,
      'code': '<link>' + link.text + '</link>',
      'description': caption.text,
      'dateTime': _now,
      'imgUrl': imgUrl,
      'pdfUrl': "",
      'topic': topic.text,
      'likes': {},
    });
    SnackBar snackbar1 = SnackBar(
      content: Text('Your Post is Uploaded!'),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar1);
  }

  getdate() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    final String formatted = formatter.format(now);
    setState(() {
      _formatted = formatted;
      _now = now;
    });
  }
}
