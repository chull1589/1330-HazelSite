// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './login_valid.dart';
import './public_home.dart';
import './me_page.dart';

class NavBar extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    // auth.currentUser for now
    // change to authStateChanges() when routing set up?
    if (auth.currentUser == null) {
      return Row(children: [
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: TextButton(
            style: style,
            onPressed:
                () {}, //SHOULD TAKE THEM TO COMMUNITY PAGE WHEN IMPLEMENTED
            child: const Text("Community",
                style: TextStyle(
                  color: Color(0xFF7C813F),
                )),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: TextButton(
            style: style,
            onPressed: () {}, //SHOULD TAKE THEM TO videos PAGE WHEN IMPLEMENTED
            child: const Text("Videos",
                style: TextStyle(
                  color: Color(0xFF7C813F),
                )),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: TextButton(
            style: style,
            onPressed:
                () {}, //SHOULD TAKE THEM TO projects PAGE WHEN IMPLEMENTED
            child: const Text("Projects",
                style: TextStyle(
                  color: Color(0xFF7C813F),
                )),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: TextButton(
            style: style,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Text("Login/Signup",
                style: TextStyle(
                  color: Color(0xFF7C813F),
                )),
          ),
        ),
      ]);
    } else {
      // logged in user, so show other navbar
      return Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: TextButton(
              style: style,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MePage()),
                );
              }, //SHOULD TAKE THEM TO ME PAGE WHEN IMPLEMENTED
              child: const Text("Me",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                  )),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: TextButton(
              style: style,
              onPressed:
                  () {}, //SHOULD TAKE THEM TO COMMUNITY PAGE WHEN IMPLEMENTED
              child: const Text("Community",
                  style: TextStyle(
                    color: Color(0xFF7C813F),
                  )),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: TextButton(
              style: style,
              onPressed:
                  () {}, //SHOULD TAKE THEM TO VIDEOS PAGE WHEN IMPLEMENTED
              child: const Text("Videos",
                  style: TextStyle(
                    color: Color(0xFF7C813F),
                  )),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: TextButton(
              style: style,
              onPressed:
                  () {}, //SHOULD TAKE THEM TO COMMUNITY PAGE WHEN IMPLEMENTED
              child: const Text("Impact",
                  style: TextStyle(
                    color: Color(0xFF7C813F),
                  )),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: TextButton(
              style: style,
              onPressed:
                  () {}, //SHOULD TAKE THEM TO projects PAGE WHEN IMPLEMENTED
              child: const Text("Projects",
                  style: TextStyle(
                    color: Color(0xFF7C813F),
                  )),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: TextButton(
              style: style,
              onPressed:
                  () {}, //SHOULD TAKE THEM TO COMMUNITY PAGE WHEN IMPLEMENTED
              child: const Text("Cart",
                  style: TextStyle(
                    color: Color(0xFF7C813F),
                  )),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40),
            child: TextButton(
              style: style,
              onPressed: () {
                auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PublicHomePage()),
                );
              },
              child: const Text("Log Out",
                  style: TextStyle(
                    color: Color(0xFF7C813F),
                  )),
            ),
          ),
        ],
      );
    }
  }
}