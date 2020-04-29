import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Firebase/selectFilter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
