import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/models/models.dart';
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
    return new ListTile(
      onTap: () => {
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return ProfileScreen(id: friends.id);
            },
            fullscreenDialog: true))
      },
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
      title: new Text(friends.name),
    );
  }
}
