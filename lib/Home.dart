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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            title: Text(
              'FAQ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.group),
              title: Text(
                'Team',
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
