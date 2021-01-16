import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

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
import 'package:firebase_image/firebase_image.dart';

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
  File imageUrl;

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
      inspect(myUser);
      print(myUser.age +
          myUser.email +
          myUser.fullName +
          myUser.yearsOfExperience +
          myUser.imei +
          myUser.gender);

      print(myUser.getImageRef);
    });
  }

  Future<void> downloadFileFromFirebaseStorage() async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();

    // File downloadToFile = File('${appDocDir.path}/download-logo.png');
    // final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage(
    //       app: Firestore.instance.app,
    //       storageBucket: 'gs://my-project.appspot.com');

    //   Uint8List imageBytes;
    //   String errImage m;
    // await FireStorageService.loadImage(context, image).then((downloadUrl) {
    //   m = Image.network(
    //     downloadUrl.toString(),
    //     fit: BoxFit.scaleDown,
    //   );
    // }orMsg;

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(myUser.getImageRef);
// no need of the file extension, the name will do fine.
      var url = await ref.getDownloadURL();
      print(url);
      // await firebase_storage.FirebaseStorage.instance
      //     .ref(myUser.getImageRef)
      //     .writeToFile(downloadToFile);
      // //myUser.setImage(downloadToFile);
      // imageUrl = downloadToFile;
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
    //this.downloadFileFromFirebaseStorage();
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
          Expanded(
            child: myUser.getPosts.isNotEmpty
                ? ListView.builder(
                    itemCount: myUser.getPosts.length,
                    itemBuilder: (context, index) {
                      Post post = myUser.getPosts[index];
                      return PostContainer(post: post);
                    },
                  )
                : Text("No Posts"),
          ),
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
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage: myUser.getImageRef != ""
                          ? FirebaseImage(
                              'gs://sailwithme.appspot.com/' +
                                  myUser.getImageRef,
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
                  )),
              Text(myUser.getFullName,
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
