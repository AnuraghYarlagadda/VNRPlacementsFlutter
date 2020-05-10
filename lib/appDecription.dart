import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
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
    grantStoragePermissionAndCreateDir(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VNR Placements")),
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
                    child: Marquee(
                  text:
                      'VNR Placements is the one stop destination to know about everything related to placements in the college.\nThis app is to keep you informed right from interview details to sample interview questions that are specific for each company. \nAlso you can view the list of companies that have been hiring the students since past few years and focus on companies that interest you. \nGet started and be updated!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                    // color: Colors.pink,
                  ),
                  scrollAxis: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  blankSpace: 25.0,
                  velocity: 15.0,
                  pauseAfterRound: Duration(milliseconds: 850),
                  startPadding: 10.0,
                  accelerationDuration: Duration(seconds: 1),
                  accelerationCurve: Curves.linearToEaseOut,
                  decelerationDuration: Duration(milliseconds: 1000),
                  decelerationCurve: Curves.decelerate,
                ))),
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
    );
  }
}
