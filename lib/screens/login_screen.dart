import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_stock_market/helper/helper_functions.dart';
import 'package:project_stock_market/screens/main_screen.dart';
import 'package:project_stock_market/screens/signup_screen.dart';
import 'package:project_stock_market/screens/verify_email_screen.dart';
import 'package:project_stock_market/services/auth.dart';
import 'package:project_stock_market/utilities/custom_styles.dart';
import 'package:project_stock_market/utilities/validator.dart';
import 'package:project_stock_market/widgets/flushbar_widget.dart';
import 'package:project_stock_market/widgets/forgot_password_widget.dart';

import '../locator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidatorMixin {
  bool _rememberMe = false;
  var txtPassword = TextEditingController();
  var txtEmail = TextEditingController();
  final AuthMethods authMethods = locator<AuthMethods>();

  Widget _buildEmailTF(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: CustomStyles.kLabelStyle(size),
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Container(
          decoration: CustomStyles.kBoxDecorationStyle(),
          height: size.height * 0.09,
          alignment: Alignment.centerLeft,
          child: TextFormField(
            controller: txtEmail,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                  top: size.height * 0.02, left: size.width * 0.11),
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

  Widget _buildPasswordTF(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: CustomStyles.kLabelStyle(size),
        ),
        SizedBox(
          height: size.height * 0.015,
        ),
        Container(
          decoration: CustomStyles.kBoxDecorationStyle(),
          height: size.height * 0.09,
          alignment: Alignment.centerLeft,
          child: TextFormField(
            controller: txtPassword,
            obscureText: true,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                  top: size.height * 0.02, left: size.width * 0.11),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: "Enter your Password",
              hintStyle: CustomStyles.kHintStyle(size),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForgotPasswordBtn(BuildContext context, Size size) {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        padding: EdgeInsets.only(right: 0.0),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return ForgotPasswordWidget();
            },
          );
        },
        child: Text(
          "Forgot Password?",
          style: CustomStyles.kLabelStyle(size),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox(Size size) {
    return Container(
      height: size.height * 0.05,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Color(0xFF478DE0),
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _rememberMe = !_rememberMe;
              });
            },
            child: Text(
              "Remember Me",
              style: CustomStyles.kLabelStyle(size),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginBtn(Size size, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
      child: RaisedButton(
        elevation: 5.0,
        padding: EdgeInsets.all(size.width * 0.035),
        onPressed: txtEmail.text.isEmpty || txtPassword.text.isEmpty
            ? null
            : () async {
                if (emailValidator(txtEmail.text)) {
                  var result = await authMethods.signInWithEmailAndPassword(
                      txtEmail.text, txtPassword.text);
                  if (result is bool && result == false) {
                    FlushbarWidget.display(
                        context, size, "Incorrect email or password");
                  } else {
                    FlushbarWidget.display(context, size, "Succesfully logged in. Please wait");
                    Future.delayed(Duration(seconds: 3), (){
                      HelperFunctions.saveUserLoggedInSharedPreference(_rememberMe);
                      if(_rememberMe){
                        HelperFunctions.saveUserModel(result);
                      }
                      if(result.verified){
                        HelperFunctions.saveUserLoggedInSharedPreference(_rememberMe);
                        HelperFunctions.saveUserModel(result);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return MainScreen.withUser(result);
                        },));
                      }else{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return VerifyEmailScreen(result, _rememberMe);
                        },));
                      }
                    });
                  }
                } else {
                  FlushbarWidget.display(
                      context, size, "Incorrect email or password");
                }
              },
        child: Text(
          "LOGIN",
          style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: size.width * 0.006,
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }

  Widget _buildSignupBtn(Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return SignupScreen();
          },
        ));
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w400,
              )),
          TextSpan(
              text: "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              )),
        ]),
      ),
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
                  padding: EdgeInsets.only(
                    left: size.width * 0.08,
                    right: size.width * 0.08,
                    top: size.height * 0.1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.09,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Column(
                        children: [
                          _buildEmailTF(size),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          _buildPasswordTF(size),
                        ],
                      ),
                      _buildForgotPasswordBtn(context, size),
                      _buildRememberMeCheckbox(size),
                      SizedBox(height: size.height * 0.02,),
                      Builder(builder: (context) {
                        return _buildLoginBtn(size, context);
                      }),
                      SizedBox(height: size.height * 0.1,),
                      _buildSignupBtn(size),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
