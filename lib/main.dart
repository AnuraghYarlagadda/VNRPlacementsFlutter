import 'package:flutter/material.dart';
import './Home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return (MaterialApp(
      title: "vnrplacements",
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
