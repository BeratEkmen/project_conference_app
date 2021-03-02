

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:project_stock_market/models/message.dart';
import 'package:project_stock_market/screens/gallery_view_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageDetailsScreen extends StatelessWidget {
  Message message;

  MessageDetailsScreen(this.message);

  Widget _buildMessage(Size size, BuildContext context) {
    return Container(
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
            style: TextStyle(fontSize: size.width * 0.044, color: Colors.black),
            onOpen: _openLinkHandler,
          ),
          message.imageUrls == null
              ? Container()
              : Container(
                  padding: EdgeInsets.all(0),
                  height: size.height * 0.45,
                  width: size.width,
                  child: CarouselSlider(
                      items: _buildImages(message, size, context),
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        height: size.height * 0.4,
                      )),
                )
        ],
      ),
    );
  }

  List<Widget> _buildImages(Message message, Size size, BuildContext context) {
    return message.imageUrls.map((url) {
      return Container(
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return GalleryViewScreen(message.imageUrls);
            },));
          },
          child: Container(
            margin: EdgeInsets.all(size.width * 0.01),
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
                            vertical: size.height * 0.001, horizontal: size.width * 0.01),
                      ),
                    ),
                  ],
                )),
          ),
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF73AEF5),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF73AEF5),
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
            color: Colors.white,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: ListView(
            children: [_buildMessage(size, context)],
          ),
        )
      ]),
    );
  }
}
