import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final controller;
  final String label;
  final bool enabled;
  CustomField({this.controller, this.label, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.blue[50],
          filled: true,
          labelText: label,
        ),
        maxLengthEnforced: true,
      ),
    );
  }
}
