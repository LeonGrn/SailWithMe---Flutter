import 'package:meta/meta.dart';
import '../models.dart';

class Comments {
  UserData _user;
  String _userComment;

  Comments(@required this._user, @required this._userComment);

  UserData get user => _user;

  set user(UserData value) => _user = value;

  String get userComment => _userComment;

  set userComment(String value) => _userComment = value;
}
