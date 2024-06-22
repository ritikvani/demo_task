import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.labelText,
    required this.hintText,
    this.isPassword = false,
    required this.controller,
    required this.validator,
  });

  OutlineInputBorder _getBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        hintText: hintText,
        enabledBorder: _getBorder(Colors.grey),
        focusedBorder: _getBorder(Colors.black),
        errorBorder: _getBorder(Colors.red),
        focusedErrorBorder: _getBorder(Colors.red),
      ),
      obscureText: isPassword,
      validator: validator,
    );
  }
}
