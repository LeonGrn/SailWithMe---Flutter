import 'package:SailWithMe/screens/emergency_page.dart';
import 'package:SailWithMe/screens/home_page.dart';
import 'package:SailWithMe/screens/map_page.dart';
import 'package:SailWithMe/screens/messages_page.dart';
import 'package:SailWithMe/screens/post_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() => runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  GlobalKey _bottomNavigationKey = GlobalKey();

  final HomePage _homePage = HomePage();
  final EmergencyPage _emergencyPage = EmergencyPage();
  final MapPage _mapPage = MapPage();
  final PostPage _postPage = PostPage();
  final MessagesPage _messagesPage = MessagesPage();

  Widget _showPage = new HomePage();
  int lastIndex = 0;
  Widget lastPage = HomePage();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _homePage;
        break;
      case 1:
        return _mapPage;
        break;
      case 2:
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return _postPage;
            },
            fullscreenDialog: true));
        return lastPage;
        break;
      case 3:
        return _messagesPage;
        break;
      case 4:
        return _emergencyPage;
        break;
      default:
        return new Container(
          child: Text("NO Page found"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: lastIndex,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.map, size: 30),
            Icon(Icons.add_circle_outline, size: 30),
            Icon(Icons.sms, size: 30),
            Icon(Icons.error_outline, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (int tappedIndex) {
            _bottomNavigationKey = GlobalKey();
            if (tappedIndex == 2) {
              setState(() {
                _showPage = _pageChooser(tappedIndex);
              });
            } else {
              setState(() {
                _showPage = _pageChooser(tappedIndex);
                lastIndex = tappedIndex;
                lastPage = _showPage;
              });
            }
          },
        ),
        body: Container(
          color: Colors.blueAccent,
          child: Center(
            child: _showPage,
          ),
        ));
  }
}
