import 'dart:io';

import 'package:election/constants/image_constant.dart';
import 'package:flutter/material.dart';

class ProfileThumbnail extends StatefulWidget {
  final String? imageUrl, thumnail_url;
  final File? file;
  final double radius, width, height;
  ProfileThumbnail(
      {super.key,
      this.imageUrl,
      this.thumnail_url,
      this.file,
      this.radius = 25,
      this.width = 50,
      this.height = 50});

  @override
  State<ProfileThumbnail> createState() => _ProfileThumbnailState();
}

class _ProfileThumbnailState extends State<ProfileThumbnail> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: widget.radius,
        child: ClipOval(
            child: widget.imageUrl == null
                ? (widget.file == null) ? Image.asset(IMAGE_PROFILE,
                    width: widget.width,
                    height: widget.height,
                    fit: BoxFit.cover)
                    : Image.file(widget.file!, width: widget.width,
                        height: widget.height,
                        fit: BoxFit.cover)
                : FadeInImage(
                  placeholder: Image.network(widget.thumnail_url!).image, 
                  image: Image.network(widget.imageUrl!).image) 

        ));
                      
  }
}
