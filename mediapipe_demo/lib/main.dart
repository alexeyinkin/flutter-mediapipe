import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mediapipe_vision/flutter_mediapipe_vision.dart';

import 'controllers/inference.dart';
import 'widgets/camera_overlay.dart';

late InferenceController inferenceController;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterMediapipeVision.ensureInitialized();

  final cameraController = CameraController(
    (await availableCameras()).first,
    ResolutionPreset.low,
    enableAudio: false,
  );
  await cameraController.initialize();

  inferenceController = InferenceController(cameraController: cameraController);
  unawaited(inferenceController.start());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('MediaPipe demo')),
        body: Center(
          child: CameraOverlayWidget(inferenceController: inferenceController),
        ),
      ),
    );
  }
}
