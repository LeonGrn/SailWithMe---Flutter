import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/models/post_models/post_comments.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';
import 'package:meta/meta.dart';

class Post {
  final UserData user;
  final String caption;
  final String timeAgo;
  final String imageUrl;
  final List<Likes> likes;
  final List<Comments> comments;
  final int shares;

  const Post({
    @required this.user,
    @required this.caption,
    @required this.timeAgo,
    this.imageUrl,
    this.likes,
    this.comments,
    this.shares,
  });
}
