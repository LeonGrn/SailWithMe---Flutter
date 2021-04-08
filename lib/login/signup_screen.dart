import 'dart:async';
import 'dart:io';

import 'package:SailWithMe/models/models.dart';
import 'package:SailWithMe/screens/navigation_screens.dart';
import 'package:SailWithMe/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:image_picker/image_picker.dart';

import '../config/ApiCalls.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SignUpScreen> {
  bool _passwordVisible;
  String birthDate = "";
  int age = -1;

  String _email = "";
  String _password = "";
  String _fullName = "";
  String gender = "";
  String _yearsOfExperience = "";
  File _image;

  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";
  String _imageRef = "";
  TextEditingController nameController = TextEditingController();
  int _radioValue = 0;
  AssetImage myChoosenImage = new AssetImage('assets/user.png');

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      print(multiImei);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
      uniqueId = idunique;
    });
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _createUser() async {
    try {
      await ApiCalls.authNewUser(_email, _password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    _imageRef = await ApiCalls.uploadPic(_email, _image, "Profile");

    UserData createdUser = UserData(
        fullName: _fullName,
        email: _email,
        age: age.toString(),
        gender: gender,
        yearsOfExperience: _yearsOfExperience,
        imei: uniqueId,
        imageRef: _imageRef,
        posts: [],
        friendsList: []);

    await ApiCalls.createUser(createdUser);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => new BottomNavBar()),
        (e) => false);
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          gender = "Male";
          break;
        case 1:
          gender = "Female";
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

          completer.complete(temp);
          setState(() {});
        },
      );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

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
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child:
                      ProfileAvatar(imageFile: _image, width: 120, height: 120),
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
                  onChanged: (value) {
                    _fullName = value;
                  },
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
                  onChanged: (value) {
                    _yearsOfExperience = value;
                  },
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
