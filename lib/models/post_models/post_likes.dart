import '../modules.dart';

class Likes {
  String userID;
  String imgeRef;
  String fullName;

  Likes({this.userID, this.fullName, this.imgeRef});

  Map<String, dynamic> toJson() => {
        'UserID': userID,
        'FullName': fullName,
        'ImgeRef': imgeRef,
      };
}
