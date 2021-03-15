import 'dart:io';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final File imageFile;
  final double width;
  final double height;
  final bool isActice;
  //final double radius;

  const ProfileAvatar(
      {Key key,
      @required this.imageFile,
      //@required this.radius,
      @required this.width,
      @required this.height,
      this.isActice = false})
      : super(key: key);

  Widget build(BuildContext context) {
    // return CircleAvatar(
    //   radius: radius,
    //   backgroundColor: Colors.grey[200],
    //   backgroundImage: CachedNetworkImageProvider(imageUrl),
    // );
    AssetImage myChoosenImage = new AssetImage('assets/user.png');

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: imageFile == null
            ? DecorationImage(fit: BoxFit.cover, image: myChoosenImage)
            : DecorationImage(
                image: FileImage(imageFile),
                fit: BoxFit.cover,
              ),
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
    );
  }
}
