import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';

var httpClient = new HttpClient();
Future<File> downloadHttp(String dir, String url, String filename) async {
  http.Client client = new http.Client();
  var req = await client.get(Uri.parse(url));
  var bytes = req.bodyBytes;

  File file = new File('$dir/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

Future<void> downloaddio(String dir, String url, String filename) async {
  Dio dio = new Dio();
  Response response = await dio.download(url, dir + "/" + filename,
      options: Options(
          headers: {HttpHeaders.acceptEncodingHeader: "*"}), // disable gzip
      onReceiveProgress: (received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  });
}
