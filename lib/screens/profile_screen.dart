import 'package:SailWithMe/models/models.dart';
import 'package:flutter/material.dart';
import 'package:firebase_image/firebase_image.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData myUser = null;

  Future<void> getUserData() async {}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getUserData(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                CircleAvatar(
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
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
    // body: Stack(
    //   children: [
    //     CircleAvatar(
    //       radius: 80.0,
    //       backgroundImage: myUser.getImageRef != ""
    //           ? FirebaseImage(
    //               'gs://sailwithme.appspot.com/' + myUser.getImageRef,
    //               shouldCache:
    //                   true, // The image should be cached (default: True)
    //               // maxSizeBytes:
    //               //     3000 * 1000, // 3MB max file size (default: 2.5MB)
    //               // cacheRefreshStrategy: CacheRefreshStrategy
    //               //     .NEVER // Switch off update checking
    //             ) //??
    //           : AssetImage('assets/user.png'),
    //       backgroundColor: Colors.white,
    //     ),
    //   ],
    // ),
  }
}
