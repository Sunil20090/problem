import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/user/user_service.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatefulWidget {
  dynamic comment;
  VoidCallback? onLikedClicked;

  CommentItem({super.key, required this.comment, this.onLikedClicked});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  Color avatarBorder = Colors.black;
  bool isSameUser = false;

  @override
  void initState() {
    super.initState();

    isSameUser = widget.comment['commented_by'] == USER_ID;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileThumbnail(
            width: 40,
            height: 40,
            thumnail_url: widget.comment['thumbnail_url'],
            imageUrl: widget.comment['image_url']),
        addHorizontalSpace(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text("${widget.comment['username']}",
                      style: getTextTheme(color: COLOR_PRIMARY).titleSmall),
                  addHorizontalSpace(),
                  Text(
                      "@${timeAgo(widget.comment['created_on'], timezoneOffset: Duration(hours: 5, minutes: 30))}",
                      style: getTextTheme(color: COLOR_BLACK).bodySmall),
                ],
              ),
              Text(
                widget.comment['content'],
                softWrap: true,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: getTextTheme().bodySmall,
              ),
            ],
          ),
        ),
        Column(
          children: [
            addVerticalSpace(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: widget.onLikedClicked,
                    child: widget.comment['isLiked'] == 0
                        ? Icon(Icons.favorite_outline)
                        : Icon(
                            Icons.favorite,
                            color: const Color.fromARGB(255, 241, 140, 140),
                            size: getTextTheme().headlineMedium?.fontSize,
                          )),
                addHorizontalSpace(4),
                Text('${widget.comment['likeCount']}'),
                addHorizontalSpace(),
              ],
            ),
          ],
        )
      ],
    ));
  }
}
