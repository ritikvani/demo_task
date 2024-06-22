import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task/homeScreen_page.dart';
import 'package:task/social_media_icons.dart';
import 'custom_text_field.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final VoidCallback onSignUpTap;
  LoginPage({required this.onSignUpTap});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _token;
  String? _firstName;
  String? _lastName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
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
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () => _signIn(context),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff007AFF),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Login"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(child: Divider(color: Colors.black)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Or signin with",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff212226)),
                  ),
                ),
                Expanded(child: Divider(color: Colors.black)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  SocialMediaButton(assetPath: 'lib/assets/facebook.png'),
                  SocialMediaButton(assetPath: 'lib/assets/google.png'),
                  SocialMediaButton(assetPath: 'lib/assets/apple.png'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: widget.onSignUpTap,
              child: const Text.rich(
                TextSpan(
                  text: "Don't have an Account?",
                  style: TextStyle(color: Color(0xff949BA5)),
                  children: [
                    TextSpan(
                      text: " Sign up",
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

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var response = await http.post(
          Uri.parse("https://mmfinfotech.co/machine_test/api/userLogin"),
          body: jsonEncode({
            "email": _emailController.text,
            "password": _passwordController.text,
          }),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> responseDecode = jsonDecode(response.body);
          bool responseStatus = responseDecode['status'];
          if (responseStatus == true) {
            _token = responseDecode['record']['authtoken'];
            _firstName = responseDecode['record']['firstName'];
            _lastName = responseDecode['record']['lastName'];

            _emailController.clear();
            _passwordController.clear();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreenPage(token: _token!, firstName: _firstName!, lastName: _lastName!,),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid credentials")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Server error occurred")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
