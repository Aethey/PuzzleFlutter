import 'dart:ui';
import 'dart:ui' as ui show TextStyle;

import 'package:flutter/material.dart';

import 'game_config.dart';
import 'image_node.dart';

class GamePainter extends CustomPainter {
  Paint mPaint;
  Path path;
  final int level;
  final List<ImageNode> nodes;
  final ImageNode hitNode;
  final bool needDraw;

  final double downX, downY, newX, newY;
  final List<ImageNode> hitNodeList;
  Direction direction;

  GamePainter(
      this.nodes,
      this.level,
      this.hitNode,
      this.hitNodeList,
      this.direction,
      this.downX,
      this.downY,
      this.newX,
      this.newY,
      this.needDraw) {
    mPaint = Paint();
    path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes != null) {
      for ( var node in nodes) {
        var rect2 = node.rect;
        if (hitNodeList != null && hitNodeList.contains(node)) {
          if (direction == Direction.left || direction == Direction.right) {
            rect2 = node.rect.shift(Offset(newX - downX, 0.0));
          } else if (direction == Direction.top ||
              direction == Direction.bottom) {
            rect2 = node.rect.shift(Offset(0.0, newY - downY));
          }
        }
        if (node.image != null) {
          var srcRect = Rect.fromLTRB(0.0, 0.0, node.image.width.toDouble(),
              node.image.height.toDouble());
          canvas.drawImageRect(node.image, srcRect, rect2, mPaint);
        }
      }

      for (var node in nodes) {
        var pb = ParagraphBuilder(ParagraphStyle(
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          fontSize: hitNode == node ? 20.0 : 15.0,
        ));
        if (hitNode == node) {
          pb.pushStyle(ui.TextStyle(color: Color(0xff00ff00)));
        }
        pb.addText('${node.index + 1}');
        var pc = ParagraphConstraints(width: node.rect.width);
        var paragraph = pb.build()..layout(pc);

        var offset = Offset(node.rect.left,
            node.rect.top + node.rect.height / 2 - paragraph.height / 2);
        if (hitNodeList != null && hitNodeList.contains(node)) {
          if (direction == Direction.left || direction == Direction.right) {
            offset = Offset(offset.dx + newX - downX, offset.dy);
          } else if (direction == Direction.top ||
              direction == Direction.bottom) {
            offset = Offset(offset.dx, offset.dy + newY - downY);
          }
        }
        canvas.drawParagraph(paragraph, offset);
      }
    }
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) {
    return needDraw || oldDelegate.needDraw;
  }
}
