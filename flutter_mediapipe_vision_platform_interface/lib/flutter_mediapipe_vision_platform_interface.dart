import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models.dart';

abstract class FlutterMediapipeVisionPlatform extends PlatformInterface {
  FlutterMediapipeVisionPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMediapipeVisionPlatform _instance =
      FlutterMediapipeVisionMethodChannel();

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

  Future<PoseLandmarkerResult> detectOnPlanes(
    List<Uint8List> planes, {
    required int width,
    required int height,
  }) {
    throw UnimplementedError();
  }
}

const MethodChannel _channel = MethodChannel(
  'ainkin.com/flutter_mediapipe_vision',
);

class FlutterMediapipeVisionMethodChannel
    extends FlutterMediapipeVisionPlatform {
  @override
  Future<void> ensureInitialized() async {
    await _channel.invokeMethod<void>('ensureInitialized');
  }

  @override
  Future<PoseLandmarkerResult> detect(Uint8List bytes) async {
    final native = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'detect',
      {'image': bytes},
    );

    if (native == null) {
      throw Exception('Should have returned non-null');
    }

    return PoseLandmarkerResult.fromJson(_castToStringKeyedMap(native));
  }

  @override
  Future<PoseLandmarkerResult> detectOnPlanes(
    List<Uint8List> planes, {
    required int width,
    required int height,
  }) async {
    final native = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'detectOnPlanes',
      {'planes': planes, 'width': width, 'height': height},
    );

    if (native == null) {
      throw Exception('Should have returned non-null');
    }

    return PoseLandmarkerResult.fromJson(_castToStringKeyedMap(native));
  }
}

/// Converts the raw Map<dynamic, dynamic> that comes from MethodChannel
/// into a properly typed Map<String, dynamic> that json_serializable loves.
Map<String, dynamic> _castToStringKeyedMap(Map<dynamic, dynamic> map) {
  return map.map((key, value) => MapEntry(key.toString(), _castValue(value)));
}

dynamic _castValue(dynamic value) => switch (value) {
  Map() => _castToStringKeyedMap(value),
  List() => value.map(_castValue).toList(),
  _ => value,
};
