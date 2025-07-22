import 'package:election/components/profile_thumbnail.dart';
import 'package:election/constants/theme_constant.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class ImageWithTitle extends StatefulWidget {
  final Widget container;
  final String? avatarUrl;
  final String title, description;
  final int solutionCount = 0, ideaCount = 0;
  final VoidCallback? onImagePressed, onAvatarPressed, onInfoPressed;

  const ImageWithTitle(
      {super.key,
      required this.container,
      required this.avatarUrl,
      required this.title,
      required this.description, this.onImagePressed, this.onAvatarPressed, this.onInfoPressed});

  @override
  State<ImageWithTitle> createState() => _ImageWithTitleState();
}

class _ImageWithTitleState extends State<ImageWithTitle> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onImagePressed,
            child: Container(
              color: COLOR_BASE_DARKER,
              height: UI_IMAGE_HEIGHT,
              width: double.infinity,
              child: widget.container,),
          ),
          addVerticalSpace(),
          Row(
            children: [
              addHorizontalSpace(),
              InkWell(
                onTap: widget.onAvatarPressed,
                child: ProfileThumbnail(imageUrl: widget.avatarUrl)
              ),
             addHorizontalSpace(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(widget.title, style: CUSTOM_TEXT_THEME.headlineSmall,),
                      Text(widget.description, softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,)
                  ],
                ),
              ),
              InkWell(
                onTap: widget.onInfoPressed,
                child: Icon(Icons.info)),
              addHorizontalSpace()
            ],
          ),
        ],
      ),
    );
  }
}
