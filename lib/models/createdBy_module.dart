import 'package:firebase_database/firebase_database.dart';

class CreatedBy {
  String name;
  String imageUrl;
  String id;

  CreatedBy({this.name, this.imageUrl, this.id});

  String getName() => name;

  Map<String, dynamic> toJson() => {
        'Name': name,
        'ImageUrl': imageUrl,
        'Id': id,
      };

  factory CreatedBy.fromJson(DataSnapshot snapshot) {
    return CreatedBy(
        name: snapshot.value['Name'],
        imageUrl: snapshot.value['ImageUrl'],
        id: snapshot.value['Id']);
  }
}
