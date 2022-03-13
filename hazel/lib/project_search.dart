// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hazel/nav_bar.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import './home.dart';
import './user_settings.dart';
import './me_page.dart';
import './login_valid.dart';
import './nav_bar.dart';
import './project_page.dart';

class ProjectSearch extends StatefulWidget {
  const ProjectSearch({Key? key}) : super(key: key);

  @override
  _ProjectSearchState createState() => _ProjectSearchState();
}

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
// variable that controls visbility class (search filters)
bool showFilters = false;
bool favorited = false;

class _ProjectSearchState extends State<ProjectSearch> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    User? currentUser = auth.currentUser;
    int projNum = 0;

    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: navColor,
        ),
        home: Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Image.asset('assets/Google@3x.png'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                      //Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              title: Text("Hazel", style: TextStyle(color: Colors.white)),
              actions: <Widget>[NavBar()],
            ),
            body: Center(
              child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/boatfilter.png'),
                          fit: BoxFit.cover)),
                  child: ListView(children: [
                    Padding(
                        padding: EdgeInsets.only(top: 25.0, bottom: 5.0),
                        child: Text(
                          'Projects',
                          style: TextStyle(
                              color: Color(0xFFF9F8F1),
                              fontSize: 70,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        )),
                    Container(
                        margin:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                        height: 60.0,
                        width: 100.0,
                        color: Colors.transparent,
                        child: Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  fillColor: Color(0xFFF9F8F1),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  hintText: 'Search projects'),
                            ))),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment(0.95, 0.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                showFilters = !showFilters;
                              });
                            },
                            child: showFilters
                                ? Text('Hide Search Filters',
                                    style: TextStyle(
                                      color: Color(0xFFF9F8F1),
                                      fontSize: 12,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w200,
                                    ))
                                : Text('Show Search Filters',
                                    style: TextStyle(
                                      color: Color(0xFFF9F8F1),
                                      fontSize: 12,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w200,
                                    )),
                          ),
                        ),
                        SearchFilter(),
                      ],
                    ),
                    ProjList(favorited, currentUser),
                  ])),
            )));
  }
}

List<int> allProjs = [1, 3, 7, 8];
List favorites = [1, 3];
List<dynamic> favoriteList = <dynamic>[];

getFavoriteList(User? currentUser) async {
  if (currentUser != null) {
    var thing = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get();
    // print(thing.data()!['favoriteProjs']);
    favoriteList = thing.data()!['favoriteProjs'];
  }
}

void addRemoveFavorite(User? currentUser, int projNum) async {
  if (currentUser != null) {
    var users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (doc.exists) {
      if (doc.data()!.containsKey('favoriteProjs')) {
        //Check favoriteProjs exists add proj
        List favProjs = doc['favoriteProjs'];
        if (favProjs.contains(projNum) == true) {
          users.doc(currentUser.uid).update({
            'favoriteProjs': FieldValue.arrayRemove([projNum])
          });
          favoriteList.remove(projNum);
        } else {
          users.doc(currentUser.uid).update({
            'favoriteProjs': FieldValue.arrayUnion([projNum])
          });
          favoriteList.insert(favoriteList.length, projNum);
        }
      } else {
        //create favoriteProjs field if it doesn't exist
        users.doc(currentUser.uid).set({
          'favoriteProjs': [projNum]
        }, SetOptions(merge: true));
        favoriteList.insert(favoriteList.length, projNum);
      }
    }
    // print(favList);
  }
}

Future<Map<String, dynamic>> getProjectData(int projNum) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('projects')
      .where('projectnumber', isEqualTo: projNum)
      .get();
  return snapshot.docs[0].data();
}

class ProjText extends StatelessWidget {
  final int projNum;
  final bool isTitle;
  final double fontSize;
  final FontWeight fontWeight;

  const ProjText(
      {required this.projNum,
      required this.isTitle,
      required this.fontSize,
      required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getProjectData(projNum),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasError) return CircularProgressIndicator();
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "  ",
            style: TextStyle(
                color: Color(0xFFF9F8F1),
                fontSize: fontSize,
                fontFamily: 'Roboto',
                fontWeight: fontWeight),
            textAlign: TextAlign.left,
          );
        }
        String displayText = snapshot.data!['title'];
        if (!isTitle) {
          displayText = snapshot.data!['brief'];
        }
        return Text(
          displayText,
          style: TextStyle(
              color: Color(0xFFF9F8F1),
              fontSize: fontSize,
              fontFamily: 'Roboto',
              fontWeight: fontWeight),
          textAlign: TextAlign.left,
        );
      },
    );
  }
}

enum SearchFilterProperties {
  favorites,
  conservation,
  lessThanXFunded,
  greaterThanXFunded
}

class SearchFilter extends StatefulWidget {
  const SearchFilter({Key? key}) : super(key: key);

  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  SearchFilterProperties? _selectedFilter = SearchFilterProperties.conservation;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showFilters,
      child: Container(
        //margin: EdgeInsets.all(15.0),
        height: 270,
        width: 470,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(218, 249, 248, 241),
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    'Search Filters',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                RadioListTile<SearchFilterProperties>(
                  title: const Text('Favorites'),
                  value: SearchFilterProperties.favorites,
                  groupValue: _selectedFilter,
                  onChanged: (SearchFilterProperties? value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                  toggleable: true,
                ),
                RadioListTile<SearchFilterProperties>(
                  title: const Text('Conservation Projects'),
                  value: SearchFilterProperties.conservation,
                  groupValue: _selectedFilter,
                  onChanged: (SearchFilterProperties? value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                  toggleable: true,
                ),
                RadioListTile<SearchFilterProperties>(
                  title: const Text('<x% Funded'),
                  value: SearchFilterProperties.lessThanXFunded,
                  groupValue: _selectedFilter,
                  onChanged: (SearchFilterProperties? value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                  toggleable: true,
                ),
                RadioListTile<SearchFilterProperties>(
                  title: const Text('>x% Funded'),
                  value: SearchFilterProperties.greaterThanXFunded,
                  groupValue: _selectedFilter,
                  onChanged: (SearchFilterProperties? value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                  toggleable: true,
                ),
                TextButton(
                    onPressed: () {
                      // update project listings when pressed
                      if (_selectedFilter == SearchFilterProperties.favorites) {
                        setState(() {
                          favorited = !favorited;
                        });
                      }
                      setState(() {
                        showFilters = !showFilters;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProjectSearch()));
                    },
                    child: const Text('Update',
                        style: TextStyle(
                          color: Color(0xFFB9C24D),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ))),
              ],
            )),
      ),
    );
  }
}

class ProjList extends StatefulWidget {
  final bool showFavorites;
  final User? currentUser;
  ProjList(this.showFavorites, this.currentUser);
  @override
  _ProjListState createState() => _ProjListState(showFavorites, currentUser);
}

class _ProjListState extends State<ProjList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  bool showFavorites;
  User? currentUser;

  _ProjListState(this.showFavorites, this.currentUser);
  @override
  Widget build(BuildContext context) {
    if (showFavorites) {
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: favoriteList.length,
          itemBuilder: (BuildContext context, int index) {
            return ProjContainer(allProjs[index], true, currentUser);
          });
    } else {
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: allProjs.length,
          itemBuilder: (BuildContext context, int index) {
            return ProjContainer(allProjs[index],
                (favoriteList.contains(allProjs[index])), currentUser);
          });
    }
  }
}

class ProjContainer extends StatefulWidget {
  final int projNum;
  final bool favorite;
  final User? currentUser;
  ProjContainer(this.projNum, this.favorite, this.currentUser);

  @override
  _ProjContainerState createState() =>
      _ProjContainerState(projNum, favorite, currentUser);
}

class _ProjContainerState extends State<ProjContainer> {
  int projNum;
  bool favorite;
  User? currentUser;

  _ProjContainerState(this.projNum, this.favorite, this.currentUser);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    List<Widget> showHeartIcon() {
      List<Widget> widgetList = [];

      widgetList.add(
        Expanded(
          child: ProjText(
            projNum: projNum,
            isTitle: true,
            fontSize: 42,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

      if (auth.currentUser != null) {
        getFavoriteList(currentUser);
        widgetList.add(
            // Favorite button (still need to fill with right color)
            Ink(
          decoration: const ShapeDecoration(
              color: Color(0xFFB9C24D), // not showing up ???
              shape: CircleBorder()),
          child: IconButton(
            onPressed: () async {
              setState(() {
                favorite = !favorite;
              });
              addRemoveFavorite(currentUser, projNum);
            },
            icon: Icon(
              (favorite == false)
                  ? Icons.favorite_border_rounded
                  : Icons.favorite_rounded,
            ),
            iconSize: 30,
            color: Colors.white,
            splashColor: Colors.grey,
          ),
        ));
      }

      return widgetList;
    }

    return Container(
        margin: EdgeInsets.all(20.0),
        height: 215.0,
        width: 270.0,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: Color(0xFF0E346D),
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: showHeartIcon(),
                      ),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                              child: ProjText(
                                projNum: projNum,
                                isTitle: false,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ))),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProjectPage(projNum: projNum)));
                          }, // should go to individual project page when pressed
                          child: const Text(
                            'LEARN MORE ->',
                            style: TextStyle(
                              color: Color(0xFFB9C24D),
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.left,
                          )),
                    ]))));
  }
}
