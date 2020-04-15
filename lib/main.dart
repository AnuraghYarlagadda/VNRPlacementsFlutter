import 'package:flutter/material.dart';
import 'package:vnrplacements/openInBrowser.dart';
import './Home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return (MaterialApp(
      title: "vnrplacements",
      home: OpenInBrowser(),
      debugShowCheckedModeBanner: false,
    ));
  }
}

