import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopSvg extends StatelessWidget {
  const TopSvg({@required this.top, @required this.tag});
  final String top;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SlideInDown(
        duration: Duration(milliseconds: 1000),
        child: Hero(
          tag: tag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: SvgPicture.asset(
              top,
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
