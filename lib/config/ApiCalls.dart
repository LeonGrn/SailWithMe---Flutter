import 'dart:developer';
import 'dart:io';

import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:SailWithMe/models/jobPost_module.dart';
import 'package:SailWithMe/models/modules.dart';
import 'package:SailWithMe/models/post_models/post_likes.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import '../models/modules.dart';
import 'package:SailWithMe/models/FriendStatus.dart';
import 'package:SailWithMe/widgets/utils.dart';

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

  static Future<void> createJobOfferPost(JobPost myJob) async {
    await databaseReference
        .child(userId)
        .child("JobOffer")
        .push()
        .set(myJob.toJson());
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

  static Future<Friends> getFriendById(String id) async {
    return await databaseReference
        .child(userId)
        .child("Friends")
        .child(id)
        .once()
        .then((DataSnapshot data) {
      Friends friend = Friends.fromJson(data);
      return friend;
    });
  }

  static Future<UserData> getUserDataById(String id) async {
    return await databaseReference.child(id).once().then((DataSnapshot data) {
      return UserData.fromJson(data);
    });
  }

  static Future<UserData> getUserData() async {
    return await databaseReference
        .child(userId)
        .once()
        .then((DataSnapshot data) {
      inspect(data);
      myUser = UserData.fromJson(data);
      return myUser;
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
        new Friends(
                id: friendId,
                imageUrl: imageUrl,
                isFriend: FriendStatus.waitingForEcsept,
                name: name)
            .toJson());

    await databaseReference.child(friendId).child("Friends").child(userId).set(
        new Friends(
                id: userId,
                imageUrl: myUser.imageRef,
                isFriend: FriendStatus.approveFriendRequest,
                name: myUser.fullName)
            .toJson());
  }

  static Future uploudNewMessage(String friendId, String msgInfo) async {
    final newMessage = Message(
        idUser: userId,
        urlAvatar: myUser.imageRef,
        username: myUser.fullName,
        message: msgInfo,
        createdAt: DateTime.now());

    await databaseReference
        .child(friendId)
        .child("messages")
        .child(userId)
        .push()
        .set(newMessage.toJson());

    await databaseReference
        .child(userId)
        .child("messages")
        .child(friendId)
        .push()
        .set(newMessage.toJson());
  }

  static Stream<List<Message>> getMessagesByStream(String idUser) =>
      databaseReference
          .child(userId)
          .child('messages')
          .child(idUser)
          .onValue
          .transform(Utils.transformerForMessages());

  static Future acceptFriendRequest(String friendId) async {
    await databaseReference
        .child(userId)
        .child("Friends")
        .child(friendId)
        .update({"IsFriend": FriendStatus.friends.toString()});

    await databaseReference
        .child(friendId)
        .child("Friends")
        .child(userId)
        .update({"IsFriend": FriendStatus.friends.toString()});
  }

  static Future getAllFriends() async {
    List<Friends> friends = [];
    await databaseReference
        .child(userId)
        .child('Friends')
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value == null) return friends;
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

  static Stream<List<Friends>> getAllFriendsByStream() => databaseReference
      .child(userId)
      .child('Friends')
      .onValue
      .transform(Utils.transformerForFriends());

  static Future getStatusFriend(String id) async {
    List<Friends> friends = await getAllFriends() as List<Friends>;
    for (var friend in friends) {
      if (friend.id == id) {
        return friend.isFriend;
      }
    }
    if (id == userId) {
      return FriendStatus.myUser;
    }
    return FriendStatus.notFriends;
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
    List<Post> posts = [];
    List<Post> allPosts = [];
    posts=await getListOfPostByUserId(userId);
    allPosts.addAll(posts);
    posts=[];
    List<Friends> friends=await getAllFriends();
    if(friends!=null){
       for(Friends friend in friends){
      if(friend.isFriend==FriendStatus.friends){
          posts=await getListOfPostByUserId(friend.id);
          allPosts.addAll(posts);
          posts=[];
      }
    }
    }
    return allPosts;//await getListOfPostByUserId(userId);
  }

  static Future getListOfJobsByUserId() async {
    List<JobPost> jobPosts = [];
    await databaseReference
        .child(userId)
        .child('JobOffer')
        .once()
        .then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value == null) {
        return jobPosts;
      }
      for (var value in dataSnapshot.value.values) {
        jobPosts.add(new JobPost(
            position: value['Position'].toString(),
            location: value['Location'].toString(),
            employmentType: value['EmploymentType'].toString(),
            vessel: value['Vessel'],
            salary: value['Salary'],
            description: value['Description'],
            timeAgo: value['TimeAgo'],
            createdBy: new CreatedBy(
                name: value['CreatedBy']['Name'],
                imageUrl: value['CreatedBy']['ImageUrl'],
                id: value['CreatedBy']['Id'])));
      }
    });
    return jobPosts;
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
        "age": myUser.age,
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
        if(fullName.startsWith(s) || s==""){
          friends.add(new Friends(
            id: key, name: fullName, isFriend: 0, imageUrl: imagePath));
       
        }
        
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
