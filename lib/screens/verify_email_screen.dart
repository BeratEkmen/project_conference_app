import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_stock_market/helper/helper_functions.dart';
import 'package:project_stock_market/locator.dart';
import 'package:project_stock_market/models/user_model.dart';
import 'package:project_stock_market/screens/main_screen.dart';
import 'package:project_stock_market/services/database_methods.dart';
import 'package:project_stock_market/services/push_notification_services.dart';
import 'package:project_stock_market/utilities/custom_styles.dart';

class VerifyEmailScreen extends StatefulWidget {
  UserModel userModel;
  bool _rememberMe;
  VerifyEmailScreen(this.userModel, this._rememberMe);
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isUserEmailVerified = false;
  Timer _timer;
  PushNotificationServices pushNotificationServices = locator<PushNotificationServices>();
  @override
  void initState() {
    Future(() async {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        await FirebaseAuth.instance.currentUser.reload();
        var user = await FirebaseAuth.instance.currentUser;
        if (user.emailVerified) {
          setState(() {
            _isUserEmailVerified = user.emailVerified;
          });
          timer.cancel();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Stack(children: [
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
                  top: size.height * 0.15,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Verify your email to continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.09,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.25,
                      ),
                      !_isUserEmailVerified
                          ? CircularProgressIndicator(backgroundColor: Colors.white,)
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.025),
                              child: RaisedButton(
                                elevation: 5.0,
                                padding: EdgeInsets.all(size.width * 0.035),
                                onPressed: () {
                                  widget.userModel.verified = true;
                                  HelperFunctions.saveUserLoggedInSharedPreference(widget._rememberMe);
                                  DatabaseMethods.addUser(widget.userModel);
                                  pushNotificationServices.addToTopic();
                                  if(widget._rememberMe){
                                    HelperFunctions.saveUserModel(widget.userModel);
                                  }
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return MainScreen.withUser(widget.userModel);
                                    },
                                  ));
                                },
                                child: Text(
                                  "CONTINUE",
                                  style: TextStyle(
                                      color: Color(0xFF527DAA),
                                      letterSpacing: size.width * 0.006,
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans'),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                              ),
                            ),
                    ])),
          ),
        ]),
      ),
    );
  }
}
