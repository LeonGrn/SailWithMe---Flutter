import 'models.dart';

class User {
  String _firstName;
  String _lastName;
  String _email;
  int _phoneNumber;
  String _imei;
  String _imageUrl;
  List<User> friendsList;
  List<Trip> tripList;
  List<Group> groupList;
  List<Event> eventList;
  List<Post> posts;
  List<Chat> chats;

  String get firstName => _firstName;

  set firstName(String value) => _firstName = value;

  String get lastName => _lastName;

  set lastName(String value) => _lastName = value;

  String get email => _email;

  set email(String value) => _email = value;

  int get phoneNumber => _phoneNumber;

  set phoneNumber(int value) => _phoneNumber = value;

  String get imei => _imei;

  set imei(String value) => _imei = value;

  String get imageUrl => _imageUrl;

  set imageUrl(String value) => _imageUrl = value;

  List get getFriendsList => friendsList;

  set setFriendsList(List friendsList) => this.friendsList = friendsList;

  List get getTripList => tripList;

  set setTripList(List tripList) => this.tripList = tripList;

  List get getGroupList => groupList;

  set setGroupList(List groupList) => this.groupList = groupList;

  List get getEventList => eventList;

  set setEventList(List eventList) => this.eventList = eventList;

  List get getPosts => posts;

  set setPosts(List posts) => this.posts = posts;

  List get getChats => chats;

  set setChats(List chats) => this.chats = chats;

  User(this._firstName, this._lastName, this._email, this._phoneNumber,
      this._imei, this._imageUrl);

  Map<String, dynamic> get map {
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "email": _email,
      "phoneNumber": _phoneNumber,
      "imei": _imei,
    };
  }
}
