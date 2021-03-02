import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:project_stock_market/services/auth.dart';
import 'package:project_stock_market/utilities/validator.dart';

class ForgotPasswordWidget extends StatelessWidget with ValidatorMixin {
  var _formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text("Forgot your password?",
          style: TextStyle(
            color: Colors.white,
          )),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: emailController,
          validator: forgotPasswordValidator,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: size.width * 0.037,
            ),
            hintText: "Email",
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('EMAIL ME'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              authMethods.resetPassword(emailController.text);
              Navigator.of(context).pop();
              Flushbar(
                onTap: (flushbar) async {
                  await flushbar.dismiss();
                },
                flushbarPosition: FlushbarPosition.BOTTOM,
                messageText: Text(
                  "Recovery password is sent",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.038,
                      fontFamily: 'OpenSans'),
                ),
                duration: Duration(seconds: 3),
                blockBackgroundInteraction: true,
                forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                isDismissible: true,
                borderRadius: 10.0,
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.04),
              ).show(context);
            }
          },
        )
      ],
    );

  }
}
