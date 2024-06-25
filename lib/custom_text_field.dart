import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool? readOnly ;

  const CustomTextField({
    required this.labelText,
    required this.hintText,
    this.isPassword = false,
    required this.controller,
    required this.validator,
    this.keyboardType,
    this.maxLength, this.readOnly = false ,
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
      keyboardType: keyboardType,
      maxLength: maxLength,
      readOnly: readOnly!,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
