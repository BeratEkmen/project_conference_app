import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageEditingScreen extends StatefulWidget {
  List<Asset> images;

  ImageEditingScreen(this.images);

  @override
  _ImageEditingScreenState createState() => _ImageEditingScreenState();
}

class _ImageEditingScreenState extends State<ImageEditingScreen> {
  int _selectedIndex = 0;
  List<String> _choices = ["Delete"];
  bool _isDeleted = false;

  void deleteItem(String value) {
    if (value == "Delete") {
      if (widget.images.length > 1) {
        setState(() {
          _isDeleted = true;
          widget.images.removeAt(_selectedIndex);
        });
      } else {
        Navigator.pop(context, null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _isDeleted);
        return Future.value();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: () => Navigator.pop(context, _isDeleted),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: deleteItem,
              itemBuilder: (context) {
                return List.generate(
                    1,
                    (index) =>
                        PopupMenuItem(value: _choices[0], child: Text("Delete")));
              },
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Hero(
          tag: 'imageHero',
          child: Carousel(
            autoplay: false,
            onImageChange: (int x, int y) {
              if (widget.images.length != 1) {
                setState(() {
                  _selectedIndex = y;
                });
              }
            },
            images: List.generate(
                widget.images.length,
                (index) => AssetThumb(
                      asset: widget.images[index],
                      width: size.width.toInt(),
                      height: size.height.toInt(),
                    )),
          ),
        ),
      ),
    );
  }
}
