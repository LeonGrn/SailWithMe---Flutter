import 'package:firebase_database/firebase_database.dart';

class CreatedBy {
  String fullName;
  String email;
  String imageRef;

  String get getFullName => fullName;

  set setFullName(String fullName) => this.fullName = fullName;

  String get getEmail => email;

  set setEmail(String email) => this.email = email;

  String get getImageRef => imageRef;

  set setImageRef(String imageRef) => this.imageRef = imageRef;

  CreatedBy({
    this.fullName,
    this.email,
    this.imageRef,
  });

  Map<String, dynamic> toJson() => {
        'FullName': fullName,
        'Email': email,
        'ImageRef': imageRef,
      };

  CreatedBy.fromJson(DataSnapshot snapshot)
      : fullName = snapshot.value['FullName'],
        email = snapshot.value['Email'],
        imageRef = snapshot.value['ImageRef'];
}
