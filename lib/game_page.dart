import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopuzzle/game/game_widget.dart';

class GamePage extends StatelessWidget {
  final Size size;
  final String imgPath;
  final int level;
  GamePage(this.size, this.imgPath, this.level);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('PUZZLE'),
      ),
      body: Container(
        child: GameWidget(size, imgPath, level),
      ),
    );
  }
}
