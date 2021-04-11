import 'dart:io';

import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:SailWithMe/screens/chosePlace_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:SailWithMe/models/models.dart';
import 'package:flutter/material.dart';
import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:firebase_image/firebase_image.dart';

class PostPage extends StatefulWidget {
   final Trip trip;
   const PostPage({Key key, this.trip}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final textController = new TextEditingController();
  File _image;
  UserData myUser;
  List<Post> posts = List<Post>();
  String postInfo="What do you want to talk about?";
  int postType=0;
  
  

  @override
  void initState() {
    super.initState();
  }

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
    return FutureBuilder(
        future: ApiCalls.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) return _buildScaffold(snapshot.data);
          if (snapshot.hasError) return Text("Error");

          return Text("Loading");
        });
  }

  Scaffold _buildScaffold(UserData myUser) {
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
              onPressed: () async {
                String imageRef = "";
                String formattedTime = DateFormat.Hms().format(now);

                imageRef =
                    await ApiCalls.uploadPic(myUser.email, _image, "post");
                print(captionController.text);
                Post myPost;
                if(widget.trip==null){
                  myPost = new Post(
                    type: postType,
                    description: captionController.text,
                    timeAgo: formattedTime,
                    imageUrl: imageRef,
                    createdBy: CreatedBy(
                        name: myUser.getFullName,
                        imageUrl: myUser.getImageRef,
                        id: ApiCalls.recieveUserInstance()));
                }else{
                   myPost = new Post(
                    type: postType,
                    description: captionController.text,
                    trip: widget.trip,
                    timeAgo: formattedTime,
                    imageUrl: imageRef,
                    createdBy: CreatedBy(
                        name: myUser.getFullName,
                        imageUrl: myUser.getImageRef,
                        id: ApiCalls.recieveUserInstance()));
                }      
                 await ApiCalls.createPost(myPost);
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
                    CircleAvatar(
                        radius: 25,
                        backgroundImage: FirebaseImage(
                          'gs://sailwithme.appspot.com/' + myUser.getImageRef,
                          shouldCache:
                              true, // The image should be cached (default: True)
                          //             // maxSizeBytes:
                          //             //     3000 * 1000, // 3MB max file size (default: 2.5MB)
                          //             // cacheRefreshStrategy: CacheRefreshStrategy
                          //             //     .NEVER // Switch off update checking
                        )),
                    SizedBox(width: 30), // give it width
                    Text(myUser.fullName,
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
                        hintText: postInfo),
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
                  IconButton(icon: Icon(Icons.location_on
                  ),color: widget.trip!=null ? Colors.yellow : Colors.grey,
                   onPressed: () {

                           Navigator.push(
                          context,
                          new MaterialPageRoute(
                      builder: (context) => new ChosePlace_page()));




                  }),
                  Container(
                    color: Colors.black45,
                    height: 50,
                    width: 2,
                  ),
                  FlatButton(
                    onPressed: () {
                          setState(() {
                         postInfo="please add a place that you want to travel to and write about the trip";
                      postType=1;//type of job offering
                      });



                    },
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
                          color:postType==1 ? Colors.blue[400] :Colors.black,
                        ),
                        Text(
                          'Invite to join',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: postType==1 ? Colors.blue[400] :Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {

                      setState(() {
                         postInfo="please give information about the job";
                         postType=2;//type of job offering
                      });

                    },
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
                          color:postType==2 ? Colors.blue[400] :Colors.black,
                        ),
                        Text(
                          'Job offer',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: postType==2 ? Colors.blue[400] :Colors.black,
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
