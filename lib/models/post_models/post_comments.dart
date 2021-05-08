
class Comments {
String userID;
  String imgeRef;
  String fullName;
  String userComment;

  Comments({this.userID, this.fullName, this.imgeRef,this.userComment});

 Map<String, dynamic> toJson() => {
        'UserID': userID,
        'FullName': fullName,
        'ImgeRef': imgeRef,
        'UserComment':userComment,
      };
}

