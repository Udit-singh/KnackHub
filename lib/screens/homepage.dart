import 'package:KnackHub/Widget/EventCardCustom.dart';
import 'package:KnackHub/screens/chat_screen.dart';
import 'package:KnackHub/screens/comment.dart';
import 'package:KnackHub/screens/postScreen.dart';
import 'package:KnackHub/screens/upload.dart';
import 'package:KnackHub/screens/uploadpdf.dart';
import 'package:KnackHub/screens/userProfile.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

var ht = 0.0;

class Homepage extends StatefulWidget {
  final GoogleSignInAccount user;
  Homepage({Key key, @required this.user});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  List<Widget> fancyCards;
  TextEditingController query;
  TextEditingController comment;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    query = TextEditingController();
    comment = TextEditingController();
    print(query.text);
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      print(index);
    });
  }

  void handleTakePhoto() async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } catch (platformException) {
      print("not allowing " + platformException);
    }

    setState(() {
      if (image != null) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Upload(
              image: image,
              user: widget.user,
            ),
          ),
        );
      } else {
        print("error");
      }
    });
  }

  void handleTakePhoto1() async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } catch (platformException) {
      print("not allowing " + platformException);
    }

    setState(() {
      if (image != null) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Upload(
              image: image,
              user: widget.user,
            ),
          ),
        );
      } else {
        print("error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    fancyCards = [];
    var height = MediaQuery.of(context).size.height;
    ht = height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.orange.shade50,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectImage(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.orange.shade900,
        ),
        backgroundColor: Colors.teal.shade100,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        fabLocation: BubbleBottomBarFabLocation.end,
        hasNotch: false,
        opacity: .05,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                5)), //border radius doesn't work when the notch is enabled.
        elevation: 12,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.deepPurple,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.teal,
              icon: Icon(
                Icons.chat,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.chat,
                color: Colors.blueAccent,
              ),
              title: Text("Connect")),
          BubbleBottomBarItem(
              backgroundColor: Colors.teal,
              icon: Icon(
                Icons.post_add,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.post_add,
                color: Colors.red,
              ),
              title: Text("Posts")),
          BubbleBottomBarItem(
              backgroundColor: Colors.teal,
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.person,
                color: Colors.teal,
              ),
              title: Text("Profile"))
        ],
      ),
      body: currentIndex == 0
          ? SafeArea(
              child: query.text == ""
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("allPosts")
                          .orderBy('dateTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          fancyCards = [];
                          var data = snapshot.data.documents;
                          for (int i = 0; i < data.length; i++) {
                            buildListOfCards(
                                snapshot.data.docs[i], i, height, width);
                          }
                          return Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.05),
                                child: StackedCardCarousel(
                                  spaceBetweenItems: height * 0.47,
                                  items: fancyCards,
                                  type: StackedCardCarouselType.fadeOutStack,
                                ),
                              ),
                              new Positioned(
                                top: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: AppBar(
                                  leading: Icon(Icons.search),
                                  title: TextField(
                                    controller: query,
                                    enabled: true,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                  ),
                                  actions: [
                                    IconButton(
                                      onPressed: () => query.clear(),
                                      icon: Icon(Icons.cancel),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('allPosts')
                          .orderBy('dateTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          fancyCards = [];
                          // print(snapshot.data.docs[i].data()['topic']);
                          var data = snapshot.data.documents;
                          int count = 0;
                          for (int i = 0; i < data.length; i++) {
                            if (snapshot.data.docs[i]
                                    .data()['topic']
                                    .toString()
                                    .toLowerCase() ==
                                query.text.toLowerCase()) {
                              count++;
                            }
                          }
                          if (count != 0) {
                            for (int i = 0; i < data.length; i++) {
                              if (snapshot.data.docs[i]
                                      .data()['topic']
                                      .toString()
                                      .toLowerCase() ==
                                  query.text.toLowerCase()) {
                                buildListOfCards(
                                    snapshot.data.docs[i], i, height, width);
                              }
                            }
                          }
                          return Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.05),
                                child: count != 0
                                    ? StackedCardCarousel(
                                        spaceBetweenItems: height * 0.47,
                                        items: fancyCards,
                                        type: StackedCardCarouselType
                                            .fadeOutStack,
                                      )
                                    : Center(
                                        child: Text(
                                          'Nothing on the searched topic.\nBe the first one to post on it!',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ),
                              Container(
                                width: double.infinity,
                                height: height * .08,
                                child: AppBar(
                                  leading: Icon(Icons.search),
                                  title: TextField(
                                    controller: query,
                                    enabled: true,
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                  ),
                                  actions: [
                                    IconButton(
                                      onPressed: () => query.clear(),
                                      icon: Icon(Icons.cancel),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
            )
          : currentIndex == 1
              ? SafeArea(
                  child: ChatScreen(),
                )
              : currentIndex == 2
                  ? SafeArea(
                      child: PostScreen(widget.user),
                    )
                  : SafeArea(
                      child: Userdata(user: widget.user),
                    ),
    );
  }

  void savePost(DocumentSnapshot document) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('savedPost')
        .doc(widget.user.id)
        .get();
    if (doc.exists) {
      await FirebaseFirestore.instance
          .collection('savedPost')
          .doc(widget.user.id)
          .update({
        'saved': FieldValue.arrayUnion([document.id])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('savedPost')
          .doc(widget.user.id)
          .set({
        'saved': FieldValue.arrayUnion([document.id])
      });
    }
  }

  buildListOfCards(
      DocumentSnapshot document, int index, double height, double width) {
    if (document.data()['imgUrl'].isEmpty) {
      loading = false;
    }
    return fancyCards.add(
      GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => EventCard(document: document, index: index)),
              (route) => true);
        },
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: height * 0.29,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(fit: StackFit.expand, children: [
                    Align(
                        alignment: Alignment.center,
                        child:
                            loading ? CircularProgressIndicator() : Center()),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: document.data()['imgUrl'].isNotEmpty
                          ? Image.network(
                              document.data()['imgUrl'],
                              fit: BoxFit.fill,
                              alignment: Alignment.topCenter,
                            )
                          : Center(
                              child: Text("Image not available"),
                            ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            document.data()['username'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 25.0, 0.0),
                                child: Text(
                                  document.data()['topic'],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                          icon: Icon(Icons.archive),
                          onPressed: () => savePost(document)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LikeButton(
                        size: 35,
                        circleColor: CircleColor(
                            start: Color(0xff00ddff), end: Color(0xff0099cc)),
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: Color(0xff33b5e5),
                          dotSecondaryColor: Color(0xff0099cc),
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.thumb_up,
                            color:
                                isLiked ? Colors.yellow.shade800 : Colors.grey,
                            size: 25,
                          );
                        },
                        likeCount: 0,
                        countBuilder: (int count, bool isLiked, String text) {
                          var color =
                              isLiked ? Colors.deepPurpleAccent : Colors.grey;
                          Widget result;
                          if (count == 0) {
                            result = Text(
                              "Like",
                              style: TextStyle(color: color),
                            );
                          } else
                            result = Text(
                              text,
                              style: TextStyle(color: color),
                            );
                          return result;
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => Comments(
                              postId: document.data()['postId'],
                              user: widget.user,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: MaterialButton(
                            child: Text('Report'),
                            onPressed: () {
                              print(document.data()['postId']);
                              FirebaseFirestore.instance
                                  .collection('report')
                                  .doc(widget.user.displayName)
                                  .set({
                                'reported': FieldValue.arrayUnion(
                                    [document.data()['postId'].toString()])
                              });
                              SnackBar snackbar = SnackBar(
                                content: Text('This Post has been reported'),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackbar);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildSearchListOfCards(DocumentSnapshot document, int index, double height) {
    return fancyCards.add(
      GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => EventCard(document: document, index: index)),
              (route) => true);
        },
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(children: <Widget>[
              Container(
                height: height * 0.29,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(fit: StackFit.expand, children: [
                  Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      document.data()['imgUrl'],
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      document.data()['username'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text('Create Post'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Image from Camera'),
              onPressed: handleTakePhoto,
            ),
            SimpleDialogOption(
              child: Text('Image from Gallery'),
              onPressed: handleTakePhoto1,
            ),
            SimpleDialogOption(
              child: Text('Upload PDF'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UploadPdf(
                      user: widget.user,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
