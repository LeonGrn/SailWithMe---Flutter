import 'dart:io';

import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:SailWithMe/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../models/models.dart';

class ApiCalls {
  static UserData myUser;
  static var instance = FirebaseAuth.instance;
  static String userId = instance.currentUser.uid;
  static final databaseReference = FirebaseDatabase.instance.reference();

  static String recieveUserInstance() {
    if (userId == null) {
      userId = instance.currentUser.uid;
    }
    return userId;
  }

  static Future<void> createUser(UserData createdUser) async {
    await databaseReference.child(userId).set(createdUser.toJson());
  }

  static Future<void> authNewUser(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    recieveUserInstance();
  }

  static Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    recieveUserInstance();
  }

  //Push a new post
  static Future<void> createPost(Post post) async {
    databaseReference.child(userId).child("Post").push().set(post.toJson());
  }

  static Future<void> savePlaceForUser(Trip trip) async {
    databaseReference.child(userId).child("Trips").push().set(trip.toJson());
  }

  static Future<void> signOut() async {
    userId = null;
    await instance.signOut();
  }

  static Future<UserData> getData() async {
    return await databaseReference
        .child(userId)
        .once()
        .then((DataSnapshot data) {
      return myUser = UserData.fromJson(data);
    });
  }

  //Get only yhe post
  static Future getListOfPost() async {
    List<Post> posts = [];
    await databaseReference
        .child(userId)
        .child('Post')
        .once()
        .then((DataSnapshot dataSnapshot) {
      for (var value in dataSnapshot.value.values) {
        posts.add(new Post(
            title: value['Title'].toString(),
            description: value['Description'].toString(),
            timeAgo: value['TimeAgo'].toString(),
            imageUrl: value['ImageUrl'].toString(),
            createdBy: new CreatedBy(
                name: value['CreatedBy']['Name'],
                imageUrl: value['CreatedBy']['ImageUrl'])));
      }
    });
    return posts;
  }

  //Get only yhe trips
  static Future getListOfTrips() async {
    List<Trip> trips = [];
    await databaseReference
        .child(userId)
        .child('Trips')
        .once()
        .then((DataSnapshot dataSnapshot) {
      for (var value in dataSnapshot.value.values) {
        trips.add(new Trip(
            lat: value['lat'], lng: value['lng'], name: value['name'],imageRef: value['imageRef']));
      }
    });
    return trips;
  }

  static Future<String> uploadPic(String email, File _image) async {
    String imageRef = "";

    if (_image == null) {
      return imageRef;
    }
    var uuid = Uuid().v4();
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('$email/posts/$uuid.png')
          .putFile(_image);

      imageRef = '$email/posts/$uuid.png';
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }

    return imageRef;
  }
}
