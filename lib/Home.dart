import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:vnrplacements/Firebase/selectFilter.dart';
import 'package:vnrplacements/faq.dart';
import 'package:vnrplacements/team.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [Filter(), FAQ(), Team()];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _currentIndex == 0
          ? AppBar(
              title: Text("Home"),
              leading: Icon(Icons.home),
            )
          : _currentIndex == 1
              ? AppBar(
                  title: Text("FAQ"),
                  leading: Icon(Icons.question_answer),
                )
              : AppBar(
                  title: Text("Team"),
                  leading: Icon(Icons.group),
                ),
      body: _children[_currentIndex],
      bottomNavigationBar: FancyBottomNavigation(
        onTabChangedListener: (position) {
          setState(() {
            this._currentIndex = position;
          });
        },
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.question_answer, title: "FAQ"),
          TabData(iconData: Icons.group, title: "Team")
        ],
        inactiveIconColor: Colors.blueGrey,
        textColor: Colors.blueGrey,
      ),
    );
  }
}
