

const functions = require('firebase-functions');
const admin = require('firebase-admin')
admin.initializeApp()

const db = admin.firestore();
const fcm = admin.messaging();

exports.sendNotification = functions.firestore
  .document("messages/{messageId}").onCreate(async snapshot => {
    const message = snapshot.data();
    const payload = {
      notification: {
        title: "New message",
        body: `${message.body}`,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      }
    };
    return fcm.sendToTopic('advisory', payload);
  });