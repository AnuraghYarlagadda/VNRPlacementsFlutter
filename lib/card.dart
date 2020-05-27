import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vnrplacements/Settings.dart';
import 'package:vnrplacements/Storagedirectory.dart';
import 'package:vnrplacements/download.dart';
import 'package:vnrplacements/getDownloadURLFromFirebase.dart';
import 'package:vnrplacements/openFileFromLocalStorage.dart';

class card extends StatefulWidget {
  final String fileName, companyName;
  final Color color;
  const card(this.fileName, this.companyName, this.color);
  @override
  cardState createState() => cardState();
}

enum Status { start, running, completed }

class cardState extends State<card> {
  Color cardBorderColor;
  String _dir;
  int statusOfAlumniDetails, statusOfListOfCompanies, statusOfSampleResume;
  String urlOfAlumniDetails, urlOfListOfCompanies, urlOfSampleResume;
  String filenameOfAlumniDetails,
      filenameOfListOfCompanies,
      filenameOfSampleResume;
  Future<void> _launched;

  @override
  void initState() {
    super.initState();
    this.statusOfAlumniDetails = Status.start.index;
    this.statusOfListOfCompanies = Status.start.index;
    this.statusOfSampleResume = Status.start.index;
    this.filenameOfAlumniDetails = "AlumniDetails.xlsx";
    this.filenameOfListOfCompanies = "listofcompanies.xlsx";
    this.filenameOfSampleResume = "sampleresume.pdf";
    this.cardBorderColor = widget.color;
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
          //print(onValue);
          this.urlOfAlumniDetails = onValue;
        });
      });
    } else if (whatToDownload == "List Of Companies") {
      await firebaseurl("listofcompanies.xlsx").then((onValue) {
        setState(() {
          //print(onValue);
          this.urlOfListOfCompanies = onValue;
        });
      });
    } else if (whatToDownload == "Requirements and Sample Resume") {
      await firebaseurl("sampleresume.pdf").then((onValue) {
        setState(() {
          //print(onValue);
          this.urlOfSampleResume = onValue;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Card(
      color: Colors.white,
      borderOnForeground: true,
      elevation: 15,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25), topRight: Radius.circular(50)),
          side: BorderSide(width: 2, color: this.cardBorderColor)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              widget.fileName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
          ),
          ButtonBar(
            //alignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              whatToLoadwhileDownloading(widget.fileName),
              openFiles(widget.fileName),
              launchFile(widget.fileName),
            ],
          ),
        ],
      ),
    ));
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

  Widget whatToLoadwhileDownloading(String whatToDownload) {
    if (whatToDownload == "Alumni Details") {
      if (this.statusOfAlumniDetails == Status.start.index) {
        return (RaisedButton(
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
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25)),
          child: Text("Download"),
          textColor: Colors.white,
          color: Colors.blue,
          padding: EdgeInsets.all(8),
        ));
      } else if (this.statusOfAlumniDetails == Status.running.index) {
        return CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink),
        );
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
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25)),
          child: Text("Download"),
          textColor: Colors.white,
          color: Colors.blue,
          padding: EdgeInsets.all(8),
        ));
      } else if (this.statusOfListOfCompanies == Status.running.index) {
        return CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink),
        );
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
    } else if (whatToDownload == "Requirements and Sample Resume") {
      if (this.statusOfSampleResume == Status.start.index) {
        return (RaisedButton(
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
                intiatedownload("Requirements and Sample Resume")
                    .then((onValue) {
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
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(25)),
          child: Text("Download"),
          textColor: Colors.white,
          color: Colors.blue,
          padding: EdgeInsets.all(8),
        ));
      } else if (this.statusOfSampleResume == Status.running.index) {
        return CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink),
        );
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

  Widget openFiles(String toOpen) {
    if (toOpen == "Alumni Details") {
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
    } else if (toOpen == "List Of Companies") {
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
      final filePath =
          "/storage/emulated/0" + "/Placements" + "/sampleresume.pdf";
      final fileFormat = "pdf";
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
    }
  }

  Widget launchFile(String toLaunch) {
    if (toLaunch == "Alumni Details") {
      return Padding(
        padding: EdgeInsets.all(0),
      );
    } else if (toLaunch == "List Of Companies") {
      return Padding(
        padding: EdgeInsets.all(0),
      );
    } else {
      return (RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        padding: EdgeInsets.all(8),
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
        child: Text("WebView"),
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
              if (toLaunch == "Requirements and Sample Resume") {
                initiateLaunchUrl("sampleresume.pdf");
              }
            }
          });
        },
      ));
    }
  }

  initiateLaunchUrl(String whatToLaunch) async {
    String url = "http://docs.google.com/gview?embedded=true&url=";
    await firebaseurl(whatToLaunch).then((onValue) {
      url += Uri.encodeFull(onValue);
      setState(() {
        _launched = _launchInBrowser(url);
      });
    });
  }
}
