import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'Settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

firebaseSignIn() async {
  await (Connectivity().checkConnectivity()).then((onValue) {
    if (onValue == ConnectivityResult.none) {
      Fluttertoast.showToast(
          msg: "No Active Internet Connection!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      openWIFISettingsVNR();
    } else {
      FirebaseAuth.instance.signInAnonymously();
    }
  });
}
