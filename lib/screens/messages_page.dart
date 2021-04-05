import 'dart:ui';

import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/config/palette.dart';
import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/widgets/chat_widgets/chat_body_widget.dart';
import 'package:SailWithMe/widgets/chat_widgets/chat_header.dart';
import 'package:SailWithMe/widgets/profile_avatar.dart';
import 'package:SailWithMe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: StreamBuilder<List<UserData>>(
            stream: null, //FirebaseApi.getUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return buildText('Something Went Wrong Try later');
                  } else {
                    final users = snapshot.data;

                    if (users.isEmpty) {
                      return buildText('No Users Found');
                    } else
                      return Column(
                        children: [
                          ChatHeaderWidget(users: users),
                          ChatBodyWidget(users: users)
                        ],
                      );
                  }
              }
            },
          ),
        ),
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
}

// class MessagesPage extends StatelessWidget {
//   final List<UserData> users = [
//     new UserData.fromUserData("Leon", "g.com", "0544", "123", null),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               showSearch(context: context, delegate: SearchData());
//             },
//             icon: Icon(Icons.search),
//             color: Colors.black,
//           )
//         ],
//         centerTitle: false,
//         title: Text(
//           'Messages',
//           style: TextStyle(
//               color: Palette.sailWithMe,
//               fontFamily: 'IndieFlower',
//               fontSize: 25.0),
//         ),
//       ),
//       body: ListView.builder(
//         itemBuilder: (context, index) => ListTile(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => ChatScreen(
//                 users[index],
//               ),
//             ),
//           ),
//           leading: //ProfileAvatar(imageUrl: null, radius: 20),
//               ProfileAvatar(imageFile: null, width: 20, height: 20),
//           title: RichText(
//               text: TextSpan(
//             text: 'users[index].fullName',
//             style: TextStyle(
//                 color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
//           )),
//         ),
//         itemCount: users.length,
//       ),
//     );
//   }
// }

// class SearchData extends SearchDelegate<UserData> {
//   final List<UserData> users = [
//     new UserData.fromUserData("Leon", "g.com", "0544", "123", null),
//   ];
// // UserData(this._fullName, this._email, this._age, this._gender,
// //       this._yearsOfExperience, this._imei, this._imageUrl);
//   final recentUser = [
//     new UserData.fromUserData("Leon", "g.com", "0544", "123", null)
//   ];
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             query = "";
//           }),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         icon: AnimatedIcon(
//             icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
//         onPressed: () {
//           close(context, null);
//         });
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Card(
//       color: Colors.red,
//       shape: StadiumBorder(),
//       child: Center(
//         child: Text(query),
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionList = query.isEmpty
//         ? recentUser
//         : users.where((p) => p.fullName.startsWith(query)).toList();
//     return ListView.builder(
//       itemBuilder: (context, index) => ListTile(
//         onTap: () {
//           showResults(context);
//         },
//         leading: //ProfileAvatar(imageUrl: null, radius: 20),
//             ProfileAvatar(imageFile: null, width: 20, height: 20),
//         title: RichText(
//             text: TextSpan(
//                 text: suggestionList[index].fullName.substring(0, query.length),
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 17),
//                 children: [
//               TextSpan(
//                   text: suggestionList[index].fullName.substring(query.length),
//                   style: TextStyle(color: Colors.grey, fontSize: 17))
//             ])),
//       ),
//       itemCount: suggestionList.length,
//     );
//   }
// }
