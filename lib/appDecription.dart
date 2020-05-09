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
                child: Marquee(
                  text:
                      'Vallurupalli Nageswara Rao Vignana Jyothi Institute of Engineering and Technology (VNRVJIET) is an engineering college in Hyderabad, India recognized by All India Council for Technical Education(AICTE) and affiliated to the Jawaharlal Nehru Technological University, Hyderabad. It is often referred to as VNR College or Vignana Jyothi Engineering College or VNRVJIET.According to 2019 NIRF Rankings, VNR VJIET ranked 109 in Engineering Category. By which it states that its the top 2nd private college in Telangana State.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                )),
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
