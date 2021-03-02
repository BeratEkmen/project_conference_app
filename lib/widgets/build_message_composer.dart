import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_stock_market/models/message.dart';
import 'package:project_stock_market/screens/image_editing_screen.dart';
import 'package:project_stock_market/services/database_methods.dart';
import 'package:project_stock_market/utilities/custom_styles.dart';
import 'package:path/path.dart' as Path;

class BuildMessageComposer extends StatefulWidget {
  TextEditingController _controller;

  BuildMessageComposer(this._controller);

  @override
  _BuildMessageComposerState createState() => _BuildMessageComposerState();
}

class _BuildMessageComposerState extends State<BuildMessageComposer> {
  String _newMessage;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  List<String> imageUrls = List<String>();
  bool _showImages = false;

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  Future<List<String>> getUrls() async {
    List<String> urlList = List<String>();
    for (int i = 0; i < images.length; i++) {
      File file = await getImageFileFromAssets(images[i]);
      StorageReference storageRef = FirebaseStorage.instance
          .ref()
          .child('Images/${Path.basename(file.path)}');
      StorageUploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.onComplete;
      String url = await storageRef.getDownloadURL();
      urlList.add(url);
    }
    return urlList;
  }

  //İsteğe göre showImages silinebilir

  Future<void> uploadMessage() async {
    if (images.isNotEmpty && images != null) {
      setState(() {
        _showImages = false;
      });
      imageUrls = await getUrls();
      if (_newMessage != null &&
          !RegExp(r"^\s+$").hasMatch(_newMessage) &&
          _newMessage != "") {
        DatabaseMethods.addMessage(
            Message(body: _newMessage, imageUrls: imageUrls));
      } else {
        DatabaseMethods.addMessage(Message(imageUrls: imageUrls));
      }
    } else if (_newMessage != null &&
        !RegExp(r"^\s+$").hasMatch(_newMessage) &&
        _newMessage != "") {
      DatabaseMethods.addMessage(Message(body: _newMessage));
    }
    setState(() {
      images.clear();
      widget._controller.clear();
      _newMessage = "";
      imageUrls.clear();
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
    if(images.isNotEmpty){
      setState(() {
        _showImages = true;
      });
    }
  }

  Future<void> goToEditing() async {
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ImageEditingScreen(images);
      },
    ));
    if (result == null) {
      setState(() {
        images.removeLast();
      });
    } else if (result == true && images.isNotEmpty) {
      setState(() {
        images = images;
      });
    }
    if (images.isEmpty) {
      setState(() {
        _showImages = false;
      });
    }
  }

  Widget _buildMessageComposer(Size size, BuildContext context) {
    return Column(
      children: [
        _showImages
            ? Container(
                height: size.height * 0.35,
                width: double.infinity,
                child: GestureDetector(
                  onTap: goToEditing,
                  child: Hero(
                    tag: 'imageHero',
                    child: Carousel(
                        autoplay: false,
                        images: List.generate(
                            images.length,
                            (index) => AssetThumb(
                                  asset: images[index],
                                  width: (size.height).toInt(),
                                  height: (size.width).toInt(),
                                ))),
                  ),
                ),
              )
            : Container(),
        Container(
          padding: EdgeInsets.only(
              left: size.width * 0.03,
              right: size.width * 0.03,
              top: size.height * 0.01,
              bottom: size.height * 0.01),
          height: size.height * 0.1,
          width: double.infinity,
          color: Color.fromARGB(255, 220, 220, 220),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      left: size.width * 0.065,
                      right: size.width * 0.005,
                      top: size.height * 0.005,
                      bottom: size.height * 0.005),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.black38,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          style: CustomStyles.kLabelStyle(size),
                          controller: widget._controller,
                          onChanged: (value) {
                            _newMessage = value;
                          },
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your message",
                            hintStyle: CustomStyles.kHintStyle(size),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.image,
                          color: Colors.white,
                          size: size.width * 0.063,
                        ),
                        onPressed: () {
                          loadAssets();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.pinkAccent,
                ),
                child: IconButton(
                  onPressed: () {
                    uploadMessage();
                    FocusManager.instance.primaryFocus.unfocus();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  iconSize: size.width * 0.06,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _buildMessageComposer(size, context);
  }
}
