import 'package:flutter/material.dart';
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
      appBar:AppBar(
        title:Text("VNR Placements")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
