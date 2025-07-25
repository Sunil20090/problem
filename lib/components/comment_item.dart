import 'package:election/constants/theme_constant.dart';
import 'package:election/user/user_data.dart';
import 'package:election/utils/common_function.dart';
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

    isSameUser = widget.comment['username'] == USER_ID;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(isSameUser) Text("@${widget.comment['username']}", style: TextStyle(color: COLOR_PRIMARY, fontWeight: FontWeight.bold),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                  child: Image.network(
                widget.comment['thumbnail'],
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    softWrap: true,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    widget.comment['content'],
                    style: getTextTheme().bodySmall,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: widget.onLikedClicked,
                child: widget.comment['isLiked'] == 0
                ? Icon(Icons.favorite_outline)
                : Icon(Icons.favorite, color: const Color.fromARGB(255, 241, 140, 140),)
                ),
              addHorizontalSpace(4),
              Text('${widget.comment['likeCount']}'),
              addHorizontalSpace(),
            ],
          )
        ],
      ),
    );
  }
}
