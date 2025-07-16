import 'package:election/constants/theme_constant.dart';
import 'package:election/user/user_data.dart';
import 'package:election/utils/common_function.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatefulWidget {
  dynamic comment;
  CommentItem({super.key, required this.comment});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  Color avatarBorder = Colors.black;
  bool isSameUser = false;

  @override
  void initState() {
    super.initState();

    print('Comment item init: ${widget.comment['user_url']}');

    isSameUser = widget.comment['user_name'] == USER_ID;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(isSameUser) Text("@${widget.comment['user_name']}", style: TextStyle(color: COLOR_PRIMARY, fontWeight: FontWeight.bold),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                  child: Image.network(
                widget.comment['user_url'],
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
                    style: CUSTOM_TEXT_THEME.bodySmall,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.favorite_outline),
              addHorizontalSpace(4),
              Text('4'),
              addHorizontalSpace(),
            ],
          )
        ],
      ),
    );
  }
}
