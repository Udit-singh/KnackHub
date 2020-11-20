import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class PDFListBody extends StatefulWidget {
  final String url;
  const PDFListBody({Key key, @required this.url}) : super(key: key);
  @override
  _PDFListBodyState createState() => _PDFListBodyState();
}

class _PDFListBodyState extends State<PDFListBody> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: PDF.network(
          widget.url,
          height: height,
          width: width,
        ),
      ),
    );
  }
}
