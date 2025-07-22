import 'package:election/constants/image_constant.dart';
import 'package:flutter/material.dart';

class ProfileThumbnail extends StatefulWidget {
  String? imageUrl;
  double radius, width, height;
  ProfileThumbnail({super.key, this.imageUrl, this.radius = 25, this.width = 50, this.height = 50});

  @override
  State<ProfileThumbnail> createState() => _ProfileThumbnailState();
}

class _ProfileThumbnailState extends State<ProfileThumbnail> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
                  radius: 25,
                  child: ClipOval(
                    child: widget.imageUrl == null 
                      ? Image.asset(IMAGE_PROFILE, width: widget.width, height: widget.height,  fit: BoxFit.cover)
                      : Image.network(widget.imageUrl!,  width: widget.width, height: widget.height,  fit: BoxFit.cover)
                    
                  )
                );
  }
}