import 'package:SailWithMe/models/models.dart';
import 'package:flutter/material.dart';
import 'package:firebase_image/firebase_image.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
    @required this.message,
    @required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
              radius: 16, backgroundImage: FirebaseImage(
                          'gs://sailwithme.appspot.com/' +
                             message.urlAvatar,
                          shouldCache:
                              true, // The image should be cached (default: True)
                          //             // maxSizeBytes:
                          //             //     3000 * 1000, // 3MB max file size (default: 2.5MB)
                          //             // cacheRefreshStrategy: CacheRefreshStrategy
                          //             //     .NEVER // Switch off update checking
                          //
                        ),
              ),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 140),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[100] : Theme.of(context).accentColor,
            borderRadius: isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );
}
