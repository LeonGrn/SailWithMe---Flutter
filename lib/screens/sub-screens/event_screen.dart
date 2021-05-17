import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/config/palette.dart';
import 'package:SailWithMe/models/modules.dart';
import 'package:SailWithMe/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
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
          "EVENT LIST",
          style: TextStyle(
              color: Palette.sailWithMe,
              fontFamily: 'IndieFlower',
              fontSize: 25.0),
        ),
      ),
      body: FutureBuilder(
        future: ApiCalls.getListOfPost(), // async work
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
    );
  }
}
