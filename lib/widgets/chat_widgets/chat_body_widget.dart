import 'package:SailWithMe/models/modules.dart';
import 'package:SailWithMe/screens/sub-screens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_image/firebase_image.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<Friends> users;

  const ChatBodyWidget({
    @required this.users,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final user = users[index];

          return Container(
            height: 75,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(user: user),
                ));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage:FirebaseImage(
                          'gs://sailwithme.appspot.com/' +
                              user.imageUrl,
                          shouldCache:
                              true, // The image should be cached (default: True)
                          //             // maxSizeBytes:
                          //             //     3000 * 1000, // 3MB max file size (default: 2.5MB)
                          //             // cacheRefreshStrategy: CacheRefreshStrategy
                          //             //     .NEVER // Switch off update checking
                          //
                        ),
              ),
              title: Text(user.name),
            ),
          );
        },
        itemCount: users.length,
      );
}
                       