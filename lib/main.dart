import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vnrplacements/appDecription.dart';
import 'package:vnrplacements/appTour.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return (MaterialApp(
      title: "vnrplacements",
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        "appDescription": (context) => AppDescription(),
        "appTour":(context)=>AppTour(),
      },
    ));
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool tour;
  SharedPreferences prefs;
  setPref() async {
    await SharedPreferences.getInstance().then((onValue) {
      setState(() {
        this.prefs = onValue;
      });
    });
    sharedpref();
  }

  sharedpref() {
    print(prefs.getBool('tour'));
    setState(() {
      this.tour = prefs.getBool('tour');
      if (this.tour == null) this.tour = true;
    });
  }

  @override
  void initState() {
    super.initState();
    this.tour = null;
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        body: this.tour == null
            ? Center(
                child: Container(
                  color: Color(0x00BCD4),
                  child: Image.asset("images/jobnobga.png"),
                ),
              )
            : this.tour ? AppTour() : AppDescription()));
  }
}
