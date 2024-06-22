import 'dart:convert';
import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatelessWidget {
  final VoidCallback onSignInTap;

  SignupPage({Key? key, required this.onSignInTap}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController(text: '+91'); // Default country code
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              labelText: 'First Name',
              hintText: 'Enter your first name',
              controller: _firstNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Last Name',
              hintText: 'Enter your last name',
              controller: _lastNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Country Code',
              hintText: 'Enter your country code',
              controller: _countryCodeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your country code';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              controller: _phoneNoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'E-mail',
              hintText: 'Enter your email',
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Password',
              hintText: 'Enter your password',
              isPassword: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              isPassword: true,
              controller: _confirmPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  _signUp(context);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff007AFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Sign Up"),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onSignInTap,
              child: const Text.rich(
                TextSpan(
                  text: "Already have an Account?",
                  style: TextStyle(color: Color(0xff949BA5)),
                  children: [
                    TextSpan(
                      text: " Sign in",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5096F1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        var response = await http.post(
          Uri.parse("https://mmfinfotech.co/machine_test/api/userRegister"),
          body: jsonEncode({
            "first_name": _firstNameController.text,
            "last_name": _lastNameController.text,
            "country_code": _countryCodeController.text,
            "phone_no": _phoneNoController.text,
            "email": _emailController.text,
            "password": _passwordController.text,
            "confirm_password": _confirmPasswordController.text,
          }),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> responseDecode = jsonDecode(response.body);
          var responseStatus = responseDecode['status'];

          if (responseStatus) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration Successful')),
            );

            // Clear the text fields
            _firstNameController.clear();
            _lastNameController.clear();
            _countryCodeController.clear();
            _phoneNoController.clear();
            _emailController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();

            // Shift to the sign-in screen
            onSignInTap();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration failed: ${responseDecode['message']}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error occurred: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
