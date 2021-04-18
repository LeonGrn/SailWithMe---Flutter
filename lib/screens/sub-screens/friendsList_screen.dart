import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/config/palette.dart';
import 'package:SailWithMe/models/FriendStatus.dart';
import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/screens/home_page.dart';
import 'package:SailWithMe/screens/sub-screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_image/firebase_image.dart';

class FriendListScreen extends StatefulWidget {
  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: new IconButton(
            color: Colors.black,
            icon: new Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)}),
        title: Text(
          "MY FRIENDS",
          style: TextStyle(
              color: Palette.sailWithMe,
              fontFamily: 'IndieFlower',
              fontSize: 25.0),
        ),
      ),
      body: FutureBuilder(
        future: ApiCalls.getAllFriends(), // async work
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('No Connection');
            case ConnectionState.waiting:
              return new CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return new Text('No Friends exist');
              else
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Friends friends = snapshot.data[index];
                      return FriendsContainer(friends: friends);
                    });
          }
        },
      ),
    );
  }
}

class FriendsContainer extends StatelessWidget {
  final Friends friends;

  const FriendsContainer({
    Key key,
    @required this.friends,
  });

  @override
  Widget build(BuildContext context) {
    String status = "";
    Color choosenColor;
    switch (friends.isFriend) {
      case FriendStatus.waitingForEcsept:
        {
          status = "WAITING";
          choosenColor = Palette.waitingForAccept;
        }
        break;

      case FriendStatus.approveFriendRequest:
        {
          status = "ACCEPT";
          choosenColor = Palette.friendAccept;
        }
        break;

      case FriendStatus.friends:
        {
          status = "FRIENDS";
          choosenColor = Palette.alreadyFriends;
        }
        break;

      default:
        {
          print("No statement in switch case");
        }
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: FirebaseImage(
              'gs://sailwithme.appspot.com/' + friends.imageUrl,
              shouldCache: true, // The image should be cached (default: True)
              //             // maxSizeBytes:
              //             //     3000 * 1000, // 3MB max file size (default: 2.5MB)
              //             // cacheRefreshStrategy: CacheRefreshStrategy
              //             //     .NEVER // Switch off update checking
            )),
        title: GestureDetector(
            onTap: () => {
                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return ProfileScreen(id: friends.id);
                      },
                      fullscreenDialog: true))
                },
            child: new Text(friends.name)),
        trailing: GestureDetector(
            onTap: () {
              print("accept");
            },
            child: Text(
              "$status",
              style: TextStyle(
                  color: choosenColor,
                  fontFamily: 'IndieFlower',
                  fontSize: 20.0),
            )),
      ),
    );
  }
}
