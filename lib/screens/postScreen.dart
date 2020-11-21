import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Widget/EventCardCustom.dart';

class PostScreen extends StatefulWidget {
  final GoogleSignInAccount user;
  PostScreen(this.user);
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<String> docs = [];

  @override
  void initState() {
    super.initState();
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                child:
                    Text('My Uploads', style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () {
                  setState(() {
                    flag = 1;
                  });
                },
                color: flag == 1 ? Colors.blue[400] : Colors.grey,
              ),
              MaterialButton(
                child: Text('Saved', style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () {
                  setState(() {
                    flag = 0;
                  });
                },
                color: flag == 0 ? Colors.blue[400] : Colors.grey,
              ),
            ],
          ),
        ),
        flag == 0
            ? Container(
                height: height * 0.7,
                width: width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("allPosts")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      for (int i = 0; i < snapshot.data.documents.length; i++) {
                        if (docs.contains(snapshot.data.documents[i]
                                .data()['postId']
                                .toString()) ==
                            true) {
                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) => buildListOfCards(
                                snapshot.data.documents[index],
                                index,
                                height,
                                false),
                          );
                        }
                      }
                      return Text('');
                    }
                  },
                ),
              )
            : Container(
                height: height * 0.7,
                width: width,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.user.id)
                      .collection("userPosts")
                      .orderBy('dateTime', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) => buildListOfCards(
                            snapshot.data.documents[index],
                            index,
                            height,
                            true),
                      );
                    }
                  },
                ),
              )
      ],
    );
  }

  void delete(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.id)
        .collection("userPosts")
        .doc(doc.id)
        .delete();
    await FirebaseFirestore.instance
        .collection("allPosts")
        .doc(doc.id)
        .delete();
    await FirebaseStorage.instance.ref().child('${doc.id}/image').delete();
  }

  void delete2(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance
        .collection("savedPost")
        .doc(widget.user.id)
        .set({
      'saved': FieldValue.arrayRemove([doc.id])
    });
  }

  Widget buildListOfCards(
      DocumentSnapshot document, int index, double height, bool flag) {
    return Column(
      children: [
        Card(
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage:
                  NetworkImage('${document.data()['imgUrl'].toString()}'),
            ),
            title: Text(document.data()['topic']),
            subtitle: Text(
              document.data()['dateTime'].toDate().toString().substring(0, 11),
            ),
            trailing: flag
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[400],
                    ),
                    onPressed:
                        flag ? () => delete(document) : () => delete2(document),
                  )
                : null,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        EventCard(document: document, index: index))),
          ),
        ),
        SizedBox(height: height * 0.005),
      ],
    );
  }
}
