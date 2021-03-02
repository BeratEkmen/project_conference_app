import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryViewScreen extends StatelessWidget {
  List<String> imageUrls;

  GalleryViewScreen(this.imageUrls);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoViewGallery.builder(
        scrollPhysics: BouncingScrollPhysics(),
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.contained * 2,
            imageProvider: NetworkImage(imageUrls[index]),
          );
        },
      ),
    );
  }
}
