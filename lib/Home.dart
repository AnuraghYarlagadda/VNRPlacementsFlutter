import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vnrplacements/Storagedirectory.dart';
import 'getDownloadURLFromFirebase.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import './download.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _dir, _url, _filename;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signInAnonymously();
    grantStoragePermissionAndCreateDir(this.context);
  }

  Future<void> intiatedownload() async {
    await firebaseurl("AlumniDetails.xlsx").then((onValue) {
      setState(() {
        this._url = onValue;
      });
    });
    await createandgetDirectory(this.context).then((onValue) {
      setState(() {
        this._dir=onValue.path;
      });
    });
    setState(() {
      this._filename="AlumniDetails.xlsx";
    });
  }

  @override
  Widget build(BuildContext context) {
    return (new Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                   intiatedownload().then((onValue){
                     downloaddio(this._dir, this._url, this._filename);
                   });
                },
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Text('Download'),
              ),
            ],
          ),
        )));
  }
}
