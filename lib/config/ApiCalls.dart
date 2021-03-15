import 'package:SailWithMe/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';
import 'dart:convert';

class ApiCalls {
  final String userid;
  ApiCalls({this.userid});

  // final CollectionReference brewCollection = FirebaseFirestore.instance.collection('Users');

  static UserData myUser;

  //Push a new post
  static Future<void> createPost(Post post) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    String userId = FirebaseAuth.instance.currentUser.uid;
    databaseReference.child(userId).child("Post").push().set(post.toJson());
  }

  //Get all data
  static Future getUserData() async {
    if (myUser == null) {
      _getData();
    }
    return myUser;
  }

  static Future _getData() async {
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    var userId = FirebaseAuth.instance.currentUser.uid;
    await ref.child(userId).once().then((DataSnapshot data) {
      myUser = UserData.fromJson(data);
      inspect(myUser);
    });
  }

  //Get only yhe post
  static Future getListOfPost() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    List<Post> posts = [];
    await ref.child(uid).child('Post').once().then((DataSnapshot dataSnapshot) {
      for (var value in dataSnapshot.value.values) {
        posts.add(new Post(
            title: value['Title'].toString(),
            description: value['Description'].toString(),
            timeAgo: value['TimeAgo'].toString(),
            imageUrl: value['ImageUrl'].toString()));
      }
    });
    return posts;
  }
}
