class Friends {
  String name;
  String id;
  int isFriend;
  String imagePath;

  Friends({this.name, this.id, this.isFriend,this.imagePath});

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Id': id,
        'IsFriend': isFriend.toString(),
        'imagePath':imagePath,
      };
}
