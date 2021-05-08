import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/models/modules.dart';
import 'package:SailWithMe/models/post_models/post_comments.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';
import 'package:SailWithMe/screens/sub-screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_image/firebase_image.dart';


class CommentsScreen extends StatefulWidget {

final Post post;

  const CommentsScreen({
    @required this.post,
    Key key,
  }) : super(key: key);


  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _controller = TextEditingController();
  String message = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    await ApiCalls.uploudNewComment(widget.post.createdBy.id,widget.post.postId, message);

    _controller.clear();
  }


  @override
Widget build(BuildContext context) {
      return Scaffold(
    body:
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.post.comments.length,
              itemBuilder: (context, index) {
                Comments comment = widget.post.comments[index];
                return CommentListContaner(comment: comment);
              }),
          ),
          Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: 'Type your message',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) => setState(() {
                  message = value;
                }),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: message.trim().isEmpty ? null : sendMessage,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
    ],
  ));
          }
}
       

class CommentListContaner extends StatelessWidget {
  final  Comments comment;

  const CommentListContaner({
    Key key,
    @required this.comment,
  });

  

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ListTile(
          leading: CircleAvatar(
              radius: 15.0,
              backgroundImage: FirebaseImage(
                'gs://sailwithme.appspot.com/' + comment.imgeRef,
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
                          return ProfileScreen(id: comment.userID);
                        },
                        fullscreenDialog: true))
                  },
              child: new Text(comment.fullName)),
              trailing:  Text(comment.userComment),
        ),
      ),
    );
  }
}