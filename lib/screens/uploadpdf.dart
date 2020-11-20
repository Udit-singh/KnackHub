import 'dart:io';
import 'dart:math';
import 'package:KnackHub/Widget/customField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final feedRef = FirebaseFirestore.instance.collection('users');
final commonRef = FirebaseFirestore.instance.collection('allPosts');
final storageRef = FirebaseStorage.instance.ref();

class UploadPdf extends StatefulWidget {
  final GoogleSignInAccount user;
  const UploadPdf({@required this.user});

  @override
  _UploadPdfState createState() => _UploadPdfState();
}

class _UploadPdfState extends State<UploadPdf> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey globalKey = new GlobalKey();

  File image;
  TextEditingController caption;
  TextEditingController link;
  TextEditingController topic;
  String postId = Uuid().v4();
  String pdfUrl;
  String _formatted;

  String buttonText = 'Save';
  bool isLoading = false;

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

  Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    File file = await FilePicker.getFile(type: FileType.custom);
    String fileName = '$randomName.pdf';
    SnackBar snackbar = SnackBar(
      content: Text('Your Pdf is Uploading'),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    savePdf(file.readAsBytesSync(), fileName);
  }

  savePdf(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    pdfUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(pdfUrl);
    SnackBar snackbar = SnackBar(
      content: Text('Your Pdf as Uploaded'),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "Upload Pdf",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height * .05,
              ),
              MaterialButton(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                minWidth: MediaQuery.of(context).size.width * 0.40,
                child: Text(
                  "Upload Pdf",
                  style: TextStyle(fontSize: 20),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  getPdfAndUpload();
                },
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                          uploadData();
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
                          "Discard",
                          style: TextStyle(fontSize: 20),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.pop(context);
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

  DateTime _now;
  uploadData() async {
    SnackBar snackbar1 = SnackBar(
      content: Text('Your Post is Uploading'),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar1);
    feedRef.doc(widget.user.id).collection('userPosts').doc(postId).set({
      'postId': postId,
      'ownerId': widget.user.id,
      'username': widget.user.displayName,
      'code': '<link>' + link.text + '</link>',
      'description': caption.text,
      'dateTime': _now,
      'pdfUrl': pdfUrl,
      'topic': topic.text,
      'imgUrl': "",
      'likes': {},
    });
    commonRef.doc(postId).set({
      'postId': postId,
      'ownerId': widget.user.id,
      'username': widget.user.displayName,
      'code': '<link>' + link.text + '</link>',
      'description': caption.text,
      'dateTime': _now,
      'pdfUrl': pdfUrl,
      'imgUrl': "",
      'topic': topic.text,
      'likes': {},
    });
    SnackBar snackbar = SnackBar(
      content: Text('Your Post as Uploaded'),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
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
