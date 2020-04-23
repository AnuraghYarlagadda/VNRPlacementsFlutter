import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vnrplacements/Firebase/displayFilteredCompanies.dart';
import 'package:vnrplacements/FirebaseSignInAnonymous.dart';
import 'package:vnrplacements/Settings.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import 'package:vnrplacements/Storagedirectory.dart';
import 'package:vnrplacements/download.dart';
import 'package:vnrplacements/getDownloadURLFromFirebase.dart';
import 'package:vnrplacements/openFileFromLocalStorage.dart';
import 'package:vnrplacements/pdfViewer.dart';

class Filter extends StatefulWidget {
  @override
  FilterState createState() => FilterState();
}

enum Status { start, running, completed }

class FilterState extends State<Filter> {
  String filter = 'Click on Dropdown to select a category';

  List<String> spinnerItems = [
    "Click on Dropdown to select a category",
    "Core",
    "Software and Service",
    "Software and Product"
  ];
  String _dir;
  int statusOfAlumniDetails, statusOfListOfCompanies, statusOfSampleResume;
  String urlOfAlumniDetails, urlOfListOfCompanies, urlOfSampleResume;
  String filenameOfAlumniDetails,
      filenameOfListOfCompanies,
      filenameOfSampleResume;
  Future<void> _launched;
  String _toLaunch;

  @override
  void initState() {
    super.initState();
    firebaseSignIn();
    grantStoragePermissionAndCreateDir(context);
    this.statusOfAlumniDetails = Status.start.index;
    this.statusOfListOfCompanies = Status.start.index;
    this.statusOfSampleResume = Status.start.index;
    this.filenameOfAlumniDetails = "AlumniDetails.xlsx";
    this.filenameOfListOfCompanies = "listofcompanies.xlsx";
    this.filenameOfSampleResume = "sampleresume.pdf";
    this._toLaunch = "http://docs.google.com/gview?embedded=true&url=";
    //this._toLaunch="http://docs.google.com/viewer?url=";
    //this._toLaunch="https://docs.google.com/a/nasoline/viewer?url=";
  }

  Future<void> intiatedownload(String whatToDownload) async {
    await createandgetDirectory(this.context).then((onValue) {
      setState(() {
        if (onValue != null) this._dir = onValue.path;
      });
    });
    if (whatToDownload == "Alumni Details") {
      await firebaseurl("AlumniDetails.xlsx").then((onValue) {
        setState(() {
          this.urlOfAlumniDetails = onValue;
        });
      });
    } else if (whatToDownload == "List Of Companies") {
      await firebaseurl("listofcompanies.xlsx").then((onValue) {
        setState(() {
          this.urlOfListOfCompanies = onValue;
        });
      });
    } else {
      await firebaseurl("sampleresume.pdf").then((onValue) {
        setState(() {
          this.urlOfSampleResume = onValue;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
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
                                Text(
                                  'Offline',
                                  style: TextStyle(color: Colors.white),
                                ),
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                card("Alumni Details"),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                card("List Of Companies"),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                card("Requirements and Sample Resume"),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                spinner(),
              ],
            ),
          ),
        ));
  }

  Widget spinner() {
    return (Center(
        child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(children: <Widget>[
                  DropdownButton<String>(
                    value: filter,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 30,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String data) {
                      setState(() {
                        filter = data;
                        if (filter !=
                            "Click on Dropdown to select a category") {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DisplayFilteredCompanies(filter);
                          }));
                        }
                      });
                    },
                    items: spinnerItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  )
                ])))));
  }

  Widget card(String fileName) {
    return Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Card(
                color: Colors.white,
                borderOnForeground: true,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        topRight: Radius.circular(50)),
                    side: BorderSide(width: 2, color: Colors.blue)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        fileName,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        whatToLoadwhileDownloading(fileName),
                        openFileOrLaunchFile(fileName),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget whatToLoadwhileDownloading(String whatToDownload) {
    if (whatToDownload == "Alumni Details") {
      if (this.statusOfAlumniDetails == Status.start.index) {
        return (RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25)),
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
                  this.statusOfAlumniDetails = Status.running.index;
                });
                intiatedownload("Alumni Details").then((onValue) {
                  downloaddio(this._dir, this.urlOfAlumniDetails,
                          this.filenameOfAlumniDetails)
                      .then((onValue) {
                    setState(() {
                      this.statusOfAlumniDetails = Status.completed.index;
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
      } else if (this.statusOfAlumniDetails == Status.running.index) {
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
    } else if (whatToDownload == "List Of Companies") {
      if (this.statusOfListOfCompanies == Status.start.index) {
        return (RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25)),
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
                  this.statusOfListOfCompanies = Status.running.index;
                });
                intiatedownload("List Of Companies").then((onValue) {
                  downloaddio(this._dir, this.urlOfListOfCompanies,
                          this.filenameOfListOfCompanies)
                      .then((onValue) {
                    setState(() {
                      this.statusOfListOfCompanies = Status.completed.index;
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
      } else if (this.statusOfListOfCompanies == Status.running.index) {
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
    } else {
      if (this.statusOfSampleResume == Status.start.index) {
        return (RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25)),
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
                  this.statusOfSampleResume = Status.running.index;
                });
                intiatedownload("").then((onValue) {
                  downloaddio(this._dir, this.urlOfSampleResume,
                          this.filenameOfSampleResume)
                      .then((onValue) {
                    setState(() {
                      this.statusOfSampleResume = Status.completed.index;
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
      } else if (this.statusOfSampleResume == Status.running.index) {
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

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        enableDomStorage: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      ).then((onValue) {});
    } else {
      throw 'Could not launch $url';
    }
  }

  intiateLaunchUrl() async {
    await firebaseurl("sampleresume.pdf").then((onValue) {
      setState(() {
        this._toLaunch += Uri.encodeFull(onValue);
        _launched = _launchInBrowser(this._toLaunch);
      });
    });
  }

  Widget openFileOrLaunchFile(String whatToOpenOrLaunch) {
    if (whatToOpenOrLaunch == "Alumni Details") {
      final filePath =
          "/storage/emulated/0" + "/Placements" + "/AlumniDetails.xlsx";
      final fileFormat = "xlsx";
      return (Center(
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25)),
            color: Colors.blue,
            child: Text("Open File"),
            onPressed: () async {
              await openFile(context, filePath, fileFormat);
            }),
      ));
    } else if (whatToOpenOrLaunch == "List Of Companies") {
      final filePath =
          "/storage/emulated/0" + "/Placements" + "/listofcompanies.xlsx";
      final fileFormat = "xlsx";
      return (Center(
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25)),
            color: Colors.blue,
            child: Text("Open File"),
            onPressed: () async {
              await openFile(context, filePath, fileFormat);
            }),
      ));
    } else {
      return (RaisedButton( 
        color: Colors.blue,
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
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
              //intiateLaunchUrl();
              pushtoPdfViewer();
            }
          });
        },
        child: const Text('Launch in browser',
            style: TextStyle(color: Colors.white)),
      ));
    }
  }

  pushtoPdfViewer() async {
    await firebaseurl("sampleresume.pdf").then((onValue) {
      print(onValue);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return PdfViewer(onValue);
          },
        ),
      );
    });
  }
}
