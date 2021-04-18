
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
}
