import 'package:SailWithMe/models/modules.dart';
import 'package:firebase_database/firebase_database.dart';

class Friends {
  String name;
  String id;
  int isFriend;
  String imageUrl;

  Friends({this.name, this.id, this.isFriend, this.imageUrl});

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Id': id,
        'IsFriend': isFriend.toString(),
        'ImageUrl': imageUrl,
      };

  static Friends fromJson(DataSnapshot snapshot) {
    return Friends(
        id: snapshot.value['Id'],
        name: snapshot.value['Name'],
        isFriend: int.parse(snapshot.value['IsFriend']),
        imageUrl: snapshot.value['ImageUrl']);
  }
}
