import 'package:SailWithMe/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';


class ApiCalls{

static UserData myUser;


static Future getUserData() async{

if(myUser==null){
  _getData();
}
  return myUser;

}


static Future  _getData() async { 
  final fb = FirebaseDatabase.instance;
  final ref = fb.reference();
  var userId = FirebaseAuth.instance.currentUser.uid;
  await ref.child(userId).once().then((DataSnapshot data) {
    print(data.value);
    print(data.key);
    myUser = UserData.fromJson(data);
    inspect(myUser);
    print(myUser.age +
        myUser.email +
        myUser.fullName +
        myUser.yearsOfExperience +
        myUser.imei +
        myUser.gender);

    print(myUser.getImageRef);
  });
}





}

