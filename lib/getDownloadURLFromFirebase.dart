import 'package:firebase_storage/firebase_storage.dart';

Future<String> firebaseurl(String child) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(child);
    return await ref.getDownloadURL();
  }