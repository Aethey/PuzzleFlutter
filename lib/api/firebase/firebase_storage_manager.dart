import 'dart:io';
import 'dart:typed_data';
import 'dart:convert' show utf8;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

class FirebaseStorageManager {
  late firebase_storage.FirebaseStorage storage;
  static final FirebaseStorageManager _instance =
      FirebaseStorageManager._internal();

  factory FirebaseStorageManager() => _instance;

  FirebaseStorageManager._internal() {
    storage = firebase_storage.FirebaseStorage.instance;
  }

  Future<void> downloadFileExample() async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('puzzle')
          .child('84136530_p0.jpg');
      print(ref.name);
      print(await ref.getDownloadURL());
    } on firebase_storage.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  Future<String> uploadImageData(Uint8List data, String imageName) async {
    String text = 'Hello World!';
    List<int> encoded = utf8.encode(text);
    Uint8List data = Uint8List.fromList(encoded);
    // upload
    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref('puzzle/$imageName.jpg')
        .putData(data);

    // get Progress
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    try {
      await task.then((value) {
        return (value.ref.getDownloadURL());
      });
      return 'update error';
    } on firebase_storage.FirebaseException catch (e) {
      print(e.message);
      return 'update error';
    }
  }

  Future<String> uploadImageFile(String filePath, String imageName) async {
    String text = 'Hello World!';
    List<int> encoded = utf8.encode(text);
    Uint8List data = Uint8List.fromList(encoded);
    // upload
    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref('puzzle/$imageName.jpg')
        .putFile(File(filePath));

    // get Progress
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    try {
      await task;
      return task.snapshot.ref.getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print(e.message);
      return 'update error';
    }
  }
}
