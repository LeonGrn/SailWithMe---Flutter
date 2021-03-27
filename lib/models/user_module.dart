import 'package:firebase_database/firebase_database.dart';

import 'models.dart';

class UserData {
  String id;
  String fullName = "";
  String email = "";
  String gender = "";
  String age = "";
  String yearsOfExperience = "";
  int phoneNumber;
  String imei = "";
  String imageRef = "";
  bool _isOnline;
  List<Friends> friendsList = [];
  List<Trip> tripList;
  List<Group> groupList;
  //List<Event> eventList;
  List<Post> posts = [];

  List get getPosts {
    return posts;
  }

  void setPosts(Post post) {
    this.posts.add(post);
  }

  String get getId => id;

  set setId(String id) => this.id = id;

  String get getFullName => fullName;

  set setFullName(String fullName) => this.fullName = fullName;

  String get getEmail => email;

  set setEmail(String email) => this.email = email;

  String get getGender => gender;

  set setGender(String gender) => this.gender = gender;

  String get getAge => age;

  set setAge(String age) => this.age = age;

  String get getYearsOfExperience => yearsOfExperience;

  set setYearsOfExperience(String yearsOfExperience) =>
      this.yearsOfExperience = yearsOfExperience;

  int get getPhoneNumber => phoneNumber;

  set setPhoneNumber(int phoneNumber) => this.phoneNumber = phoneNumber;

  String get getImei => imei;

  set setImei(String imei) => this.imei = imei;

  String get getImageRef => imageRef;

  set setImageRef(String imageRef) => this.imageRef = imageRef;

  UserData(
      {this.fullName,
      this.email,
      this.age,
      this.gender,
      this.yearsOfExperience,
      this.imei,
      this.imageRef,
      this.posts
      ,this.friendsList});

  UserData.fromUserData(this.fullName, this.email, this.id,
      this.yearsOfExperience, this.imageRef);

  Map<String, dynamic> toJson() {
    List<Map> posts =
        this.posts != null ? this.posts.map((i) => i.toJson()).toList() : null;
     List<Map> friendsList = this.friendsList != null
         ? this.friendsList.map((i) => i.toJson()).toList()
         : null;
    return {
      'FullName': fullName,
      'Email': email,
      'Age': age,
      'Gender': gender,
      'YearsOfExperience': yearsOfExperience,
      'IMEI': imei,
      'ImageRef': imageRef,
      'Posts': posts,
      'Friends': friendsList,
    };
  }

  factory UserData.fromJson(DataSnapshot snapshot) {
    return UserData(
        fullName: snapshot.value['FullName'],
        email: snapshot.value['Email'],
        age: snapshot.value['Age'],
        gender: snapshot.value['Gender'],
        yearsOfExperience: snapshot.value['YearsOfExperience'],
        imei: snapshot.value['IMEI'],
        imageRef: snapshot.value['ImageRef']);
  }
}
