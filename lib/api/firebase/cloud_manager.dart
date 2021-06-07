import 'package:cloud_firestore/cloud_firestore.dart';


/// manage cloudFireStore APi
class CloudManager {
  static final CloudManager _instance = CloudManager._internal();

  factory CloudManager() => _instance;

  CloudManager._internal();

  Future<QuerySnapshot> getPuzzleFromCloud(
      String collectionID, String documentID,
      {DocumentSnapshot? last}) async {
    print('getPuzzleFromCloud');
    QuerySnapshot dc;
    if (last == null) {
      dc = await FirebaseFirestore.instance
          .collection(collectionID)
          .doc('user001')
          .collection('puzzles')
          .orderBy('upLoadTime',descending: true)
          .limit(3)
          .get();
    } else {
      dc = await FirebaseFirestore.instance
          .collection(collectionID)
          .doc(documentID)
          .collection('puzzles')
          .orderBy('upLoadTime',descending: true)
          .startAfterDocument(last)
          .limit(2)
          .get();
    }
    return dc;
  }

  // realtime
  Stream<QuerySnapshot> getPuzzleFromCloudRealTime(
      String collectionID, String documentID) {
    return FirebaseFirestore.instance
        .collection(collectionID)
        .doc(documentID)
        .collection('puzzles')
        .limit(2)
        .snapshots();
  }

  void setDataToFirebase(
      String userName, String imageName, Map<String, dynamic> map) {
    final doc = FirebaseFirestore.instance.collection('images');
    doc.doc(userName).collection('puzzles').doc(imageName).set(map);
  }

  Future<void> deleteData(String collectionID, String documentID) async {
    return await FirebaseFirestore.instance
        .collection(collectionID)
        .doc(documentID)
        .delete();
  }
}
