import 'package:flutter/material.dart';
import 'package:vnrplacements/HomeDownload.dart';
import 'package:vnrplacements/HomeOpenFile.dart';
import 'package:vnrplacements/openInBrowser.dart';

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
