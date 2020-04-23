import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vnrplacements/DataModels/CompanyDetails.dart';
import 'package:vnrplacements/FirebaseSignInAnonymous.dart';
import 'package:vnrplacements/Settings.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import 'package:vnrplacements/Storagedirectory.dart';
import 'package:vnrplacements/download.dart';
import 'package:vnrplacements/getDownloadURLFromFirebase.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DisplayCompanyDetails extends StatefulWidget {
  final String companyName;
  const DisplayCompanyDetails(this.companyName);
  @override
  State<StatefulWidget> createState() {
    return DisplayCompanyDetailsState();
  }
}

enum Status { start, running, completed }

class DisplayCompanyDetailsState extends State<DisplayCompanyDetails> {
  final fb = FirebaseDatabase.instance;
  CompanyDetails companyDetails;
  String _dir, _url, _filename;
  int _status;
  Future<void> _launched;
  String _toLaunch;
  @override
  void initState() {
    super.initState();
    firebaseSignIn();
    this._toLaunch = "http://docs.google.com/gview?url=";
    grantStoragePermissionAndCreateDir(context);
    this._status = Status.start.index;
    fetchDetails();
  }

  fetchDetails() {
    final ref = fb.reference();
    ref
        .child("Company")
        .child(widget.companyName)
        .once()
        .then((DataSnapshot data) {
      setState(() {
        companyDetails = CompanyDetails.fromSnapshot(data);
      });
    });
  }

  Future<void> intiatedownload() async {
    await firebaseurl(
            "details/" + widget.companyName.toString() + "_details.pdf")
        .then((onValue) {
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
      this._filename = widget.companyName.toString() +
          "/" +
          widget.companyName.toString() +
          "_details.pdf";
    });
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  intiateLaunchUrl() async {
    await firebaseurl("details/"+widget.companyName.toString()+"_details.pdf").then((onValue) {
      setState(() {
        this._toLaunch += Uri.encodeFull(onValue) + "&embedded=true";
        _launched = _launchInBrowser(this._toLaunch);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.companyName.toString().toUpperCase())),
      body: companyDetails == null
          ? CircularProgressIndicator()
          : Column(children: <Widget>[
              Text(companyDetails.companyName),
              Padding(padding: EdgeInsets.all(8)),
              Text("Eligibility Criteria"),
              Text(companyDetails.ec.values.toString()),
              Padding(padding: EdgeInsets.all(8)),
              Text("Job Description"),
              Text(companyDetails.jd.values.toString()),
              Padding(padding: EdgeInsets.all(8)),
              whatToLoad(),
              RaisedButton(
                color: Colors.cyan,
                padding: EdgeInsets.all(8),
                onPressed: () async {
                  await (Connectivity().checkConnectivity()).then((onValue) {
                    if (onValue == ConnectivityResult.none) {
                      Fluttertoast.showToast(
                          msg: "No Active Internet Connection!",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                      openWIFISettingsVNR();
                    } else {
                      intiateLaunchUrl();
                    }
                  });
                },
                child: const Text('Launch in browser',
                    style: TextStyle(color: Colors.white)),
              ),
            ]),
    );
  }

  Widget whatToLoad() {
    if (this._status == Status.start.index) {
      return (RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
        onPressed: () async {
          await (Connectivity().checkConnectivity()).then((onValue) {
            if (onValue == ConnectivityResult.none) {
              Fluttertoast.showToast(
                  msg: "No Active Internet Connection!",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.red,
                  textColor: Colors.white);
              openWIFISettingsVNR();
            } else {
              setState(() {
                this._status = Status.running.index;
              });
              intiatedownload().then((onValue) {
                downloaddio(this._dir, this._url, this._filename)
                    .then((onValue) {
                  setState(() {
                    this._status = Status.completed.index;
                  });
                  Fluttertoast.showToast(
                      msg: "Download Completed!",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.green,
                      textColor: Colors.white);
                });
              });
            }
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
          Fluttertoast.showToast(
              msg: "Already Downloaded!",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.blue,
              textColor: Colors.white);
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
}
