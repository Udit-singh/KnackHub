import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        buttonColor: Colors.white,
        backgroundColor: Colors.orange.shade50,
      ),
      debugShowCheckedModeBanner: false,
      title: 'KnackHub',
    );
  }
}
