import 'package:SailWithMe/login/signup_screen.dart';
import 'package:SailWithMe/screens/navigation_screens.dart';
import 'package:SailWithMe/widgets/already_have_account.dart';
import 'package:SailWithMe/widgets/rounded_button.dart';
import 'package:SailWithMe/widgets/rounded_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SailWithMe/widgets/rounded_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  String _email = "";

  String _password = "";

  Future<void> _login(context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => new BottomNavBar()),
          (e) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Size size = MediaQuery.of(context).size;

    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "LOGIN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          Image.asset(
            'assets/sun2.png',
            height: size.height * 0.35,
          ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
            hintText: "Your Email",
            onChanged: (value) {
              _email = value;
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              _password = value;
            },
          ),
          RoundedButton(
            text: "LOGIN",
            press: () {
              _login(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return BottomNavBar();
              //     },
              //   ),
              // );
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => new BottomNavBar()),
              //     (e) => false);
            },
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
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
    ));
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
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/main_top.png', width: size.width * 0.35),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child:
                Image.asset('assets/login_bottom.png', width: size.width * 0.4),
          ),
          child,
        ],
      ),
    );
  }
}
