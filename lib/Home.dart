import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vnrplacements/HomeOpenFile.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import 'package:vnrplacements/getDownloadURLFromFirebase.dart';
import 'package:vnrplacements/openInBrowser.dart';
import 'FirebaseSignInAnonymous.dart';
import 'Firebase/selectFilter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StorageReference ref = FirebaseStorage.instance.ref();
  @override
  void initState() {
    super.initState();
    firebaseSignIn();
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
          onPressed: () async {
              firebaseurl("questions/aarvee_questions.pdf").then((onValue){
                print(onValue);
              });
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
        ),
        Padding(padding: EdgeInsets.all(10)),
        RaisedButton(
          color: Colors.blue,
          child: Text("Firebase", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return Filter();
                },
              ),
            );
          },
        )
      ])),
    ));
  }
}
