import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import './Storagedirectory.dart';


grantStoragePermissionAndCreateDir(BuildContext context ){
    Permission.storage.request().then((onValue) {
      if (onValue == PermissionStatus.permanentlyDenied)
        Toast.show("Enable Storage Permission in Settings!", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      else if (onValue == PermissionStatus.denied)
        grantStoragePermissionAndCreateDir(context);
      else if (onValue == PermissionStatus.granted) createandgetDirectory(context);
    });
  }
