import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vnrplacements/HomeDownload.dart';
import 'package:vnrplacements/HomeOpenFile.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import 'package:vnrplacements/openInBrowser.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signInAnonymously();
    grantStoragePermissionAndCreateDir(context);
  }
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
          child: ListView(children: <Widget>[
        Padding(padding: EdgeInsets.all(10)),
        RaisedButton(
          color: Colors.blue,
          child: Text("Download", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return HomeDownload();
                },
              ),
            );
          },
        ),
        Padding(padding: EdgeInsets.all(10)),
        RaisedButton(
          color: Colors.blue,
          child: Text("OpenBrowser", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return OpenInBrowser();
                },
              ),
            );
          },
        ),
        Padding(padding: EdgeInsets.all(10)),
        RaisedButton(
          color: Colors.blue,
          child: Text("OpenFile", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return HomeOpenFile();
                },
              ),
            );
          },
        )
      ])),
    ));
  }
}
