import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vnrplacements/Home.dart';
import 'package:vnrplacements/StoragePermissions.dart';

class AppDescription extends StatefulWidget {
  @override
  AppDescriptionState createState() => AppDescriptionState();
}

class AppDescriptionState extends State<AppDescription> {
  @override
  void initState() {
    super.initState();
    addBoolToSF();
    grantStoragePermissionAndCreateDir(context);
  }

  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('tour', false);
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    Widget cancelButton = FlatButton(
      child: Text(
        "YES",
        style: TextStyle(
            color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "NO",
        style: TextStyle(
            color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Do you really want to Exit❓'),
        actions: [
          cancelButton,
          continueButton,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          appBar: AppBar(
            title: Text("VNR Placements"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("appTour");
                  })
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/vnrvjiet.png",
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 4,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[
                          Text(
                            "VNR Placements is the one stop destination to know about everything related to placements in the college.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17
                                // color: Colors.pink,
                                ),
                            textAlign: TextAlign.justify,
                          ),
                          Text(
                            "This app is to keep you informed right from interview details to sample interview questions that are specific for each company.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17
                                // color: Colors.pink,
                                ),
                            textAlign: TextAlign.justify,
                          ),
                          Text(
                            "Also you can view the list of companies that have been hiring the students since past few years and focus on companies that interest you.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17
                                // color: Colors.pink,
                                ),
                            textAlign: TextAlign.justify,
                          ),
                          Text(
                            "Get started and be updated!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.pink,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ))),
                ),
                RaisedButton(
                  elevation: 25,
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Home();
                    }));
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                  ),
                  child: Text("Get Started"),
                ),
              ],
            ),
          ),
        ));
  }
}
