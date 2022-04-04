//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import './home.dart';
import './nav_bar.dart';

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

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireDb = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String? uid = auth.currentUser?.uid;
    User? currentUser = auth.currentUser;
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
                      color: Colors.lime[50], //page background color
                    ),
                    child: ListView(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            height: 350.0,
                            width: 400.0,
                            color: Colors.transparent,
                            child: Container(
                                margin:
                                    EdgeInsets.only(left: 100.0, right: 100.0),
                                decoration: BoxDecoration(
                                    color: Colors.teal[900], //box 2 color
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Center(
                                    child: ListView(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 15.0, left: 15.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Your Impact",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Roboto')),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white,
                                    ),

                                    ////////Insert code here for graphs
                                    DynamicBarChart(),
                                  ],
                                )))),
                        Container(
                            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            height: 350.0,
                            width: 400.0,
                            color: Colors.transparent,
                            child: Container(
                                margin:
                                    EdgeInsets.only(left: 100.0, right: 100.0),
                                decoration: BoxDecoration(
                                    color: Colors.blue[800], //box 3 color
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Center(
                                    child: ListView(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 15.0, left: 15.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Community Impact",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Roboto')),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white,
                                    ),
                                    ////////Insert code here for graphs
                                    DynamicLineChart(),
                                  ],
                                )))),
                        Container(
                            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            height: 350.0,
                            width: 400.0,
                            color: Colors.transparent,
                            child: Container(
                                margin:
                                    EdgeInsets.only(left: 100.0, right: 100.0),
                                decoration: BoxDecoration(
                                    color: Colors.lime[900], //box 4 color
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Center(
                                    child: ListView(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 15.0, left: 15.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Projects You Support",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Roboto')),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.white,
                                    ),
                                    ////////Insert code here for graphs
                                  ],
                                ))))
                      ],
                    )))));
  }
}

class DynamicBarChart extends StatefulWidget {
  const DynamicBarChart({Key? key}) : super(key: key);

  @override
  _DynamicBarChartState createState() => _DynamicBarChartState();
}

class _DynamicBarChartState extends State<DynamicBarChart> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getCommunityStats() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('settings-global')
        .doc('community_stats')
        .get();
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getCommunityStats(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) return CircularProgressIndicator();
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return Container(
            padding: EdgeInsets.only(
              left: 5.0,
              right: 5.0,
              top: 5,
              bottom: 5,
            ),
            decoration: BoxDecoration(color: Colors.teal[900]),
            child: Container(
                padding: EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                  top: 5,
                  bottom: 5,
                ),
                // alignment: Alignment.center,
                height: 290,
                width: 400,
                decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
                child: AspectRatio(
                    aspectRatio: 1,
                    child: BarChart(BarChartData(
                        borderData: FlBorderData(
                            border: const Border(
                          top: BorderSide.none,
                          right: BorderSide.none,
                          left: BorderSide(width: 1),
                          bottom: BorderSide(width: 1),
                        )),
                        groupsSpace: 10,
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(
                                fromY: 0,
                                width: 15,
                                color: Colors.amber,
                                toY: snapshot
                                    .data!['totalDrivingMilesEliminated']),
                          ]),
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(
                                fromY: 0,
                                width: 15,
                                color: Colors.amber,
                                toY: snapshot
                                    .data!['totalFlightMilesEliminated']),
                          ]),
                        ])))));
      },
    );
  }
}

class DynamicLineChart extends StatefulWidget {
  const DynamicLineChart({Key? key}) : super(key: key);

  @override
  _DynamicLineChartState createState() => _DynamicLineChartState();
}

class _DynamicLineChartState extends State<DynamicLineChart> {
  /// Months represented as doubles from when tracking started
  List<double> months = [2, 3];

  /// Number of current users
  double currUsers = 0;

  /// List of points for the line graph
  List<FlSpot> lineGraphPoints = [FlSpot(2, 0), FlSpot(3, 4)];

  /// Get the number of documents in users collection
  Future<QuerySnapshot<Map<String, dynamic>>> getNumUsers() async {
    QuerySnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance.collection('users').get();
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getNumUsers(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) return CircularProgressIndicator();
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        double currMonth = int.parse(
                DateTime.parse(DateTime.now().toString()).month.toString())
            .toDouble();

        if (currMonth != months[months.length - 1]) {
          // If it's a new month, update info
          months.add(currMonth);
          currUsers = snapshot.data!.docs.length.toDouble();
          lineGraphPoints.add(FlSpot(currMonth, currUsers));
        }

        Widget leftTitleWidgets(double value, TitleMeta meta) {
          const style = TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          );
          String text = value.toString();
          return Text(text, style: style, textAlign: TextAlign.left);
        }

        Widget bottomTitleWidgets(double value, TitleMeta meta) {
          const style = TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          );
          Widget text;
          switch (value.toInt()) {
            case 2:
              text = const Text('FEB', style: style);
              break;
            case 3:
              text = const Text('MAR', style: style);
              break;
            case 4:
              text = const Text('APR', style: style);
              break;
            default:
              text = const Text('', style: style);
              break;
          }

          return Padding(child: text, padding: const EdgeInsets.only(top: 8.0));
        }

        LineChartData mainData() {
          return LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: leftTitleWidgets,
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1)),
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 6,
            lineBarsData: [
              LineChartBarData(
                spots: lineGraphPoints,
                isCurved: true,
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
                ),
              ),
            ],
          );
        }

        return Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                  top: 5,
                  bottom: 5,
                ),
                width: 400,
                height: 290,
                decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
                child: AspectRatio(
                  aspectRatio: 2,
                  child: AspectRatio(
                    aspectRatio: 1.70,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                          color: Color(0xff232d37)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 18.0, left: 12.0, top: 24, bottom: 12),
                        child: LineChart(
                          mainData(),
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        );
      },
    );
  }
}