import 'dart:io';

import 'package:SailWithMe/config/palette.dart';
import 'package:SailWithMe/widgets/circle_button.dart';
import 'package:SailWithMe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:SailWithMe/models/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:SailWithMe/date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SailWithMe/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserData myUser;
  UserData user1 =
      new UserData.fromUserData("Leon", "g.com", '0544', "123", null);

  var temp;
  //var location;
  var windSpeed;
  String main;
  String _timezone = 'Unknown';
  String assetName = 'assets/sun.svg';
  bool isSearching = false;

  Future getWeather() async {
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=Netanya&appid=a43c41d2c4008b88f98a49068edebbf1");
    var results = jsonDecode(response.body);
    if (mounted) {
      setState(() {
        this.temp = results['main']['temp'];
        this.temp = this.temp - 273.15;
        this.windSpeed = results['wind']['speed'];
        this.main = results['weather'][0]['main'];
      });
    }
  }

  Future _getData() async {
    final fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    var userId = FirebaseAuth.instance.currentUser.uid;
    await ref.child(userId).once().then((DataSnapshot data) {
      print(data.value);
      print(data.key);
      myUser = UserData.fromJson(data);
      print(myUser.age +
          myUser.email +
          myUser.fullName +
          myUser.yearsOfExperience +
          myUser.imei +
          myUser.gender);
    });
  }

  Future<void> downloadFileFromFirebaseStorage() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    File downloadToFile = File('${appDocDir.path}/download-logo.png');

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('profile/myProfile.png')
          .writeToFile(downloadToFile);
      myUser.setImage(downloadToFile);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
      print("my life fail");
    }
  }

  // Future<void> initPlatformState() async {
  //   String timezone;
  //   try {
  //     timezone = await FlutterNativeTimezone.getLocalTimezone();
  //   } on PlatformException {
  //     timezone = 'Failed to get the timezone.';
  //   }
  //   setState(() {
  //     _timezone = timezone;
  //     print(timezone + "blabla");
  //     // if (int.parse('_timezone') > 6 && int.parse('_timezone') < 18)
  //     //   assetName = 'assets/sun.svg';
  //     // else
  //     //   assetName = 'assets/moon.svg';
  //   });
  // }

  @override
  void initState() {
    super.initState();
    this.getWeather();
    this._getData();
    this.downloadFileFromFirebaseStorage();
    // this.initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: new IconButton(
            color: Colors.black,
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: !isSearching
            ? Text(
                "SAIL WITH ME",
                style: TextStyle(
                    color: Palette.sailWithMe,
                    fontFamily: 'IndieFlower',
                    fontSize: 25.0),
              )
            : TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    hintText: "Search",
                    contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(color: Colors.black)),
              ),
        actions: [
          isSearching
              ? CircleButton(
                  icon: Icons.cancel,
                  iconSize: 25.0,
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                    });
                  })
              : CircleButton(
                  icon: Icons.search,
                  iconSize: 25.0,
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  }),
          CircleButton(
              icon: Icons.add_alert,
              iconSize: 25.0,
              onPressed: () {
                setState(() {});
              }),
        ],
      ),
      body: Column(
        children: [
          new Container(
            height: 80,
            margin: EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(flex: 3),
                Text(
                  "Netanya",
                  style: TextStyle(fontSize: 20.0),
                ),
                //SizedBox(width: 50),
                Spacer(flex: 3),
                SvgPicture.asset(
                  assetName,
                  width: 20,
                  height: 20,
                ),
                Text(
                  temp != null ? temp.toStringAsFixed(1) : "Loading",
                  style: TextStyle(fontSize: 35.0),
                ),
                //SizedBox(width: 15),
                Spacer(flex: 1),
                VerticalDivider(
                  color: Colors.blueGrey,
                  thickness: 1,
                  width: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                //SizedBox(width: 15),
                Spacer(flex: 3),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      main != null ? main : "Loading",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      windSpeed != null
                          ? windSpeed.toString() + "km/h"
                          : "Loading",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                Spacer(flex: 3),
              ],
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: posts.length,
          //     itemBuilder: (context, index) {
          //       Post post = posts[index];
          //       return PostContainer(post: post);
          //     },
          //   ),
          // ),
        ],
      ),
      drawer: HomePageDrawer(myUser: myUser),
    );
  }
}

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    Key key,
    @required this.myUser,
  }) : super(key: key);

  final UserData myUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Center(
      child: new ListView(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: [
              SizedBox(
                height: 120.0,
                child: new DrawerHeader(
                  child: ProfileAvatar(
                      imageFile: myUser.getImage(), width: 120, height: 120),
                ),
              ),
              Text(myUser.fullName,
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("View profile"),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 5, 40, 0),
                child: FlatButton(
                  onPressed: () {},
                  textColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.blue,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/yacht.svg',
                        width: 30,
                        height: 30,
                        color: Colors.blue,
                      ),
                      Text(
                        'My Boat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          new ListTile(
            leading: Icon(Icons.person_outline),
            title: new Text("Friends"),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.push(context,
              //     new MaterialPageRoute(builder: (context) => new HomePage()));
            },
          ),
          new ListTile(
            leading: Icon(Icons.event),
            title: new Text("Events"),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.push(context,
              //     new MaterialPageRoute(builder: (context) => new HomePage()));
            },
          ),
          new ListTile(
            leading: Icon(Icons.group_outlined),
            title: new Text("Groups"),
            onTap: () {
              //   Navigator.pop(context);
              //   Navigator.push(context,
              //       new MaterialPageRoute(builder: (context) => new HomePage()));
            },
          ),
          new ListTile(
            leading: Icon(Icons.work_outline),
            title: new Text("Jobs"),
            onTap: () {},
          ),
          Divider(
            height: 3,
            color: Colors.black,
          ),
          new ListTile(
            leading: Icon(Icons.help_outline),
            title: new Text("Help"),
            onTap: () {},
          ),
          new ListTile(
            leading: Icon(Icons.settings_applications_outlined),
            title: new Text("Settings"),
            onTap: () {},
          ),
          new ListTile(
            leading: Icon(Icons.exit_to_app),
            title: new Text("Log Out"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              //Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     new MaterialPageRoute(
              //         builder: (context) => new LandingPage()));
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => new LandingPage()),
                  (e) => false);
            },
          ),
        ],
      ),
    ));
  }
}
