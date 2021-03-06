import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:vnrplacements/Settings.dart';

Directory applicationStorageDirectory;

Future<Directory> createandgetDirectory(context) async {
  if (await Permission.storage.isPermanentlyDenied) {
    Fluttertoast.showToast(
        msg: "Enable Storage Permission in Settings!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white);
    openAppSettingsVNR();
  } else {
    if (await (Directory("/storage/emulated/0" + "/Placements").exists())) {
      print("Directory Exists!");
      applicationStorageDirectory =
          Directory("/storage/emulated/0" + "/Placements");
    } else {
      new Directory("/storage/emulated/0" + "/Placements")
          .create(recursive: true)
          // The created directory is returned as a Future.
          .then((Directory directory) {
        applicationStorageDirectory = directory;
        print("created directory" + applicationStorageDirectory.path);
      });
    }
  }
  return applicationStorageDirectory;
}
