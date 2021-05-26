import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:random_string/random_string.dart';

class CloudManager {
  factory CloudManager() => _getInstance();
  static CloudManager get instance => _getInstance();
  static CloudManager _instance;

  CloudManager._internal() {
    // init
  }

  static CloudManager _getInstance() {
    _instance ??= CloudManager._internal();
    return _instance;
  }

  Future<Map<String, dynamic>> getPuzzleFromCloud(
      String collectionID, String documentID) async {
    print('getPuzzleFromCloud');
    var dc = await Firestore.instance
        .collection(collectionID)
        .document(documentID)
        .get();
    EasyLoading.dismiss();

    return dc.data;
  }

  // realtime
  Stream<DocumentSnapshot> getPuzzleFromCloudRealTime(
      String collectionID, String documentID) {
    return Firestore.instance
        .collection(collectionID)
        .document(documentID)
        .snapshots();
  }

  void setDataToFirebase(Map<String, dynamic> map) {
    Firestore.instance
        .collection('images')
        .document('user001')
        .updateData(<String, dynamic>{randomString(5): map});
  }
}
