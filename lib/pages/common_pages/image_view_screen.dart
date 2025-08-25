import 'package:Problem/constants/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  final ImageProvider imageProvider;
  final String title;
  final String tag;
  ImageViewScreen(
      {super.key, required this.title, required this.imageProvider, this.tag = 'image_tag'});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          padding: SCREEN_PADDING,
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: tag,
                  child: PhotoView(
                    imageProvider: imageProvider,
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    minScale: PhotoViewComputedScale.contained * 1,
                    maxScale: PhotoViewComputedScale.covered * 3,
                    enableRotation: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
