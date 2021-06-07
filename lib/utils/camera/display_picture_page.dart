import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photopuzzle/api/firebase/cloud_manager.dart';
import 'package:photopuzzle/api/firebase/firebase_storage_manager.dart';
import 'package:photopuzzle/components/my_circle_button.dart';
import 'package:photopuzzle/states/provider/puzzle/puzzle_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:photopuzzle/utils/image_util.dart';
import 'package:photopuzzle/widgets/puzzle/puzzle_play_page.dart';

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;

  const DisplayPicturePage({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(title: Text('Display the Picture')),
      body: Stack(
        children: [
          Container(
              width: size.width,
              height: size.height,
              child: Image.file(File(imagePath), fit: BoxFit.cover)),
          _buildBody(size, context)
        ],
      ),
    );
  }

  Widget _buildBody(Size size, BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: size.height / 4),
            width: size.width,
            height: size.width,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          _buildButton(size, context)
        ],
      ),
    );
  }

  Widget _buildButton(Size size, BuildContext context) {
    return Container(
          margin: EdgeInsets.only(top: size.height / 8),
          alignment: Alignment.center,
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyCircleButton(
                width: size.width / 6,
                text: 'X',
                press: () {
                  Navigator.pop(context, true);
                },
              ),
              MyCircleButton(
                width: size.width / 6,
                text: 'O',
                press: () {
                  uploadImage(context, imagePath);
                },
              ),
            ],
          ),
        );
  }

  Future<void> uploadImage(BuildContext context, String imagePath) async {
    Uint8List bytes = await ImageUtil.pathToImage(imagePath);

    await FirebaseStorageManager()
        .uploadImageFile(imagePath, Random().nextInt(10000).toString())
        .then((value) {
      if (value != 'update error') {
        String imageUrl = value;
        DateTime now = DateTime.now();
        Map<String, dynamic> map = {'imageUrl': imageUrl, 'upLoadTime': now};
        CloudManager().setDataToFirebase(
            'user001', Random().nextInt(10000).toString(), map);
      }
      startGame(context, bytes);
    });
  }

  void startGame(BuildContext context, Uint8List bytes) {
    context.read(puzzleProvider.notifier).refresh();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PuzzlePlayPage(MediaQuery.of(context).size, bytes, 3)));
  }
}
