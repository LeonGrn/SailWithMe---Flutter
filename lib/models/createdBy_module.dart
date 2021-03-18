import 'package:firebase_database/firebase_database.dart';

class CreatedBy {
  String name;
  String imageUrl;

  CreatedBy({
    this.name,
    this.imageUrl,
  });

  String getName() => name;

  Map<String, dynamic> toJson() => {
        'Name': name,
        'ImageUrl': imageUrl,
      };

  factory CreatedBy.fromJson(DataSnapshot snapshot) {
    return CreatedBy(
        name: snapshot.value['Name'], imageUrl: snapshot.value['ImageUrl']);
  }
}
