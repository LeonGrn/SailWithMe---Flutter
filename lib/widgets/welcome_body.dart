import 'package:SailWithMe/config/palette.dart';
import 'package:SailWithMe/screens/login/login_screen.dart';
import 'package:SailWithMe/screens/login/signup_screen.dart';
import 'package:SailWithMe/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LETS SAIL",
              style: TextStyle(
                  color: Palette.sailWithMe,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            ),
            SizedBox(height: size.height * 0.05),
            Image.asset(
              'assets/sailing.png',
              width: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              color: Palette.kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/main_top.png',
                width: size.width * 0.3,
              )),
          Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/main_bottom.png',
                width: size.width * 0.2,
              )),
          child,
        ],
      ),
    );
  }
}
