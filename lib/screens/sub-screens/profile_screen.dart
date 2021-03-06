import 'dart:developer';

import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/models/FriendStatus.dart';
import 'package:SailWithMe/models/modules.dart';
import 'package:SailWithMe/widgets/post_container.dart';
import 'package:SailWithMe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_page.dart';

class ProfileScreen extends StatefulWidget {
  final String id;
  

  const ProfileScreen({Key key, this.id}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int myFriend;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiCalls.getUserDataById(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildStack(snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildStack(UserData myUser) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "${myUser.fullName}",
            style: GoogleFonts.lato(
              fontSize: 25,
              textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(6.0),
              child: FutureBuilder(
                  future: ApiCalls.getFriendById(widget.id),
                  builder: (context, snapshot) {
                    inspect(snapshot.data);
                    Friends friend = snapshot.data;
                
                    if (friend==null){
                      myFriend=FriendStatus.notFriends;
                      
                      if(widget.id==ApiCalls.userId){
                      myFriend=FriendStatus.myUser;
                    }
                    }
                    else{
                     myFriend=friend.isFriend;

                    }
                    Icon icon;
                    //inspect(snapshot.data);
                    switch (myFriend) {
                      case FriendStatus.notFriends:
                        {
                          icon = Icon(Icons.group_add); //waiting for my accept
                        }
                        break;

                      case FriendStatus.waitingForEcsept:
                        {
                          icon = Icon(Icons
                              .transfer_within_a_station); // waiting for his Accept
                        }
                        break;

                      case FriendStatus.friends:
                        {
                          icon = Icon(Icons.message); //Friend with someone
                        }
                        break;

                      case FriendStatus.approveFriendRequest:
                        {
                          icon = Icon(Icons.group_add); //not in my friends list
                        }
                        break;

                      case FriendStatus.myUser:
                        {
                          icon = Icon(Icons.mobile_screen_share);
                        }
                        break;
                    }
                    return IconButton(
                        icon: icon,
                        iconSize: 30,
                        color: Colors.white,
                        onPressed: () async {
                          if (myFriend == FriendStatus.friends) {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ChatPage(user: friend);
                                },
                                fullscreenDialog: true));
                          }
                          if (myFriend == FriendStatus.approveFriendRequest) {
                            ApiCalls.acceptFriendRequest(widget.id);
                            icon = Icon(Icons.mobile_screen_share);
                            setState(() {});
                          }
                          if (myFriend == FriendStatus.notFriends) {
                            await ApiCalls.addFriend(widget.id,
                                myUser.getImageRef, myUser.getFullName);
                            icon = Icon(Icons.mobile_screen_share);
                            setState(() {});
                          }
                        });
                  }),
            ),
            Container(
              margin: const EdgeInsets.all(6.0),
              child: IconButton(
                icon: Icon(Icons.info),
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          title: Text(
                            "Informations",
                            style: GoogleFonts.lato(
                              fontSize: 25,
                              textStyle: TextStyle(
                                  color: Colors.grey,
                                  letterSpacing: .5,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          content: setupAlertDialoadContainer(myUser),
                        );
                      });
                },
              ),
            )
          ],
        ),
        body: Stack(alignment: Alignment.center, children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 4,
                // color: Colors.white,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/sea.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future:
                       ApiCalls.getListOfPostIfFraindByUserId(widget.id,myFriend), // async work
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return new Text('No posts exist');
                      case ConnectionState.waiting:
                        return new Text('Loading....');
                      default:
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        else
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                Post post = snapshot.data[index];
                                return PostContainer(post: post);
                              });
                    }
                  },
                ),
              )
            ],
          ),
          // Profile image
          Positioned(
            top: 80.0, // (background container size) - (circle height / 2)
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: myUser.getImageRef != ""
                    ? FirebaseImage(
                        'gs://sailwithme.appspot.com/' + myUser.getImageRef,
                        shouldCache:
                            true, // The image should be cached (default: True)
                        // maxSizeBytes:
                        //     3000 * 1000, // 3MB max file size (default: 2.5MB)
                        // cacheRefreshStrategy: CacheRefreshStrategy
                        //     .NEVER // Switch off update checking
                      ) //??
                    : AssetImage('assets/user.png'),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ]));
  }

  Widget setupAlertDialoadContainer(UserData myUser) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView(shrinkWrap: true, children: <Widget>[
        ListTile(
          title: Text('Name: ${myUser.fullName}'),
        ),
        ListTile(
          title: Text('Email: ${myUser.email}'),
        ),
        ListTile(
          title: Text('Age: ${myUser.age}'),
        ),
        ListTile(
          title: Text('Gender: ${myUser.gender}'),
        ),
        ListTile(
          title: Text('Years Of Experience: ${myUser.yearsOfExperience}'),
        ),
      ]),
    );
  }
}
