import 'dart:developer';
import 'dart:io';
import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/config/palette.dart';
import 'package:SailWithMe/screens/sub-screens/friendsList_screen.dart';
import 'package:SailWithMe/screens/sub-screens/jobOfferList_screen.dart';
import 'package:SailWithMe/screens/sub-screens/profile_screen.dart';
import 'package:SailWithMe/widgets/circle_button.dart';
import 'package:SailWithMe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:SailWithMe/models/modules.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:SailWithMe/main.dart';
import 'package:firebase_image/firebase_image.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserData myUser;
  String searchText = '';
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
    // this.initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ApiCalls.getUserData(),
        builder: (context, snapshot) {
          inspect(snapshot.data);
          if (snapshot.hasData) return _buildScaffold(snapshot.data);
          if (snapshot.hasError) return Text("Error ${snapshot.error}");

          return Text("Loading");
        });
  }

  Scaffold _buildScaffold(UserData myUser) {
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
            : textFieldForSearchBar(),
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
          CircleButton(icon: Icons.add_alert, iconSize: 25.0, onPressed: () {}),
        ],
      ),
      body: !isSearching
          ? PostsBodyWigit(
              assetName: assetName,
              temp: temp,
              main: main,
              windSpeed: windSpeed)
          : searchBar(),
      drawer: HomePageDrawer(myUser: myUser),
    );
  }

  Widget searchBar() {
    return (FutureBuilder(
        future: ApiCalls.searchUsers(searchText),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            print(" eeeeeeeeeeeeeee");
            return Container(child: Text("wait..."));
          }
          if (snapshot.hasError) {
            print("error : " + snapshot.error);
          } else {
            searchText = "";
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  print(snapshot.data[index].name + " ggggggggggggggggggggggg");
                  return ListTile(
                      title: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(new MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return ProfileScreen(
                                        id: snapshot.data[index].id);
                                  },
                                  fullscreenDialog: true));
                        },
                        child: Text(snapshot.data[index].name),
                      ),
                      trailing: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: FirebaseImage(
                          'gs://sailwithme.appspot.com/' +
                              snapshot.data[index].imageUrl,
                          shouldCache:
                              true, // The image should be cached (default: True)
                          //             // maxSizeBytes:
                          //             //     3000 * 1000, // 3MB max file size (default: 2.5MB)
                          //             // cacheRefreshStrategy: CacheRefreshStrategy
                          //             //     .NEVER // Switch off update checking
                          //
                        ),
                      ));
                });
          }
        }));
  }

  Widget textFieldForSearchBar() {
    return TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            prefixText: searchText,
            contentPadding: EdgeInsets.all(16),
            hintStyle: TextStyle(color: Colors.black)),
        onChanged: (text) {
          searchText = text;
          if (searchText.length > 2) {
            setState(() {});
          }
        });
  }
}

class PostsBodyWigit extends StatelessWidget {
  const PostsBodyWigit({
    Key key,
    @required this.assetName,
    @required this.temp,
    @required this.main,
    @required this.windSpeed,
  }) : super(key: key);

  final String assetName;
  final temp;
  final String main;
  final windSpeed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new Container(
          height: 80,
          margin: EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Spacer(flex: 3),
              Text(
                "Netanya",
                style: TextStyle(fontSize: 20.0),
              ),
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
              Spacer(flex: 1),
              VerticalDivider(
                color: Colors.blueGrey,
                thickness: 1,
                width: 1,
                indent: 20,
                endIndent: 20,
              ),
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
          child: FutureBuilder(
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
        ),
      ],
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
                        backgroundImage: FirebaseImage(
                          'gs://sailwithme.appspot.com/' + myUser.getImageRef,
                          shouldCache:
                              true, // The image should be cached (default: True)
                          //             // maxSizeBytes:
                          //             //     3000 * 1000, // 3MB max file size (default: 2.5MB)
                          //             // cacheRefreshStrategy: CacheRefreshStrategy
                          //             //     .NEVER // Switch off update checking
                        )),
                  )),
              Text(myUser.getFullName,
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(new MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return ProfileScreen(
                                        id: ApiCalls.recieveUserInstance());
                                  },
                                  fullscreenDialog: true));
                        },
                        child: Text(
                          'View Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
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
              Navigator.pop(context);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new FriendListScreen()));
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
            leading: Icon(Icons.group),
            title: new Text("Groups"),
            onTap: () {
              //   Navigator.pop(context);
              //   Navigator.push(context,
              //       new MaterialPageRoute(builder: (context) => new HomePage()));
            },
          ),
          new ListTile(
            leading: Icon(Icons.work),
            title: new Text("Jobs"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new JobOfferListScreen()));
            },
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
            leading: Icon(Icons.settings),
            title: new Text("Settings"),
            onTap: () {},
          ),
          new ListTile(
            leading: Icon(Icons.exit_to_app),
            title: new Text("Log Out"),
            onTap: () {
              ApiCalls.signOut();

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
