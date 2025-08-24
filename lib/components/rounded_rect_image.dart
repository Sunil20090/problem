import 'package:flutter/material.dart';

class RoundedRectImage extends StatefulWidget {
  final double width, height;
  final String thumbnail_url, image_url;
  const RoundedRectImage({super.key, this.width = 80, this.height = 50, required this.image_url, required this.thumbnail_url});
  @override
  State<RoundedRectImage> createState() => _RoundedRectImageState();
}

class _RoundedRectImageState extends State<RoundedRectImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: FadeInImage(
          placeholder: NetworkImage(widget.thumbnail_url),
          image: NetworkImage(widget.image_url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
