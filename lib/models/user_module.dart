import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

import 'models.dart';

class UserData {
  String _id;
  String _fullName;
  String _email;
  String _gender;
  String _age;
  String _yearsOfExperience;
  int _phoneNumber;
  String _imei;
  File _imageUrl;
  bool _isOnline;
  List<Trip> tripList;
  List<Group> groupList;
  //List<Event> eventList;
  List<Post> posts;

  List get getPosts => posts;

  void setPosts(Post myPost) {
    posts.add(myPost);
  }

  List<Chat> chats;

  List<UserData> friends;

  String get gender => _gender;

  set gender(String value) => _gender = value;

  String get age => _age;

  set age(String value) => _age = value;

  String get yearsOfExperience => _yearsOfExperience;

  set yearsOfExperience(String value) => _yearsOfExperience = value;

  String get id => _id;

  set id(String value) => _id = value;

  String get fullName => _fullName;

  String setFullName(String value) {
    return _fullName = value;
  }

  String get email => _email;

  void setEmail(String value) {
    _email = value;
  }

  void setImage(File value) {
    _imageUrl = value;
  }

  File getImage() {
    return _imageUrl;
  }

  int get phoneNumber => _phoneNumber;

  set phoneNumber(int value) => _phoneNumber = value;

  String get imei => _imei;

  set imei(String value) => _imei = value;

  bool get isOnline => _isOnline;

  set isOnline(bool value) => _isOnline = value;

  UserData(this._fullName, this._email, this._age, this._gender,
      this._yearsOfExperience, this._imei, this._imageUrl);

  UserData.fromUserData(this._fullName, this._email, this._id,
      this._yearsOfExperience, this._imageUrl);

  Map<String, dynamic> toJson() => {
        'FullName': _fullName,
        'Email': _email,
        'Age': _age,
        'Gender': _gender,
        'YearsOfExperience': _yearsOfExperience,
        'IMEI': _imei,
        'ImageUrl': _imageUrl,
      };

  UserData.fromJson(DataSnapshot snapshot)
      : _fullName = snapshot.value['FullName'],
        _email = snapshot.value['Email'],
        _age = snapshot.value['Age'],
        _gender = snapshot.value['Gender'],
        _yearsOfExperience = snapshot.value['YearsOfExperience'],
        _imei = snapshot.value['IMEI'],
        _imageUrl = snapshot.value['ImageUrl'];
}
