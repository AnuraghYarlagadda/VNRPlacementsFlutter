import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vnrplacements/Storagedirectory.dart';
import 'getDownloadURLFromFirebase.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import './download.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum Status { start, running, completed }

class _HomeState extends State<Home> {
  String _dir, _url, _filename;
  int _status;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signInAnonymously();
    grantStoragePermissionAndCreateDir(this.context);
    this._status = Status.start.index;
  }

  Future<void> intiatedownload() async {
    await firebaseurl("AlumniDetails.xlsx").then((onValue) {
      setState(() {
        this._url = onValue;
      });
    });
    await createandgetDirectory(this.context).then((onValue) {
      setState(() {
        this._dir = onValue.path;
      });
    });
    setState(() {
      this._filename = "AlumniDetails.xlsx";
    });
  }

  Widget whatToLoad() {
    if (this._status == Status.start.index) {
      return (RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
        onPressed: () {
          setState(() {
            this._status = Status.running.index;
          });
          intiatedownload().then((onValue) {
            downloaddio(this._dir, this._url, this._filename).then((onValue) {
              setState(() {
                this._status = Status.completed.index;
              });
              Toast.show("Download Complete!", context);
            });
          });
        },
        color: Colors.blue,
        textColor: Colors.white,
        padding: EdgeInsets.all(8),
        child: Text('Download'),
      ));
    } else if (this._status == Status.running.index) {
      return CircularProgressIndicator();
    } else {
      return (MaterialButton(
        onPressed: () {
          Toast.show("Already Downloaded", context);
        },
        color: Colors.green,
        textColor: Colors.white,
        child: Icon(
          Icons.check,
          size: 24,
        ),
        padding: EdgeInsets.all(8),
        shape: CircleBorder(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return (new Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Stack(
              fit: StackFit.expand,
              children: [
                child,
                Positioned(
                  height: 20.0,
                  left: 0.0,
                  right: 0.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    color: connected ? Colors.green : Colors.red,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: connected
                          ? Text(
                              'Online',
                              style: TextStyle(color: Colors.white),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Offline',style: TextStyle(color:Colors.white),),
                                SizedBox(width: 8.0),
                                SizedBox(
                                  width: 12.0,
                                  height: 12.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[whatToLoad()],
          ),
        )));
  }
}
