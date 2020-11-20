import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class LogoSvg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: FadeInUp(
        duration: Duration(milliseconds: 1000),
        child: Hero(
          tag: 'logo',
          child: Container(
            height: MediaQuery.of(context).size.height * 0.29,
            child: Image.asset(
              'Assets/Images/logo.png',
              alignment: Alignment.topCenter,
            ),
          ),
        ),
      ),
    );
  }
}
