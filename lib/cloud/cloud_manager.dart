import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class CloudManager {
  factory CloudManager() => _getInstance();
  static CloudManager get instance => _getInstance();
  static CloudManager _instance;

  CloudManager._internal() {
    // init
  }

  static CloudManager _getInstance() {
    if (_instance == null) {
      _instance = new CloudManager._internal();
    }
    return _instance;
  }

  Future<Map<String, dynamic>> getDataFromCloud() async {
    DocumentSnapshot dc =
        await Firestore.instance.collection("images").document("user001").get();
    Map<String, dynamic> data = dc.data;

    return dc.data;
  }

  void setDataToFirebase(Map<String, dynamic> map) {
    Firestore.instance
        .collection('images')
        .document("user001")
        .updateData({randomString(5): map});
  }
}
