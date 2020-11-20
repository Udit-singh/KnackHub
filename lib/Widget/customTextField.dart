import 'package:KnackHub/constants/text.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType inputType;
  final bool readonly;
  final TextEditingController textEditingController;

  CustomTextField({
    @required this.inputType,
    this.readonly = false,
    @required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.07,
      width: width * 0.580,
      child: TextFormField(
        controller: textEditingController,
        readOnly: readonly,
        keyboardType: inputType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: CustomTextFieldLabel,
        textAlign: TextAlign.start,
      ),
    );
  }
}
