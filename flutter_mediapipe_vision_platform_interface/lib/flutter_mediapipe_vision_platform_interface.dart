import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models.dart';

abstract class FlutterMediapipeVisionPlatform extends PlatformInterface {
  FlutterMediapipeVisionPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMediapipeVisionPlatform _instance = FlutterMediapipeVisionMethodChannel();

  static FlutterMediapipeVisionPlatform get instance => _instance;

  static set instance(FlutterMediapipeVisionPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<void> ensureInitialized() {
    throw UnimplementedError();
  }

  Future<PoseLandmarkerResult> detect(Uint8List bytes) {
    throw UnimplementedError();
  }
}

const MethodChannel _channel = MethodChannel('ainkin.com/flutter_mediapipe_vision');

class FlutterMediapipeVisionMethodChannel extends FlutterMediapipeVisionPlatform {
  @override
  Future<void> ensureInitialized() async {
    await _channel.invokeMethod<void>('ensureInitialized');
  }

  @override
  Future<PoseLandmarkerResult> detect(Uint8List bytes) async {
    final native = await _channel.invokeMethod<void>('detect');
    throw UnimplementedError('TODO: Convert.');
  }
}
