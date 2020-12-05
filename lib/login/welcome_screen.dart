import 'package:SailWithMe/widgets/welcome_body.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeBody(),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text("Login"),
//     ),
//     body: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         TextField(
//           onChanged: (value) {
//             _email = value;
//           },
//           decoration: InputDecoration(hintText: "Enter Email"),
//         ),
//         TextField(
//           onChanged: (value) {
//             _password = value;
//           },
//           decoration: InputDecoration(hintText: "Enter password"),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             MaterialButton(
//               onPressed: () {
//                 _login();
//               },
//               child: Text("Login"),
//             ),
//             MaterialButton(
//               onPressed: () {
//                 _createUser();
//               },
//               child: Text("Create new Account"),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
