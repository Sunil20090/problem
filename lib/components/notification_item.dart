import 'package:Problem/constants/theme_constant.dart';
import 'package:Problem/pages/common_pages/image_view_screen.dart';
import 'package:Problem/utils/common_function.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {
  dynamic notification;
  NotificationItem({super.key, required this.notification});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ImageViewScreen(
                            imageProvider: FadeInImage(
                              placeholder: NetworkImage(
                                  widget.notification['thumbnail_url']),
                              image: NetworkImage(
                                  widget.notification['image_url']),
                              fit: BoxFit.cover,
                            ).image,
                            title: 'Image',
                          )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 50,
                child: FadeInImage(
                  placeholder:
                      NetworkImage(widget.notification['thumbnail_url']),
                  image: NetworkImage(widget.notification['image_url']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          addHorizontalSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '@${timeAgo(widget.notification['created_at'], timezoneOffset: Duration(hours: 5, minutes: 30))}'),
                Text(
                  widget.notification['content'],
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('#${widget.notification['problem_title']}',
                    style: getTextTheme(color: COLOR_PRIMARY).titleSmall),
                addVerticalSpace(20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
