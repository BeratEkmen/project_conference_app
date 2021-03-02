import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_stock_market/helper/helper_functions.dart';
import 'package:project_stock_market/locator.dart';
import 'package:project_stock_market/screens/login_screen.dart';
import 'package:project_stock_market/screens/main_screen.dart';
import 'package:project_stock_market/services/push_notification_services.dart';

import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  UserModel defaultUser;
  final PushNotificationServices _notificationServices =
      locator<PushNotificationServices>();

  void getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  Future<void> getDefaultUser() async {
    await HelperFunctions.getUserModel().then((value) {
      setState(() {
        defaultUser = UserModel.fromJson(value);
      });
    });
  }

  Future getPushNotifications() async {
    _notificationServices.initialise();
  }

  @override
  void initState() {
    getPushNotifications();
    getLoggedInState();
    getDefaultUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Project-Stock-Market",
        home: userIsLoggedIn != null
            ? userIsLoggedIn ? MainScreen.withUser(defaultUser) : LoginScreen()
            : Container(
                child: Center(child: LoginScreen()),
              ));
  }
}
