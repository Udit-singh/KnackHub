import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:share/share.dart';

import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:KnackHub/screens/ViewPdf.dart';

class EventCard extends StatefulWidget {
  final DocumentSnapshot document;
  final int index;
  EventCard({Key key, @required this.document, @required this.index})
      : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final date = DateTime.now();

  @override
  void initState() {
    super.initState();

    saveimg();
  }

  @override
  void dispose() {
    super.dispose();
  }

  saveimg() async {
    var response = await get(widget.document.data()['imgUrl']);
    Directory temp = await getTemporaryDirectory();
    File imageFile = File(join(temp.path, 'Image.png'));
    imageFile.writeAsBytesSync(response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      color: Colors.blue[900],
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: height * 0.86,
                  child: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              height: height * .55,
                              width: width * .9,
                              child: Stack(fit: StackFit.expand, children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator()),
                                Image.network(
                                  widget.document.data()['imgUrl'],
                                  fit: BoxFit.fill,
                                  alignment: Alignment.center,
                                ),
                              ]),
                            ),
                            SizedBox(height: 6),
                            Container(
                              height: height * .065,
                              width: width,
                              color: Color(0xFFD8EFFF),
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Uploaded By : " +
                                        widget.document.get("username"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  IconButton(
                                    color: Colors.blue[900],
                                    icon: Icon(
                                      Icons.file_download,
                                      size: 30,
                                    ),
                                    onPressed: () => {
                                      if (widget.document
                                          .get('pdfUrl')
                                          .isNotEmpty)
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          PDFListBody(
                                                            url: widget.document
                                                                .get('pdfUrl'),
                                                          )))
                                        }
                                    },
                                  ),
                                  IconButton(
                                    color: Colors.blue[900],
                                    icon: Icon(
                                      Icons.share,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      Directory temp =
                                          await getTemporaryDirectory();
                                      final RenderBox box =
                                          context.findRenderObject();
                                      Share.shareFiles(
                                          [join(temp.path, 'Image.png')],
                                          subject:
                                              widget.document.data()['topic'],
                                          text:
                                              "${widget.document.data()['description']}"
                                                  .replaceAll("\\n", "\n"),
                                          sharePositionOrigin:
                                              box.localToGlobal(Offset.zero) &
                                                  box.size);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              height: height * .065,
                              width: width,
                              color: Color(0xFFD8EFFF),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat.jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(widget
                                              .document
                                              .data()['dateTime']
                                              .seconds *
                                          1000),
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.yMMMd()
                                        .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                widget.document
                                                        .data()['dateTime']
                                                        .seconds *
                                                    1000))
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: StyledText(
                                text: (widget.document.data()['description'])
                                    .replaceAll("\\n", "\n")
                                    .toString(),
                                newLineAsBreaks: true,
                                textAlign: TextAlign.justify,
                                style:
                                    TextStyle(fontSize: 16, letterSpacing: 1),
                                styles: {
                                  'bold':
                                      TextStyle(fontWeight: FontWeight.w700),
                                  'link': ActionTextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                      onTap: (_, attrs) async {
                                        if (await canLaunch(
                                            attrs['href'].toString())) {
                                          await launch(
                                              attrs['href'].toString());
                                        } else {
                                          throw 'Could not launch link';
                                        }
                                      }),
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                                height: height * .065,
                                width: width,
                                color: Color(0xFFD8EFFF),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Topic - " +
                                          widget.document.data()['topic'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Likes" +
                                          widget.document
                                              .data()['likes']
                                              .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                )),
                            SizedBox(height: 6),
                            Container(
                              height: height * .065,
                              width: width,
                              color: Color(0xFFD8EFFF),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              child: Text(
                                "Link",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: StyledText(
                                text: (widget.document.data()['code'])
                                    .replaceAll("\\n", "\n")
                                    .toString(),
                                newLineAsBreaks: true,
                                textAlign: TextAlign.justify,
                                style:
                                    TextStyle(fontSize: 16, letterSpacing: 1),
                                styles: {
                                  'bold':
                                      TextStyle(fontWeight: FontWeight.w700),
                                  'link': ActionTextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                      onTap: (_, attrs) async {
                                        if (await canLaunch(
                                            attrs['href'].toString())) {
                                          await launch(
                                              attrs['href'].toString());
                                        } else {
                                          throw 'Could not launch link';
                                        }
                                      }),
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
