import 'package:flutter/material.dart';

class CustomSignInButton extends StatefulWidget {
  final String imageStringUrl;
  final String label;
  final Function function;
  CustomSignInButton({Key key, this.imageStringUrl, this.label, this.function})
      : super(key: key);

  @override
  _CustomSignInButtonState createState() => _CustomSignInButtonState();
}

class _CustomSignInButtonState extends State<CustomSignInButton> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.teal.shade100,
        width: width / 1.5,
        height: height / 15,
        child: RaisedButton(
          onPressed: widget.function,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: widget.imageStringUrl != ''
                        ? Image.asset(widget.imageStringUrl)
                        : null,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          color: Colors.teal.shade500,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
