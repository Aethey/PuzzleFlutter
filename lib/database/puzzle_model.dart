import 'package:cloud_firestore/cloud_firestore.dart';


///
class PuzzleModel {
  ///
  const PuzzleModel(this.b64, this.time);
  ///
  PuzzleModel.fromJson(Map<String, dynamic> json)
      : b64 = json['b64'] as String,
        time = json['time'] as Timestamp;
  ///
  final String b64;
  ///
  final Timestamp time;
  ///
  Map<String, dynamic> toJson() => <String, dynamic>{'b64': b64, 'time': time};
}
