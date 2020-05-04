import 'package:flutter/material.dart';
import 'package:vnrplacements/Home.dart';

class FAQ extends StatefulWidget {
  @override
  FAQState createState() => FAQState();
}

class FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text("FAQ's")],
        ),
      ),
    );
  }
}
