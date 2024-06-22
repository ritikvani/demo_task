import 'package:flutter/material.dart';
import 'logIn_page.dart';
import 'signUp_page.dart';


class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD8F1FE),
     resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => isLogin = true),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Sign in",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                    isLogin ? Colors.black : Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 2,
                                width: 100,
                                color: isLogin
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => isLogin = false),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Sign up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                    !isLogin ? Colors.black : Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 2,
                                width: 100,
                                color: !isLogin
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                if (isLogin)
                  LoginPage(onSignUpTap: () => setState(() => isLogin = false))
                else
                  SignupPage(onSignInTap: () => setState(() => isLogin = true)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
