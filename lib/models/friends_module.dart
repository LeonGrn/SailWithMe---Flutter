class Friends {
  String name;
  String id;
  int isFriend;

  Friends({this.name, this.id, this.isFriend});

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Id': id,
        'IsFriend': isFriend.toString(),
      };
}
