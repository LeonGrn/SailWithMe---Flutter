import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final bool isActice;
  final double radius;

  const ProfileAvatar(
      {Key key,
      @required this.imageUrl,
      @required this.radius,
      this.isActice = false})
      : super(key: key);

  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: CachedNetworkImageProvider(imageUrl),
    );
  }
}
