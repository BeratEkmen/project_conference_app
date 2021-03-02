import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_stock_market/locator.dart';
import 'package:project_stock_market/screens/login_screen.dart';
import 'package:project_stock_market/services/auth.dart';
import 'package:project_stock_market/utilities/custom_styles.dart';
import 'package:project_stock_market/utilities/validator.dart';
import 'package:project_stock_market/widgets/flushbar_widget.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with ValidatorMixin {
  var _passwordController = TextEditingController();

  var _emailController = TextEditingController();

  var _passwordConfirmController = TextEditingController();
  final AuthMethods authMethods = locator<AuthMethods>();

  Widget _buildEmailTF(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: CustomStyles.kLabelStyle(size),
        ),
        SizedBox(height: size.height * 0.015),
        Container(
          decoration: CustomStyles.kBoxDecorationStyle(),
          alignment: Alignment.centerLeft,
          height: size.height * 0.09,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: size.height * 0.02),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: "Enter your Email",
              hintStyle: CustomStyles.kHintStyle(size),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPasswordTF(
      {Size size,
      String display,
      String hint,
      TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          display,
          style: CustomStyles.kLabelStyle(size),
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: CustomStyles.kBoxDecorationStyle(),
          height: size.height * 0.09,
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: size.height * 0.02),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: hint,
              hintStyle: CustomStyles.kHintStyle(size),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupBtn(BuildContext context, Size size) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
      child: RaisedButton(
        onPressed: _emailController.text.isEmpty ||
                _passwordConfirmController.text.isEmpty ||
                _passwordController.text.isEmpty
            ? null
            : () async {
                if (!emailValidator(_emailController.text)) {
                  FlushbarWidget.display(context, size, "Invalid email");
                } else if (_passwordController.text.length < 6) {
                  FlushbarWidget.display(context, size,
                      "Password can't be shorter than 6 characters");
                } else if (_passwordController.text !=
                    _passwordConfirmController.text) {
                  FlushbarWidget.display(
                      context, size, "Passwords does not match");
                } else {
                  FlushbarWidget.display(context, size, "Please wait");
                  var result = await authMethods.signUpWithEmailAndPassword(
                      _emailController.text, _passwordController.text);
                  if (result is bool && result == false) {
                    FlushbarWidget.display(
                        context, size, "Email is already in use");
                  } else {
                    FlushbarWidget.display(context, size,
                        "Succesfully signed up, an email verification has been sent (make sure to check spam folder). You will be redirected to login page.");
                    Future.delayed(Duration(seconds: 5), () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ));
                    });
                  }
                }
              },
        child: Text(
          "SIGN UP",
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: size.width * 0.006,
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        elevation: 5.0,
        padding: EdgeInsets.all(size.width * 0.035),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }

  Widget _buildSigninBtn(BuildContext context, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
          text: "Have an account? ",
          style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w400),
        ),
        TextSpan(
          text: "Sign In",
          style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold),
        )
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: CustomStyles.kMainBoxStyle(),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                      vertical: size.height * 0.117),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSan',
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.09,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      _buildEmailTF(size),
                      SizedBox(
                        height: size.height * 0.035,
                      ),
                      _buildPasswordTF(
                        size: size,
                        display: "Password",
                        hint: "Enter your Password",
                        controller: _passwordController,
                      ),
                      SizedBox(
                        height: size.height * 0.035,
                      ),
                      _buildPasswordTF(
                        size: size,
                        display: "Confirm Password",
                        hint: "Confirm Password",
                        controller: _passwordConfirmController,
                      ),
                      SizedBox(
                        height: size.height * 0.035,
                      ),
                      Builder(
                        builder: (context) {
                          return _buildSignupBtn(context, size);
                        },
                      ),
                      _buildSigninBtn(context, size),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
