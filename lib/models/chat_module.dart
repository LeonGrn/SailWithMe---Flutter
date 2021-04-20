import 'package:SailWithMe/models/modules.dart';

class Chat {
  UserData _sender;
  List<Message> _message;

  Chat(this._sender, this._message);
}
