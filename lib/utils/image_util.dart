import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUtil {
  static Uint8List b64ToImage(String b64) {
    var bytes = Base64Decoder().convert(b64);
    return bytes;
  }

  static Future<Uint8List> pathToImage(String path) async {
    var file = File(path);

    var bytes = await compressFile(file);

    return bytes;
  }

  static Future<Uint8List> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 50,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  }
}
