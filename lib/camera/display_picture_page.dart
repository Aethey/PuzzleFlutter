import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:photopuzzle/game_page.dart';
import 'package:photopuzzle/utils/image_util.dart';

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;

  const DisplayPicturePage({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            child: Image.file(File(imagePath)),
          ),
          Container(
            child: RaisedButton(
              onPressed: () {
                startGame(context, imagePath);
              },
              child: Container(
                child: Text(''),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> startGame(BuildContext context, String imagePath) async {
    Uint8List bytes = await ImageUtil.pathToImage(imagePath);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GamePage(MediaQuery.of(context).size, bytes, 3)));
  }
}
