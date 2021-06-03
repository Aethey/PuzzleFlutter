import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show instantiateImageCodec, Image;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'image_node.dart';

class PuzzleUtil {
  ui.Image image;
  double eachWidth;
  Size screenSize;
  double baseX;
  double baseY;

  int level;
  double eachBitmapWidth;

  Future<ui.Image> init(Uint8List bytes, Size size, int level) async {
    image = await getImage(bytes);

    screenSize = size;
    this.level = level;
    eachWidth = screenSize.width * 0.8 / level;
    baseX = screenSize.width * 0.1;
    baseY = (screenSize.height - screenSize.width) * 0.1;

    eachBitmapWidth = (image.width / level);
    return image;
  }

  Future<ui.Image> getImage(Uint8List bytes) async {

    var codec = await ui.instantiateImageCodec(bytes);
    var frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<Uint8List> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 50,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  }

  List<ImageNode> doTask() {
    var list = <ImageNode>[];
    for (var j = 0; j < level; j++) {
      for (var i = 0; i < level; i++) {
        var index = j * level + i;
        if (index < level * level - 1) {
          var node = ImageNode();
          node.rect = getOkRectF(i, j);
          node.index = index;
          makeBitmap(node,i,j);
          list.add(node);
        }
      }
    }
    return list;
  }

  Rect getOkRectF(int i, int j) {
    return Rect.fromLTWH(
        baseX + eachWidth * i, baseY + eachWidth * j, eachWidth, eachWidth);
  }

  void makeBitmap(ImageNode node,int i,int j) {

    var rect = getShapeRect(eachBitmapWidth.toDouble() * i, eachBitmapWidth.toDouble() * j, eachBitmapWidth);
    var recorder = PictureRecorder();
    var ww = eachBitmapWidth.toDouble();
    var canvas = Canvas(recorder, Rect.fromLTWH(0.0, 0.0, ww, ww));
    var rect2 = Rect.fromLTRB(0.0, 0.0, rect.width, rect.height);
    var paint = Paint();
    canvas.drawImageRect(image, rect, rect2, paint);
    recorder.endRecording().toImage(ww.floor(), ww.floor()).then((value) {
      node.image = value;
    });
  }

  Rect getShapeRect(double x, double y, double width) {
    return Rect.fromLTRB(0.0 + x, 0.0 + y, width + x, width + y);
  }
}
