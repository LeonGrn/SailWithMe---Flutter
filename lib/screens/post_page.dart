import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final textController = new TextEditingController();
  File _image;
  //final picker = ImagePicker();

  User user1 = new User("Leon", "G", "g.com", 0544, "123",
      "https://images.unsplash.com/photo-1525253086316-d0c936c814f8");

  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    ProfileAvatar(imageUrl: user1.imageUrl, radius: 30),
                    SizedBox(width: 30), // give it width
                    Text(user1.firstName + " " + user1.lastName,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 30),
                Expanded(
                  flex: 1,
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration.collapsed(
                        hintText: "What do you want to talk about?"),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: _image == null
                        ? Text('No image selected.')
                        : Image.file(_image, fit: BoxFit.contain),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/yacht.svg',
                          width: 20,
                          height: 20,
                          color: Colors.black,
                        ),
                        Text(
                          'Invite to join',
                          style: TextStyle(
                            fontSize: 20,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/suitcase.svg',
                          width: 20,
                          height: 20,
                          color: Colors.black,
                        ),
                        Text(
                          'Job offer',
                          style: TextStyle(
                            fontSize: 20,
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
