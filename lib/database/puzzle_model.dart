import 'package:cloud_firestore/cloud_firestore.dart';

class PuzzleModel {
  final String b64;
  final Timestamp time;

  PuzzleModel(this.b64, this.time);

  PuzzleModel.fromjson(Map<String, dynamic> json)
      : b64 = json['b64'],
        time = json['time'];

  Map<String, dynamic> toJson() => {'b64': b64, 'time': time};
}
