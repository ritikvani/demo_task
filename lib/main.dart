import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'homeScreen_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,

      home: AuthPage(),
    );
  }
}
