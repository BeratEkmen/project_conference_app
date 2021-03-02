
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_stock_market/models/message.dart';
import 'package:project_stock_market/models/user_model.dart';

class DatabaseMethods {

  static Stream<QuerySnapshot> getSnapshots(int size) {
    return FirebaseFirestore.instance.collection("messages").orderBy("time", descending: true).limit(size).snapshots();
  }

  static Future<QuerySnapshot> getMessages() async{
    return await FirebaseFirestore.instance.collection("messages").orderBy("time", descending: true).limit(10).get();
  }

  static Future<QuerySnapshot> getNextMessages(DocumentSnapshot lastSnap) async{
    return await FirebaseFirestore.instance.collection("messages").orderBy("time", descending: true).limit(10).startAfterDocument(lastSnap).get();
  }

  static void addMessage(Message message) {
    FirebaseFirestore.instance.collection("messages").doc().set(message.toMap());
  }

  static void addUser(UserModel user) {
    FirebaseFirestore.instance.collection("user").doc().set(user.toJson());
  }
}