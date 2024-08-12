import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged; // Add this line

  CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.textInputType,
    this.textInputAction,
    this.onChanged, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onChanged: onChanged, // Add this line
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
