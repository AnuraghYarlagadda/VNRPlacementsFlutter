import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

Directory applicationStorageDirectory;

Future<Directory> createandgetDirectory(context) async {
  if(await Permission.storage.isPermanentlyDenied)
  {
    Toast.show("Enable Storage Permission in Settings!", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
  if (await (Directory("/storage/emulated/0" + "/Placements").exists())) {
    print("Directory Exists!");
    applicationStorageDirectory =
        Directory("/storage/emulated/0" + "/Placements");
  } else {
    new Directory("/storage/emulated/0" + "/Placements").create(recursive: true)
        // The created directory is returned as a Future.
        .then((Directory directory) {
      applicationStorageDirectory = directory;
      print("created directory" + applicationStorageDirectory.path);
    });
  }
  return applicationStorageDirectory;
}
