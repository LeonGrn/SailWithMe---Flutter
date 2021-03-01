import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final textController = new TextEditingController();
  File _image;
  String imageRef = "";
  //final picker = ImagePicker();
  final databaseReference = FirebaseDatabase.instance.reference();

  UserData user1 =
      new UserData.fromUserData("Leon", "g.com", "0544", "123", null);

  Post myPost;
  UserData myUser;
  String userId = FirebaseAuth.instance.currentUser.uid;
  List<Post> posts = List<Post>();

  Future<void> _getData() async {
    print("userId");

    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    var userId = FirebaseAuth.instance.currentUser.uid;
    print(userId);
    ref.child(userId).once().then((DataSnapshot data) {
      //myUser = UserData.fromJson(jsonDecode(data.value));
      myUser = UserData.fromJson(data);
      // print(data.value);
      // print(data.key);
      // inspect(myUser);
      // // myUser = UserData.fromJson(data);
      // print(myUser.age +
      //     myUser.email +
      //     myUser.fullName +
      //     myUser.yearsOfExperience +
      //     myUser.imei +
      //     myUser.gender);
    });
  }

  @override
  void initState() {
    super.initState();
    this._getData();
  }

  // Future getImage() async {
  //   final pickedFile =
  //       await ImagePicker().getImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        //myChoosenImage = _image;
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadPic() async {
    var uuid = Uuid().v4();

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('${myUser.email}/$uuid.png')
          .putFile(_image);

      imageRef = '${myUser.email}/$uuid.png';
    } on firebase_storage.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    }
  }

  Future<void> _createPost() async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    print(userId);
    uploadPic();

    //var newPostKey = databaseReference.push().key;
    //print(newPostKey);
    databaseReference.child(userId).update(myUser.toJson());
    //myUser
    // databaseReference
    //     .child(userId)
    //     .child("posts")
    //     .update({newPostKey: myPost.toJson()});
    // updates['/posts/' + newPostKey] = myPost.toJson();
    // updates['/user-posts/' + userId + '/' + newPostKey] = myPost.toJson();
    // databaseReference.update(updates);
    //databaseReference.child(userId).set(myPost.toJson());

    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => new BottomNavBar()),
    //     (e) => false);
    // } on FirebaseAuthException catch (e) {
    //   // if (e.code == 'weak-password') {
    //   //   print('The password provided is too weak.');
    //   // } else if (e.code == 'email-already-in-use') {
    //   //   print('The account already exists for that email.');
    //   // }
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController captionController = new TextEditingController();
    DateTime now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Create post"),
            RaisedButton(
              color: Colors.cyan[400],
              onPressed: () {
                /*...*/

                myPost = new Post(
                    title: captionController.text,
                    description: "",
                    timeAgo: now.toString(),
                    imageUrl: imageRef);
                // myPost.setImage(_image);
                // myPost.setCaption(captionController.text);
                // myPost.setTime(now);
                //myUser.setPosts(myPost);
                //this._getData();

                inspect(myPost);
                posts.add(myPost);
                myUser.posts = posts;
                _createPost();
              },
              child: Text(
                "Post",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //ProfileAvatar(imageUrl: null, radius: 30),
                    ProfileAvatar(imageFile: _image, width: 30, height: 30),

                    SizedBox(width: 30), // give it width
                    Text(user1.fullName,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 40),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: captionController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration.collapsed(
                        hintText: "What do you want to talk about?"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: _image == null
                          ? Text('No image selected.')
                          : Image.file(_image, fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
          //Container(
          // child:
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: () {
                        getImage();
                      }),
                  SizedBox(width: 10),
                  IconButton(icon: Icon(Icons.location_on), onPressed: () {}),
                  Container(
                    color: Colors.black45,
                    height: 50,
                    width: 2,
                  ),
                  FlatButton(
                    onPressed: () {},
                    textColor: Colors.black,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/yacht.svg',
                          width: 15,
                          height: 15,
                          color: Colors.black,
                        ),
                        Text(
                          'Invite to join',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    textColor: Colors.black,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/suitcase.svg',
                          width: 15,
                          height: 15,
                          color: Colors.black,
                        ),
                        Text(
                          'Job offer',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
