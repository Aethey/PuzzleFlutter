import 'package:flutter/material.dart';
import 'dart:io';

import 'package:photopuzzle/game_page.dart';

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GamePage(
                            MediaQuery.of(context).size, imagePath, 3)));
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
}
