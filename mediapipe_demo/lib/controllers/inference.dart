import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mediapipe_vision/flutter_mediapipe_vision.dart';

class InferenceController extends ChangeNotifier {
  final CameraController cameraController;

  PoseLandmarkerResult get lastResult => _lastResult;
  PoseLandmarkerResult _lastResult = PoseLandmarkerResult.empty();

  InferenceController({required this.cameraController});

  Future<void> start() async {
    while (true) {
      await _tick();
    }
  }

  Future<void> _tick() async {
    final file = await cameraController.takePicture();
    final bytes = await file.readAsBytes();

    _lastResult = await FlutterMediapipeVision.detect(bytes);
    notifyListeners();
  }
}
