import 'dart:developer';
import 'dart:io';

import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:dio/dio.dart';
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
      inspect(data);
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

  static Future addFriend(String friendId, String imageUrl, String name) async {
    await databaseReference.child(userId).child("Friends").child(friendId).set(
        new Friends(id: friendId, imageUrl: imageUrl, isFriend: 1, name: name)
            .toJson());

    await databaseReference.child(friendId).child("Friends").child(userId).set(
        new Friends(
                id: userId,
                imageUrl: myUser.imageRef,
                isFriend: 0,
                name: myUser.fullName)
            .toJson());
  }

  static Future acceptFriendRequest(String friendId) async {
    await databaseReference
        .child(userId)
        .child("Friends")
        .child(friendId)
        .update({"IsFriend": 2});

    await databaseReference
        .child(friendId)
        .child("Friends")
        .child(userId)
        .update({"IsFriend": 2});
  }

  static Future getAllFriends() async {
    List<Friends> friends = [];
    await databaseReference
        .child(userId)
        .child('Friends')
        .once()
        .then((DataSnapshot dataSnapshot) {
      //inspect(dataSnapshot.value.values);
      for (var value in dataSnapshot.value.values) {
        friends.add(new Friends(
            name: value['Name'],
            id: value['Id'],
            isFriend: int.parse(value['IsFriend']),
            imageUrl: value['ImageUrl']));
      }
    });
    return friends;
  }

  static Future getSpecificFriend(String id) async {
    print(id);
    await databaseReference
        .child(userId)
        .child('Friends')
        //.child(id)
        .once()
        .then((DataSnapshot dataSnapshot) {
      inspect(dataSnapshot.value);

      inspect(dataSnapshot.value.values);
      //if(dataSnapshot.key.)

      if (dataSnapshot.value == null)
        return Friends(name: "", id: "", isFriend: 3, imageUrl: "");

      return Friends(
          name: dataSnapshot.value['Name'],
          id: dataSnapshot.value['Id'],
          isFriend: int.parse(dataSnapshot.value['IsFriend']),
          imageUrl: dataSnapshot.value['ImageUrl']);
    });
  }

  static Future getListOfPostByUserId(String uid) async {
    List<Post> posts = [];
    await databaseReference
        .child(uid)
        .child('Post')
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value == null) {
        return posts;
      }
      for (var value in dataSnapshot.value.values) {
        Trip trip;
        if (value['Trip'] != null) {
          trip = new Trip(
              name: value['Trip']['name'],
              imageRef: value['Trip']['imageRef'],
              lat: value['Trip']['lat'],
              lng: value['Trip']['lng']);
        }
        posts.add(new Post(
            description: value['Description'].toString(),
            timeAgo: value['TimeAgo'].toString(),
            imageUrl: value['ImageUrl'].toString(),
            trip: trip,
            createdBy: new CreatedBy(
                name: value['CreatedBy']['Name'],
                imageUrl: value['CreatedBy']['ImageUrl'],
                id: value['CreatedBy']['Id'])));
      }
    });
    return posts;
  }

  //Get only the post
  static Future getListOfPost() async {
    return await getListOfPostByUserId(userId);
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

  static Future<int> getRecomandRiver() async {
    print("has click");
    Dio dio = new Dio();

    Response response;
    try {
      response = await dio.post("https://yact-need.herokuapp.com/api", data: {
        "age": 30,
        "years of experience": 3,
        "how many children": 2,
        "location": "tel aviv",
        "sex": 1
      });
      if (response.data.toString().contains("1")) {
        return (/*"the river in Camargue"*/ 1);
      } else if (response.data.toString().contains("0")) {
        return (/*"the river in lot france"*/ 0);
      } else if (response.data.toString().contains("2")) {
        return (/*"the river in Volga"*/ 2);
      }
    } on DioError catch (e) {
      print("Error");
      print(e.toString());
    }
    return (-1);
  }

  static Future searchUsers(String s) async {
    List<Friends> friends = [];
    UserData user;
    String fullName;
    String imagePath;
    await databaseReference
        .orderByChild("FullName")
        .startAt(s)
        .limitToFirst(5)
        .once()
        .then((DataSnapshot dataSnapshot) {
      for (var key in dataSnapshot.value.keys) {
        fullName = dataSnapshot.value[key]['FullName'];
        imagePath = dataSnapshot.value[key]['ImageRef'];
        friends.add(new Friends(
            id: key, name: fullName, isFriend: 0, imageUrl: imagePath));
      }
    });
    return friends;
  }

  static Future getAllUsers() async {
    List<Friends> friends = [];
    UserData user;
    String fullName;
    String imagePath;

    await databaseReference
        .orderByChild("FullName")
        .once()
        .then((DataSnapshot dataSnapshot) {
      for (var key in dataSnapshot.value.keys) {
        fullName = dataSnapshot.value[key]['FullName'];
        imagePath = dataSnapshot.value[key]['ImageRef'];
        friends.add(new Friends(
            id: key, name: fullName, isFriend: 0, imageUrl: imagePath));
      }
    });
    return friends;
  }
}
