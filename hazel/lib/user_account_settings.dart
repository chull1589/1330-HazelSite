// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hazel/change_password_form.dart';
import 'package:hazel/user_settings.dart';
import 'package:provider/provider.dart';

import './home.dart';
import './me_page.dart';
import './nav_bar.dart';
import 'change_password_form.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(179, 180, 61, .1),
  100: Color.fromRGBO(179, 180, 61, .2),
  200: Color.fromRGBO(179, 180, 61, .3),
  300: Color.fromRGBO(179, 180, 61, .4),
  400: Color.fromRGBO(179, 180, 61, .5),
  500: Color.fromRGBO(179, 180, 61, .6),
  600: Color.fromRGBO(179, 180, 61, .7),
  700: Color.fromRGBO(179, 180, 61, .8),
  800: Color.fromRGBO(179, 180, 61, .9),
  900: Color.fromRGBO(179, 180, 61, 1),
};

MaterialColor navColor = MaterialColor(0xFFB3B43D, color);

class UserAccountSettingsPage extends StatefulWidget {
  const UserAccountSettingsPage({Key? key}) : super(key: key);

  @override
  _UserAccountSettingsPageState createState() =>
      _UserAccountSettingsPageState();
}

class _UserAccountSettingsPageState extends State<UserAccountSettingsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireDb = FirebaseFirestore.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String? uid = auth.currentUser?.uid;
    User? currentUser = auth.currentUser;
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: navColor,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text("Hazel", style: TextStyle(color: Colors.white)),
              actions: <Widget>[NavBar()],
            ),
            body: Center(
                child: Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      color: Colors.lime[50], //page background color
                    ),
                    child: ListView(
                      children: [
                        Container(
                          //Settings page user info box
                          margin: EdgeInsets.only(top: 20.0),
                          height: 284.0,
                          width: 1023.0,
                          color: Colors.transparent,
                          child: Container(
                              margin:
                                  EdgeInsets.only(left: 100.0, right: 100.0),
                              decoration: BoxDecoration(
                                  color:
                                      Colors.lime[50], //box 1 background color
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Center(
                                                child: Container(
                                                    width: 330.0,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 25.0,
                                                          bottom: 15.0,
                                                          left: 60),
                                                      child: CircleAvatar(
                                                        //Profile Avatar
                                                        backgroundImage: AssetImage(
                                                            'assets/Google@3x.png'),
                                                        radius: 50,
                                                      ),
                                                    ))),
                                          ),
                                          Container(
                                            //Settings button
                                            padding: EdgeInsets.only(
                                                top: 15.0, right: 15.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back_ios,
                                                ),
                                                iconSize: 20,
                                                color: Colors.grey,
                                                splashColor: Colors.purple,
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserSettings()),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        //Profile name below profile picture
                                        child: Container(
                                            child: StreamBuilder(
                                                stream: fireDb
                                                    .collection('users')
                                                    .doc(uid)
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container(
                                                        width: 330.0,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5.0,
                                                                    bottom:
                                                                        5.0),
                                                            child: Text(
                                                              "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .teal[
                                                                      900],
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'Roboto'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )));
                                                  }
                                                  return Container(
                                                      width: 330.0,
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5.0,
                                                                  bottom: 5.0),
                                                          child: Text(
                                                            "${snapshot.data!['firstname']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .teal[900],
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Roboto'),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )));
                                                })),
                                      ),
                                      Container(
                                          child: Text(
                                        //For time joined
                                        "Joined: 2022",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: 'Roboto'),
                                        textAlign: TextAlign.center,
                                      )),
                                    ],
                                  ))),
                        ),
                        Container(
                            //Account details + divider
                            margin: EdgeInsets.only(left: 100.0, right: 100.0),
                            child: Column(
                              children: [
                                Text(
                                  "Account Details",
                                  style: TextStyle(
                                      color: Colors.teal[900],
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(color: Colors.black),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            child: StreamBuilder(
                                                stream: fireDb
                                                    .collection('users')
                                                    .doc(uid)
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container(
                                                        width: 330.0,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10.0,
                                                                    bottom:
                                                                        10.0),
                                                            child: Text(
                                                              "First Name: ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .teal[
                                                                      900],
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Roboto'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            )));
                                                  }
                                                  return Container(
                                                      width: 330.0,
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10.0,
                                                                  bottom: 10.0),
                                                          child: Text(
                                                            "First Name:  ${snapshot.data!['firstname']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .teal[900],
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Roboto'),
                                                            // textAlign:
                                                            //     TextAlign.left,
                                                          )));
                                                })),
                                        SizedBox(width: 50.0),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            child: StreamBuilder(
                                                stream: fireDb
                                                    .collection('users')
                                                    .doc(uid)
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container(
                                                        width: 330.0,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10.0,
                                                                    bottom:
                                                                        10.0),
                                                            child: Text(
                                                              "Last Name: ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .teal[
                                                                      900],
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Roboto'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            )));
                                                  }
                                                  return Container(
                                                      width: 330.0,
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10.0,
                                                                  bottom: 10.0),
                                                          child: Text(
                                                            "Last Name:  ${snapshot.data!['lastname']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .teal[900],
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'Roboto'),
                                                            textAlign:
                                                                TextAlign.left,
                                                          )));
                                                })),
                                        SizedBox(width: 50.0),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, bottom: 10.0),
                                            child: Text(
                                              "Email: ${currentUser?.email}",
                                              style: TextStyle(
                                                  color: Colors.teal[900],
                                                  fontSize: 20,
                                                  fontFamily: 'Roboto'),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 50.0),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, bottom: 10.0),
                                            child: Text(
                                              "Password: ******",
                                              style: TextStyle(
                                                  color: Colors.teal[900],
                                                  fontSize: 20,
                                                  fontFamily: 'Roboto'),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 50.0),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              left: 100, right: 100, top: 50, bottom: 50),
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangePasswordForm()),
                                );
                              }, //SHOULD OPEN CHANGE PASSWORD FORM
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  side: BorderSide(
                                      color: Colors.lightGreen.shade400,
                                      width: 2)),
                              child: Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text(
                                    "Change Password",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.lightGreen[400]),
                                  ))),
                        ),
                        // Container(
                        //     alignment: Alignment.centerLeft,
                        //     margin: EdgeInsets.only(left: 100.0, right: 100.0),
                        //     child: Column(
                        //       children: [
                        //         Text(
                        //           "Payment Information",
                        //           style: TextStyle(
                        //               color: Colors.teal[900],
                        //               fontSize: 30,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //         Divider(color: Colors.black),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               child: Padding(
                        //                 padding: EdgeInsets.only(
                        //                     top: 10.0, bottom: 10.0),
                        //                 child: Text(
                        //                   "Payment Type: ",
                        //                   style: TextStyle(
                        //                       color: Colors.teal[900],
                        //                       fontSize: 20,
                        //                       fontFamily: 'Roboto'),
                        //                   textAlign: TextAlign.left,
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(width: 50.0),
                        //           ],
                        //         ),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               child: Padding(
                        //                 padding: EdgeInsets.only(
                        //                     top: 10.0, bottom: 10.0),
                        //                 child: Text(
                        //                   "Card Number: ",
                        //                   style: TextStyle(
                        //                       color: Colors.teal[900],
                        //                       fontSize: 20,
                        //                       fontFamily: 'Roboto'),
                        //                   textAlign: TextAlign.left,
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(width: 50.0),
                        //           ],
                        //         ),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               child: Padding(
                        //                 padding: EdgeInsets.only(
                        //                     top: 10.0, bottom: 10.0),
                        //                 child: Text(
                        //                   "Billing Address: ",
                        //                   style: TextStyle(
                        //                       color: Colors.teal[900],
                        //                       fontSize: 20,
                        //                       fontFamily: 'Roboto'),
                        //                   textAlign: TextAlign.left,
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(width: 50.0),
                        //           ],
                        //         ),
                        //         Row(
                        //           children: [
                        //             Container(
                        //               child: Padding(
                        //                 padding: EdgeInsets.only(
                        //                     top: 10.0, bottom: 10.0),
                        //                 child: Text(
                        //                   "Zipcode: ",
                        //                   style: TextStyle(
                        //                       color: Colors.teal[900],
                        //                       fontSize: 20,
                        //                       fontFamily: 'Roboto'),
                        //                   textAlign: TextAlign.left,
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(width: 50.0),
                        //           ],
                        //         ),
                        //         Container(
                        //           margin: EdgeInsets.only(
                        //               left: 100,
                        //               right: 100,
                        //               top: 50,
                        //               bottom: 50),
                        //           child: OutlinedButton(
                        //               onPressed: () {
                        //                 auth.signOut();
                        //                 Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(
                        //                       builder: (context) => HomePage()),
                        //                 );
                        //               }, //SHOULD LOG OUT
                        //               style: OutlinedButton.styleFrom(
                        //                   shape: RoundedRectangleBorder(
                        //                       // side: BorderSide(
                        //                       //     color: Colors.lightGreen.shade400,
                        //                       //     width: 1),
                        //                       borderRadius:
                        //                           BorderRadius.circular(30)),
                        //                   side: BorderSide(
                        //                       color: Colors.lightGreen.shade400,
                        //                       width: 2)),
                        //               child: Padding(
                        //                   padding: EdgeInsets.only(
                        //                       top: 15, bottom: 15),
                        //                   child: Text(
                        //                     "Change Payment Information",
                        //                     style: TextStyle(
                        //                         fontSize: 20,
                        //                         color: Colors.lightGreen[400]),
                        //                   ))),
                        //         ),
                        //       ],
                        //     )),
                      ],
                    )))));
  }
}
