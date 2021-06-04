import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photopuzzle/api/cloud_manager.dart';
import 'dart:io';
import 'package:random_string/random_string.dart';
import 'package:photopuzzle/utils/image_util.dart';
import 'package:photopuzzle/widgets/game/game_page.dart';

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;

  const DisplayPicturePage({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: _buildBody(size, context),
    );
  }

  Column _buildBody(Size size, BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: size.width,
          child: Image.file(File(imagePath)),
        ),
        Container(
          alignment: Alignment.center,
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              startGame(context, imagePath);
            },
            child: Container(
              child: Text('start'),
            ),
          ),
        )
      ],
    );
  }

  Future<void> startGame(BuildContext context, String imagePath) async {
    Uint8List bytes = await ImageUtil.pathToImage(imagePath);

    String base64Image = base64Encode(bytes);
    Map<String, String> map = {'b64': base64Image};
    CloudManager.instance.setDataToFirebase('user001', randomString(5), map);

    await Navigator.push<void>(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GamePage(MediaQuery.of(context).size, bytes, 3)));
  }
}
