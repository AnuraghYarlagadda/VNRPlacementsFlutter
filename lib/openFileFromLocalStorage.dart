import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:toast/toast.dart';

Future<void> openFile(BuildContext context,String filePath) async {
 
  final result = await OpenFile.open(filePath);
  if (result.type == ResultType.fileNotFound) {
    Toast.show("File not found!", context);
  }
  if (result.type == ResultType.noAppToOpen) {
    Toast.show("No app Found to open this file", context);
  }
  print(result.message);
  print(result.type);
}
