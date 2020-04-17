import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'getDownloadURLFromFirebase.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connectivity/connectivity.dart';
import './Settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'FirebaseSignInAnonymous.dart';

class OpenInBrowser extends StatefulWidget {
  @override
  _OpenInBrowserState createState() => _OpenInBrowserState();
}

class _OpenInBrowserState extends State<OpenInBrowser> {
  Future<void> _launched;
  String _toLaunch;

  void initState() {
    super.initState();
    firebaseSignIn();
    this._toLaunch = "http://docs.google.com/gview?url=";
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
    await firebaseurl("questions/tcs_questions.pdf").then((onValue) {
      setState(() {
        this._toLaunch += Uri.encodeFull(onValue) + "&embedded=true";
        _launched = _launchInBrowser(this._toLaunch);
      });
    });
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browser View"),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            FutureBuilder<void>(future: _launched, builder: _launchStatus),
          ],
        ),
      ),
    );
  }
}
