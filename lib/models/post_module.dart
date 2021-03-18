import 'dart:io';
import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/models/post_models/post_comments.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';

class Post {
  String title;
  String description;
  String timeAgo;
  String imageUrl;
  CreatedBy createdBy;
  List<Likes> likes;
  List<Comments> comments;
  int shares;

  Post(
      {this.title,
      this.description,
      this.timeAgo,
      this.imageUrl,
      this.createdBy})
      : likes = [],
        comments = [],
        shares = 0;

  Map<String, dynamic> toJson() => {
        'Title': title,
        'Description': description,
        'TimeAgo': timeAgo,
        'ImageUrl': imageUrl,
        'CreatedBy': createdBy,
      };

  Post.fromJson(DataSnapshot snapshot)
      : title = snapshot.value['Title'],
        description = snapshot.value['Description'],
        timeAgo = snapshot.value['TimeAgo'],
        imageUrl = snapshot.value['ImageUrl'],
        createdBy = snapshot.value['CreatedBy'];
}
