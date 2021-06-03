import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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

  Future<QuerySnapshot> getPuzzleFromCloud(
      String collectionID, String documentID) async {
    print('getPuzzleFromCloud');
    var dc = await Firestore.instance
        .collection(collectionID)
        .document(documentID)
        .collection('puzzles')
        .getDocuments();
    EasyLoading.dismiss();

    return dc;
  }

  // realtime
  Stream<QuerySnapshot> getPuzzleFromCloudRealTime(
      String collectionID, String documentID) {
    return Firestore.instance
        .collection(collectionID)
        .document(documentID)
        .collection('puzzles')
        .snapshots();
  }

  void setDataToFirebase(
      String userName, String imageName, Map<String, dynamic> map) {
    final doc = Firestore.instance.collection('images');
    doc
        .document(userName)
        .collection('puzzles')
        .document(imageName)
        .setData(map);
  }

  Future<void> deleteData(String collectionID, String documentID) async {
    return await Firestore.instance
        .collection(collectionID)
        .document(documentID)
        .delete();
  }
}
