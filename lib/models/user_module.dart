import 'models.dart';

class UserData {
  String _id;
  String _lastName;
  String _firstName;
  String _email;
  int _phoneNumber;
  String _imei;
  String _imageUrl;
  bool _isOnline;
  List<Trip> tripList;
  List<Group> groupList;
  List<Event> eventList;
  List<Post> posts;
  List<Chat> chats;
  List<UserData> friends;

  String get id => _id;

  set id(String value) => _id = value;

  String get lastName => _lastName;

  set lastName(String value) => _lastName = value;

  String get firstName => _firstName;

  set firstName(String value) => _firstName = value;

  String get email => _email;

  set email(String value) => _email = value;

  int get phoneNumber => _phoneNumber;

  set phoneNumber(int value) => _phoneNumber = value;

  String get imei => _imei;

  set imei(String value) => _imei = value;

  String get imageUrl => _imageUrl;

  set imageUrl(String value) => _imageUrl = value;

  bool get isOnline => _isOnline;

  set isOnline(bool value) => _isOnline = value;

  UserData(this._firstName, this._lastName, this._email, this._phoneNumber,
      this._imei, this._imageUrl);
}
