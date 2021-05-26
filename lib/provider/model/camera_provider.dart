import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraProviderModel extends ChangeNotifier {
  static CameraController cameraController;

  CameraController get camera => cameraController;

  CameraProviderModel();

  void initCamera() async {
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    cameraController = CameraController(
      // Get a specific camera from the list of available cameras.
      firstCamera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    notifyListeners();
  }
}
