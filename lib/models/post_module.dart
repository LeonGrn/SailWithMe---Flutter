import 'dart:io';
import 'package:SailWithMe/models/post_models/created_by.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/models/post_models/post_comments.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class Post {
  CreatedBy createdBy;
  String title;
  String description;
  String timeAgo;
  String imageUrl;
  List<Likes> likes;
  List<Comments> comments;
  int shares;

  Post(
      {this.createdBy,
      this.title,
      this.description,
      this.timeAgo,
      this.imageUrl})
      : likes = [],
        comments = [],
        shares = 0;

  Map<String, dynamic> toJson() => {
        'CreatedBy': createdBy.toJson(),
        'Title': title,
        'Description': description,
        'TimeAgo': timeAgo,
        'ImageUrl': imageUrl,
      };

  Post.fromJson(DataSnapshot snapshot)
      : createdBy = CreatedBy.fromJson(snapshot.value['CreatedBy']),
        title = snapshot.value['Title'],
        description = snapshot.value['Description'],
        timeAgo = snapshot.value['TimeAgo'],
        imageUrl = snapshot.value['ImageUrl'];
}
