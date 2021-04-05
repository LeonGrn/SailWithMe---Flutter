import 'dart:developer';
import 'dart:io';

import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';
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
    await databaseReference
        .child(userId)
        .child("Post")
        .push()
        .set(post.toJson());
  }

  static Future<void> savePlaceForUser(Trip trip) async {
    await databaseReference
        .child(userId)
        .child("Trips")
        .push()
        .set(trip.toJson());
  }

  static Future<void> signOut() async {
    userId = null;
    await instance.signOut();
  }

  static Future<UserData> getUserDataById(String id) async {
    return await databaseReference.child(id).once().then((DataSnapshot data) {
      return myUser = UserData.fromJson(data);
    });
  }

  static Future<UserData> getUserData() async {
    return await databaseReference
        .child(userId)
        .once()
        .then((DataSnapshot data) {
      return myUser = UserData.fromJson(data);
    });
  }

  static Future<void> likePost(Likes like) async {
    await databaseReference
        .child(userId)
        .child("Post")
        .child("uuid")
        .child("Likes")
        .push()
        .set(like.toJson());
  }

  static Future addFriend(String friendId) async {
    return null;
  }

  static Future getAllFriends() async {
    List<Friends> friends = [];
    await databaseReference
        .child(userId)
        .child('Friends')
        .once()
        .then((DataSnapshot dataSnapshot) {
      inspect(dataSnapshot.value.values);
      for (var value in dataSnapshot.value.values) {
        friends.add(new Friends(
            name: value['Name'],
            id: value['Id'],
            isFriend: value['IsFriend'],
            imageUrl: value['ImageUrl']));
      }
    });
    return friends;
  }

  //Get only the post
  static Future getListOfPost() async {
    List<Post> posts = [];
    await databaseReference
        .child(userId)
        .child('Post')
        .once()
        .then((DataSnapshot dataSnapshot) {
      for (var value in dataSnapshot.value.values) {
        posts.add(new Post(
            description: value['Description'].toString(),
            timeAgo: value['TimeAgo'].toString(),
            imageUrl: value['ImageUrl'].toString(),
            createdBy: new CreatedBy(
                name: value['CreatedBy']['Name'],
                imageUrl: value['CreatedBy']['ImageUrl'],
                id: value['CreatedBy']['Id'])));
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
            lat: value['lat'],
            lng: value['lng'],
            name: value['name'],
            imageRef: value['imageRef']));
      }
    });
    return trips;
  }

  static Future<String> uploadPic(
      String email, File _image, String typeOfPhoto) async {
    String imageRef = "";

    if (_image == null) {
      return imageRef;
    }
    var uuid = Uuid().v4();

    imageRef = '$email/$typeOfPhoto/$uuid.png';

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(imageRef)
          .putFile(_image);
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }

    return imageRef;
  }
}
