import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class Message {
  DocumentReference reference;
  String body;
  Timestamp time;
  List<String> imageUrls;

  Message({this.body = "", List<String> imageUrls}) {
    this.time = Timestamp.now();
    if(imageUrls != null) {
      this.imageUrls = List<String>();
      imageUrls.forEach((element) {
        this.imageUrls.add(element);
      });
    }
  }

  Message.fromMap(Map<String, dynamic> map, {this.reference}) {
    assert(map["time"] != null);
    this.body = map["body"];
    this.time = map["time"];
    if(map["imageUrls"] != null){
      List<String> urlList = List<String>();
      List.generate(map["imageUrls"].length,
              (index) => urlList.add(map["imageUrls"][index]));
      this.imageUrls = urlList;
    }
  }

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toMap() {
    //TODO
    return {"body": this.body, "time": this.time, "imageUrls": this.imageUrls};
  }

  String getDate() {
    /*initializeDateFormatting();
    String formattedDate =
        DateFormat("H:mm - E - d.M.yy", Platform.localeName).format(this.time.toDate());*/
    timeago.setLocaleMessages("tr_TR", timeago.TrMessages());
    final DateTime date = time.toDate();
    String formattedDate = timeago.format(date, locale: Platform.localeName);
    return formattedDate;
  }
}
