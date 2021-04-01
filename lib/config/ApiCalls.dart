import 'dart:io';

import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:SailWithMe/models/models.dart';
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
    databaseReference.child(userId).child("Post").push().set(post.toJson());
  }

  static Future<void> savePlaceForUser(Trip trip) async {
    databaseReference.child(userId).child("Trips").push().set(trip.toJson());
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
      for (var value in dataSnapshot.value.values) {
        friends.add(new Friends(
            name: value['Name'], id: value['Id'], isFriend: value['IsFriend']));
      }
    });
    return friends;
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


  static Future<String> getRecomandRiver() async {
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
          return("the river in Camargue");
        } else if (response.data.toString().contains("0")) {
          return("the river in lot france");
        } else if (response.data.toString().contains("2")) {
          return("the river in Volga");
        }
      } on DioError catch (e) {
        print("Error");
        print(e.toString());
      }
      return("not success to get data");
}


static Future<List<Friends>> searchUsers (String s) async {
  List<Friends> friends = [];
  UserData user;
  String fullName;
  String imagePath;

   await databaseReference
        .orderByChild("FullName")
        .startAt(s)
        .limitToFirst(3)
        .once()
        .then((DataSnapshot dataSnapshot) {
         for(var key in dataSnapshot.value.keys){
         fullName= dataSnapshot.value[key]['FullName'];
         imagePath=dataSnapshot.value[key]['ImageRef'];
         friends.add(new Friends(id: key,name: fullName,isFriend: 0,imagePath: imagePath));
        }
  
    }
    );
    return friends;
  

}


}
