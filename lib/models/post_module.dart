import 'dart:io';
import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/models/post_models/post_comments.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';

class Post {
  String description;
  String timeAgo;
  String imageUrl;
  CreatedBy createdBy;
  List<Likes> likes;
  List<Comments> comments;
  int shares;

  Post({this.description, this.timeAgo, this.imageUrl, this.createdBy})
      : likes = [],
        comments = [],
        shares = 0;

  Map<String, dynamic> toJson() {
    List<Map> likes =
        this.likes != null ? this.likes.map((i) => i.toJson()).toList() : null;

    return {
      'Description': description,
      'TimeAgo': timeAgo,
      'ImageUrl': imageUrl,
      'CreatedBy': createdBy.toJson(),
      'Likes': likes,
    };
  }

  Post.fromJson(DataSnapshot snapshot)
      : description = snapshot.value['Description'],
        timeAgo = snapshot.value['TimeAgo'],
        imageUrl = snapshot.value['ImageUrl'],
        createdBy = snapshot.value['CreatedBy'];
}
