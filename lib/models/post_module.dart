import 'dart:io';

import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/models/post_models/post_comments.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class Post {
  //final UserData user;
  String caption;
  DateTime timeAgo;

  //final String imageUrl;
  File _imageUrl;
  List<Likes> likes;
  List<Comments> comments;
  int shares;

  Post(
      // //@required this.user,
      // this._imageUrl,
      // this.caption,
      // this.timeAgo,
      // //this.imageUrl,
      // this.likes,
      // this.comments,
      // this.shares,
      );

  void setImage(File value) {
    _imageUrl = value;
  }

  File getImage() {
    return _imageUrl;
  }

  void setCaption(String value) {
    caption = value;
  }

  String getCaption() {
    return caption;
  }

  void setTime(DateTime now) {
    timeAgo = now;
  }

  DateTime getTime() {
    DateTime now = DateTime.now();
    return now;
  }

  Map<String, dynamic> toJson() => {
        'Caption': caption,
        'Time': timeAgo,
      };
}
