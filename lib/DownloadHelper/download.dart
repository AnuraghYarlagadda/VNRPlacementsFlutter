import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:permission/permission.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class downloadHelper extends StatefulWidget{
   @override
  _downloadHelperState createState() => _downloadHelperState();
}

class _downloadHelperState extends State<downloadHelper>{
  Directory _directory;
  String _url;
  bool _statusStorage;
  static var httpClient = new HttpClient();
Future<File> _downloadFile(String dir) async {
 StorageReference ref= FirebaseStorage.instance.ref().child("details/aarvee_details.pdf");
 String url =await ref.getDownloadURL(); 
 print(url);
 String filename="aarvee_details.pdf"; 
 http.Client client = new http.Client(); 
 var req = await client.get(Uri.parse(url)); 
 var bytes = req.bodyBytes; 
 
 File file = new File('$dir/$filename'); 
 await file.writeAsBytes(bytes); 
 return file; 
}
  Future<Directory> _createDirectory() async{

    if(Directory("/storage/emulated/0"+"/Placements").exists() != null)
    {
      print("Exits!");
    }

    new Directory("/storage/emulated/0"+"/Placements").create(recursive: true)
    // The created directory is returned as a Future.
    .then((Directory directory) {
      setState(() {
        _directory=directory;
      });
  });
  }

  Future<File> _downloaddio(String dir) async{
    StorageReference ref= FirebaseStorage.instance.ref().child("questions/tcs_questions.pdf");
    String url =await ref.getDownloadURL(); 
    print(url);
    String filename="tcs/tcs_questions.pdf"; 
  Dio dio=new Dio();
  Response response=await dio.download(url, dir+"/"+filename,
  options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),  // disable gzip
  onReceiveProgress: (received, total) {
  if (total != -1) {
   print((received / total * 100).toStringAsFixed(0) + "%");
  }
});
  }

  @override
  void initState() {
    super.initState();
    requestStoragePermissions();
    _createDirectory();
  }

  requestStoragePermissions() {
    if (Platform.isAndroid) {
      Permission.storage.isGranted.then((status) {
        setState(() {
          _statusStorage = status;
        });
      });
      Permission.storage.isUndetermined.then((status) {
        Permission.storage.request();
      });
    } else if (Platform.isIOS) {
      Permission.photos.isGranted.then((status) {
        setState(() {
          _statusStorage = status;
        });
      });
      Permission.photos.isUndetermined.then((status) {
        Permission.storage.request();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (
      new Scaffold(
        appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print('Floating!');
          _createDirectory();
          _downloaddio(_directory.path);
        },
      ),
      )
    );
  }
}