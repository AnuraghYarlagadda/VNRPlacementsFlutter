import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vnrplacements/Settings.dart';
import 'package:vnrplacements/Storagedirectory.dart';
import 'package:vnrplacements/download.dart';
import 'package:vnrplacements/getDownloadURLFromFirebase.dart';
import 'package:vnrplacements/openFileFromLocalStorage.dart';
import 'package:vnrplacements/pdfViewer.dart';

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
  //String _toLaunch;

  //Variables for Interview Details and Questions
  int statusOfInterviewDetails, statusOfInterviewQuestions;
  String urlOfInterviewDetails, urlOfInterviewQuestions;
  String filenameOfInterviewDetails, filenameOfInterviewQuestions;

  @override
  void initState() {
    super.initState();
    //firebaseSignIn();
    // grantStoragePermissionAndCreateDir(context);
    this.statusOfAlumniDetails = Status.start.index;
    this.statusOfListOfCompanies = Status.start.index;
    this.statusOfSampleResume = Status.start.index;
    this.filenameOfAlumniDetails = "AlumniDetails.xlsx";
    this.filenameOfListOfCompanies = "listofcompanies.xlsx";
    this.filenameOfSampleResume = "sampleresume.pdf";
    this.cardBorderColor = widget.color;

    //For Interview Details and Questions
    this.statusOfInterviewDetails = Status.start.index;
    this.statusOfInterviewQuestions = Status.start.index;
    this.filenameOfInterviewDetails =
        widget.companyName + "/" + widget.companyName + "_details.pdf";
    this.filenameOfInterviewQuestions =
        widget.companyName + "/" + widget.companyName + "_questions.pdf";
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
    } else if (whatToDownload == "Interview Details") {
      await firebaseurl("details" + "/" + widget.companyName + "_details.pdf")
          .then((onValue) {
        setState(() {
          print(onValue);
          this.urlOfInterviewDetails = onValue;
        });
      });
    } else if (whatToDownload == "Interview Questions") {
      await firebaseurl(
              "questions" + "/" + widget.companyName + "_questions.pdf")
          .then((onValue) {
        setState(() {
          print(onValue);
          this.urlOfInterviewQuestions = onValue;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Card(
      color: Colors.white,
      borderOnForeground: true,
      elevation: 25,
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
            children: <Widget>[
              whatToLoadwhileDownloading(widget.fileName),
              openFileOrLaunchFile(widget.fileName),
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
    } else if (whatToDownload == "Requirements and Sample Resume") {
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
    } else if (whatToDownload == "Interview Details") {
      if (this.statusOfInterviewDetails == Status.start.index) {
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
                  this.statusOfInterviewDetails = Status.running.index;
                });
                intiatedownload("Interview Details").then((onValue) {
                  downloaddio(this._dir, this.urlOfInterviewDetails,
                          this.filenameOfInterviewDetails)
                      .then((onValue) {
                    setState(() {
                      this.statusOfInterviewDetails = Status.completed.index;
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
      } else if (this.statusOfInterviewDetails == Status.running.index) {
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
    } else if (whatToDownload == "Interview Questions") {
      if (this.statusOfInterviewQuestions == Status.start.index) {
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
                  this.statusOfInterviewQuestions = Status.running.index;
                });
                intiatedownload("Interview Questions").then((onValue) {
                  downloaddio(this._dir, this.urlOfInterviewQuestions,
                          this.filenameOfInterviewQuestions)
                      .then((onValue) {
                    setState(() {
                      this.statusOfInterviewQuestions = Status.completed.index;
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
      } else if (this.statusOfInterviewQuestions == Status.running.index) {
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
              if (whatToOpenOrLaunch == "Requirements and Sample Resume") {
                initiateLaunchUrl("sampleresume.pdf");
              } else if (whatToOpenOrLaunch == "Interview Details") {
                initiateLaunchUrl(
                    "details" + "/" + widget.companyName + "_details.pdf");
              } else if (whatToOpenOrLaunch == "Interview Questions") {
                initiateLaunchUrl(
                    "questions" + "/" + widget.companyName + "_questions.pdf");
              }
            }
          });
        },
        child: const Text('Launch in browser',
            style: TextStyle(color: Colors.white)),
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

  pushtoPdfViewer(String whatToLaunch) async {
    await firebaseurl(whatToLaunch).then((onValue) {
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
