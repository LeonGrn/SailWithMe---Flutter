import 'package:firebase_database/firebase_database.dart';

class CreatedBy {
  String name;
  String imageUrl;

  CreatedBy({
    this.name,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'Name': name,
        'ImageUrl': imageUrl,
      };

  CreatedBy.fromJson(DataSnapshot snapshot)
      : name = snapshot.value['Name'],
        imageUrl = snapshot.value['ImageUrl'];
}
