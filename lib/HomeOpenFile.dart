import 'package:flutter/material.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import 'openFileFromLocalStorage.dart';

class HomeOpenFile extends StatefulWidget {
  @override
  _HomeOpenFileState createState() => _HomeOpenFileState();
}

class _HomeOpenFileState extends State<HomeOpenFile> {
  @override
  void initState() {
    super.initState();
    grantStoragePermissionAndCreateDir(context);
  }

  @override
  Widget build(BuildContext context) {
    final filePath =
        "/storage/emulated/0" + "/Placements" + "/AlumniDetails.xlsx";
    final fileFormat="xlsx";
    return Scaffold(
      appBar: new AppBar(
        title: Text("OpenFile"),
      ),
      body: Center(
        child: RaisedButton(
            color: Colors.deepOrange,
            child: Text("Open File"),
            onPressed: () async {
              await openFile(context, filePath,fileFormat);
            }),
      ),
    );
  }
}
