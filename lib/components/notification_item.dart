import 'package:Problem/components/profile_thumbnail.dart';
import 'package:Problem/constants/theme_constant.dart';
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
          ProfileThumbnail(),
          addHorizontalSpace(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${timeAgo(widget.notification['created_at'], timezoneOffset: Duration(hours: 5, minutes: 30))}'),
                (widget.notification['is_fetched'] == 1) 
                ? Text(
                    widget.notification['content'],
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                : Text(
                    widget.notification['content'],
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: getTextTheme().titleSmall,
                  ),

                Text('by: ${widget.notification['triggered_by']}', 
                style: getTextTheme(color: COLOR_PRIMARY).bodySmall),
                addVerticalSpace(20)

              ],
            ),
          ),
        ],
      ),
    );
  }
}
