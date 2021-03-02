import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:project_stock_market/models/message.dart';
import 'package:project_stock_market/screens/message_details_screen.dart';
import 'package:project_stock_market/services/database_methods.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildMessages extends StatefulWidget {
  ScrollController _scrollController;

  static ValueNotifier newMessage = ValueNotifier(false);

  BuildMessages(this._scrollController);

  @override
  _BuildMessagesState createState() => _BuildMessagesState();
}

class _BuildMessagesState extends State<BuildMessages> {
  List<DocumentSnapshot> messageList = [];
  bool isLoading = false;
  int _limit = 10;
  DocumentSnapshot lastDocument;
  KeyboardVisibilityNotification _keyboardVisibilityNotification =
      KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  @override
  void initState() {
    widget._scrollController.addListener(() {
      if (widget._scrollController.offset ==
          widget._scrollController.position.maxScrollExtent) {
        setState(() {
          _limit += 10;
        });
      }
    });
    _keyboardState = _keyboardVisibilityNotification.isKeyboardVisible;
    _keyboardVisibilitySubscriberId =
        _keyboardVisibilityNotification.addNewListener(
      onChange: (visible) {
        setState(() {
          _keyboardState = visible;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    widget._scrollController.dispose();
    _keyboardVisibilityNotification
        .removeListener(_keyboardVisibilitySubscriberId);
    super.dispose();
  }

  Future<void> refresh() {
    setState(() {
      _limit = 10;
    });
    return Future.value();
  }

  Widget _buildMessage(DocumentSnapshot messageSnap, Size size) {
    final message = Message.fromSnapshot(messageSnap);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
        if (!_keyboardState) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MessageDetailsScreen(message);
            },
          ));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.009),
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06, vertical: size.height * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                    "https://www.woolha.com/media/2020/03/flutter-circleavatar-minradius-maxradius.jpg"),
              ),
              trailing: Text(
                message.getDate(),
                style: TextStyle(
                    fontSize: size.width * 0.036, color: Colors.blueGrey),
              ),
              title: Text(
                "Admin",
                style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: size.height * 0.003,
            ),
            Linkify(
              text: message.body,
              style:
                  TextStyle(fontSize: size.width * 0.044, color: Colors.black),
              onOpen: _openLinkHandler,
            ),
            message.imageUrls == null
                ? Container()
                : Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(0),
                    height: size.height * 0.45,
                    width: size.width,
                    child: CarouselSlider(
                        items: _buildImages(message, size),
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          enableInfiniteScroll: false,
                          autoPlay: false,
                          height: size.height * 0.4,
                        )),
                  ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildImages(Message message, Size size) {
    return message.imageUrls.map((url) {
      return Container(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: size.width,
                    height: size.height,
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ],
              )),
        ),
      );
    }).toList();
  }

  Future<void> _openLinkHandler(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw "Could not open $link";
    }
  }

  Widget _buildMessageList(
      BuildContext context, Size size, List<DocumentSnapshot> snapshot) {
    messageList = snapshot;
    if (snapshot.isNotEmpty) {
      lastDocument = snapshot[0];
    }
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: widget._scrollController,
        itemCount: messageList.length,
        itemBuilder: (context, index) {
          final messageSnap = messageList[index];
          return _buildMessage(messageSnap, size);
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseMethods.getSnapshots(_limit),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            messageList = snapshot.data.docs;
            return RefreshIndicator(
                onRefresh: refresh,
                child: _buildMessageList(context, size, messageList));
          }
        });
  }
}
