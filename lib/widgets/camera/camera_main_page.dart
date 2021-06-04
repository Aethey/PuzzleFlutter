import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'display_picture_page.dart';

class CameraMainPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraMainPage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraMainState createState() => CameraMainState();
}

class CameraMainState extends State<CameraMainPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Take a picture')),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            await Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPicturePage(imagePath: image.path),
              ),
            );
          } catch (e) {
            //
            print(e);
          }
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  FutureBuilder<void> _buildBody() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
