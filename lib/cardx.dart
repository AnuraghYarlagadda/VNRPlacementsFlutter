import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vnrplacements/Settings.dart';
import 'package:vnrplacements/Storagedirectory.dart';
import 'package:vnrplacements/download.dart';
import 'package:vnrplacements/getDownloadURLFromFirebase.dart';
import 'package:vnrplacements/openFileFromLocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class cardx extends StatefulWidget {
  final String fileName, companyName;
  final Gradient color;
  const cardx(this.fileName, this.companyName, this.color);
  @override
  cardxState createState() => cardxState();
}

enum Status { start, running, completed }

class cardxState extends State<cardx> {
  Color cardBorderColor;
  String _dir;
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
    if (whatToDownload == "Interview Details") {
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
    return (GradientCard(
      gradient: widget.color,
      shadowColor: Gradients.tameer.colors.last.withOpacity(0.5),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25)),
        //side: BorderSide(width: 2, color: Colors.black)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              widget.fileName,
              style: TextStyle(
                color: Colors.white,
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
    if (whatToDownload == "Interview Details") {
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
          color: Colors.white,
          textColor: Colors.blue,
          padding: EdgeInsets.all(8),
          child: Text('Download'),
        ));
      } else if (this.statusOfInterviewDetails == Status.running.index) {
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
          color: Colors.white,
          textColor: Colors.blue,
          padding: EdgeInsets.all(8),
          child: Text('Download'),
        ));
      } else if (this.statusOfInterviewQuestions == Status.running.index) {
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

  Widget openFileOrLaunchFile(String whatToOpenOrLaunch) {
    return (RaisedButton(
      color: Colors.white,
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
          style: TextStyle(color: Colors.blue)),
    ));
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