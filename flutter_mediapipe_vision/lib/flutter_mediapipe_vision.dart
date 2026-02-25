import 'dart:typed_data';

import 'package:flutter_mediapipe_vision_platform_interface/flutter_mediapipe_vision_platform_interface.dart';
import 'package:flutter_mediapipe_vision_platform_interface/models.dart';

export 'package:flutter_mediapipe_vision_platform_interface/models.dart';

class FlutterMediapipeVision {
  static Future<void> ensureInitialized() async {
    await FlutterMediapipeVisionPlatform.instance.ensureInitialized();
  }

  static Future<PoseLandmarkerResult> detect(Uint8List bytes) async {
    return await FlutterMediapipeVisionPlatform.instance.detect(bytes);
  }

  static Future<PoseLandmarkerResult> detectOnPlanes(
    List<Uint8List> planes, {
    required int width,
    required int height,
  }) async {
    return await FlutterMediapipeVisionPlatform.instance.detectOnPlanes(
      planes,
      width: width,
      height: height,
    );
  }
}
