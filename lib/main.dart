import 'package:flutter/material.dart';
import 'package:vnrplacements/Firebase/selectFilter.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return (MaterialApp(
      title: "vnrplacements",
      home: Filter(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
