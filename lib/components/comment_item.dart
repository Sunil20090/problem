import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/user/user_data.dart';
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

    print('Comment item init: ${widget.comment['thumbnail']}');

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
            thumnail_url: widget.comment['thumnail_url'],
            imageUrl: widget.comment['image_url']),
        addHorizontalSpace(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "@${widget.comment['username']}",
              style:
                  TextStyle(color: COLOR_PRIMARY, fontWeight: FontWeight.bold),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  breakLongWords(widget.comment['content']),
                  softWrap: true,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: getTextTheme().bodySmall,
                )),
          ],
        ),
        Spacer(),
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
                      )),
            addHorizontalSpace(4),
            Text('${widget.comment['likeCount']}'),
            addHorizontalSpace(),
          ],
        )
      ],
    ));
  }

  String breakLongWords(String text, {int maxWordLength = 20}) {
    final regex = RegExp('.{1,$maxWordLength}');
    return text.replaceAllMapped(
      RegExp(r'\S{' + maxWordLength.toString() + ',}'),
      (match) =>
          match.group(0)!.replaceAllMapped(regex, (m) => '${m.group(0)}\u200B'),
    );
  }
}
