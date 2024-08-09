import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.textInputType,
    this.textInputAction,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
