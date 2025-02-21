import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationServices {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {

      },
      onLaunch: (Map<String, dynamic> message) async {
      },
      onResume: (Map<String, dynamic> message) async {
      },
    );
  }

  addToTopic() {
    _fcm.subscribeToTopic("advisory");
  }
}
