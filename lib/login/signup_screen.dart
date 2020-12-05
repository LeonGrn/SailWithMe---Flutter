import 'dart:async';
import 'dart:io';

import 'package:SailWithMe/screens/navigation_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SignUpScreen> {
  DatabaseReference _dbRef;

  bool _passwordVisible;
  String birthDate = "";
  int age = -1;

  String _email = "";
  String _password = "";

  TextEditingController nameController = TextEditingController();
  int _radioValue = 0;

  @override
  void initState() {
    _passwordVisible = false;
    _dbRef = FirebaseDatabase.instance.reference().child('myUsers');

    super.initState();
  }

  Future<void> _createUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);

      _dbRef.child(userCredential.user.uid).set({
        'Email': _email,
      });
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

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  selectDate(BuildContext context, DateTime initialDateTime,
      {DateTime lastDate}) async {
    Completer completer = Completer();
    if (Platform.isAndroid)
      showDatePicker(
              context: context,
              initialDate: initialDateTime,
              firstDate: DateTime(1970),
              lastDate: lastDate == null
                  ? DateTime(initialDateTime.year + 10)
                  : lastDate)
          .then((temp) {
        if (temp == null) return null;
//        _selectedDateInString = df.format(temp);
        completer.complete(temp);
        setState(() {});
      });
    else
      DatePicker.showDatePicker(
        context,
        dateFormat: 'yyyy-mmm-dd',
        locale: 'en',
        onConfirm2: (temp, selectedIndex) {
          if (temp == null) return null;
//          final df = new DateFormat('dd-MMM-yyyy');
//          _selectedDateInString = df.format(temp);
          completer.complete(temp);
          setState(() {});
        },
      );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    AssetImage myChoosenImage = new AssetImage('assets/user.png');

    TextStyle valueTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    TextStyle textTextStyle = TextStyle(
      fontSize: 15,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: myChoosenImage),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Register Details",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 25.0,
                      fontStyle: FontStyle.normal),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Enter Full Name",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.tag_faces,
                        color: Colors.white,
                      ),
                      labelText: "Full Name"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  onChanged: (value) {
                    _email = value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Enter Email",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.tag_faces,
                        color: Colors.white,
                      ),
                      labelText: "Email Id"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  onChanged: (value) {
                    _password = value;
                  },
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Enter Password",
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.tag_faces,
                        color: Colors.white,
                      ),
                      labelText: "Password"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'Male',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      width: 35,
                    ),
                    new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'Female',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    //mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border: Border.all(color: Colors.grey)),
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "BirthDate: ",
                                  style: textTextStyle,
                                ),
                                Text(
                                  "$birthDate",
                                  style: valueTextStyle,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 32,
                      // ),
                      GestureDetector(
                        child: new Icon(
                          Icons.calendar_today,
                          size: 50,
                        ),
                        onTap: () async {
                          DateTime birthDate = await selectDate(
                              context, DateTime.now(),
                              lastDate: DateTime.now());
                          final df = new DateFormat('dd-MMM-yyyy');
                          this.birthDate = df.format(birthDate);
                          this.age = calculateAge(birthDate);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numb
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "Please enter years of experience",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.tag_faces,
                        color: Colors.white,
                      ),
                      labelText: "Please enter years of experience"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                    child: Text("Submit"),
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    onPressed: () {
                      _createUser();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
