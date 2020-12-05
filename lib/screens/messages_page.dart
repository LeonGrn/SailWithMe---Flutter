import 'dart:ui';

import 'package:SailWithMe/config/palette.dart';
import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/widgets/profile_avatar.dart';
import 'package:SailWithMe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessagesPage extends StatelessWidget {
  final List<UserData> users = [
    new UserData("Leon", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
    new UserData("Ofer", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
    new UserData("Hani", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
    new UserData("New York", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
    new UserData("ssss", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchData());
            },
            icon: Icon(Icons.search),
            color: Colors.black,
          )
        ],
        centerTitle: false,
        title: Text(
          'Messages',
          style: TextStyle(
              color: Palette.sailWithMe,
              fontFamily: 'IndieFlower',
              fontSize: 25.0),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                users[index],
              ),
            ),
          ),
          leading: ProfileAvatar(imageUrl: users[index].imageUrl, radius: 20),
          title: RichText(
              text: TextSpan(
            text: users[index].firstName + " " + users[index].lastName,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
          )),
        ),
        itemCount: users.length,
      ),
    );
  }
}

class SearchData extends SearchDelegate<UserData> {
  final List<UserData> users = [
    new UserData("Leon", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
    new UserData("Ofer", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
    new UserData("Hani", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
    new UserData("New York", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
    new UserData("ssss", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8"),
  ];

  final recentUser = [
    new UserData("Leon", "G", "g.com", 0544, "123",
        "https://images.unsplash.com/photo-1525253086316-d0c936c814f8")
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Card(
      color: Colors.red,
      shape: StadiumBorder(),
      child: Center(
        child: Text(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentUser
        : users.where((p) => p.firstName.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: ProfileAvatar(imageUrl: users[index].imageUrl, radius: 20),
        title: RichText(
            text: TextSpan(
                text:
                    suggestionList[index].firstName.substring(0, query.length),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
                children: [
              TextSpan(
                  text: suggestionList[index].firstName.substring(query.length),
                  style: TextStyle(color: Colors.grey, fontSize: 17))
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}
