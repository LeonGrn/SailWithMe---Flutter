import 'package:SailWithMe/models/modules.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';
import 'package:SailWithMe/screens/sub-screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_image/firebase_image.dart';


class LikeScreen extends StatefulWidget {

final Post post;

  const LikeScreen({
    @required this.post,
    Key key,
  }) : super(key: key);


  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  @override
Widget build(BuildContext context) {
      return Scaffold(
    body:
                 Container(
                   child: ListView.builder(
                      itemCount: widget.post.likes.length,
                      itemBuilder: (context, index) {
                        Likes like = widget.post.likes[index];
                        return LikesListContaner(like: like);
                      }),
                 ));
          }
}
       

class LikesListContaner extends StatelessWidget {
  final  Likes like;

  const LikesListContaner({
    Key key,
    @required this.like,
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
            radius: 15.0,
            backgroundImage: FirebaseImage(
              'gs://sailwithme.appspot.com/' + like.imgeRef,
              shouldCache: true, // The image should be cached (default: True)
              //             // maxSizeBytes:
              //             //     3000 * 1000, // 3MB max file size (default: 2.5MB)
              //             // cacheRefreshStrategy: CacheRefreshStrategy
              //             //     .NEVER // Switch off update checking
            )),
        title: GestureDetector(
            onTap: () => {
                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return ProfileScreen(id: like.userID);
                      },
                      fullscreenDialog: true))
                },
            child: new Text(like.fullName)),
            trailing:  const Icon(
                Icons.thumb_up,
                size: 20.0,
                color: Colors.blue,
              ),
      ),
      
    );
  }
}