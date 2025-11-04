import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:flutter_mediapipe_vision/flutter_mediapipe_vision.dart';
import 'package:flutter_mediapipe_vision_platform_interface/flutter_mediapipe_vision_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'src/interop/mediapipe.dart';
import 'src/interop/pose_landmarker.dart';
import 'src/interop/pose_landmarker_result.dart' as js_plr;

const _windowVar = 'flutter_mediapipe_vision';

PoseLandmarker? _landmarker;

class FlutterMediapipeVisionWeb extends FlutterMediapipeVisionPlatform {
  static void registerWith(Registrar registrar) {
    FlutterMediapipeVisionPlatform.instance = FlutterMediapipeVisionWeb();
  }

  MediaPipe get mp => globalContext[_windowVar] as MediaPipe;

  Future<void>? _initFuture;

  @override
  Future<void> ensureInitialized() =>
      _initFuture ?? (_initFuture = _initOnce());

  Future<void> _initOnce() async {
    print('initOnce()');

    await injectSrcScript(
      'https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision/vision_bundle.js',
      _windowVar,
    );

    final fs = await mp.FilesetResolver.forVisionTasks(
      'https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@latest/wasm',
    ).toDart;

    final options = PoseLandmarkerOptions(
      baseOptions: BaseOptions(
        modelAssetPath:
            "packages/flutter_mediapipe_vision/assets/assets/models/pose_landmarker_lite.task",
      ),
      numPoses: 5,
      runningMode: "IMAGE",
    );

    _landmarker = await mp.PoseLandmarker.createFromOptions(fs, options).toDart;
  }

  Future<void> injectSrcScript(String src, String windowVar) async {
    final web.HTMLScriptElement script =
        web.document.createElement('script') as web.HTMLScriptElement;
    script.type = 'text/javascript';
    script.crossOrigin = 'anonymous';

    final stringUrl = src;
    script.text =
        '''
    window.ff_trigger_$windowVar = async (callback) => {
      console.debug("MediaPipe $windowVar");
      callback(await import("$stringUrl"));
    };
    ''';

    web.console.log('Appending a script'.toJS);
    web.document.head!.appendChild(script);

    Completer completer = Completer();

    globalContext.callMethod(
      'ff_trigger_$windowVar'.toJS,
      (JSAny module) {
        globalContext[windowVar] = module;
        globalContext.delete('ff_trigger_$windowVar'.toJS);
        completer.complete();
      }.toJS,
    );

    await completer.future;
  }

  @override
  Future<PoseLandmarkerResult> detect(Uint8List bytes) async {
    PoseLandmarkerResult r = PoseLandmarkerResult.empty();
    final el = await createImageFromBytes(bytes);

    _landmarker!.detect(
      el,
      (js_plr.PoseLandmarkerResult? result) {
        r = result?.toDart ?? PoseLandmarkerResult.empty();
      }.toJS,
    );

    return r;
  }
}

Future<web.HTMLImageElement> createImageFromBytes(Uint8List bytes) async {
  final completer = Completer();

  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: detectImageFormat(bytes)),
  );
  final imageUrl = web.URL.createObjectURL(blob);
  final el = web.document.createElement('img') as web.HTMLImageElement;

  el.onload = () {
    web.URL.revokeObjectURL(imageUrl);
    completer.complete();
  }.toJS;
  el.onerror = () {
    web.URL.revokeObjectURL(imageUrl);
    completer.completeError('Cannot load the image.');
  }.toJS;

  el.src = imageUrl;
  await completer.future;
  return el;
}

String detectImageFormat(Uint8List data) {
  if (data.length < 8) {
    throw Exception('Not an image.');
  }

  if (data[0] == 0xFF && data[1] == 0xD8 && data[2] == 0xFF) {
    return 'image/jpeg';
  }

  if (data[0] == 0x89 &&
      data[1] == 0x50 &&
      data[2] == 0x4E &&
      data[3] == 0x47 &&
      data[4] == 0x0D &&
      data[5] == 0x0A &&
      data[6] == 0x1A &&
      data[7] == 0x0A) {
    return 'image/png';
  }

  if (data[0] == 0x47 &&
      data[1] == 0x49 &&
      data[2] == 0x46 &&
      data[3] == 0x38 &&
      (data[4] == 0x37 || data[4] == 0x39) &&
      data[5] == 0x61) {
    return 'image/gif';
  }

  if (data[0] == 0x42 && data[1] == 0x4D) {
    return 'image/bmp';
  }

  if (data[0] == 0x52 &&
      data[1] == 0x49 &&
      data[2] == 0x46 &&
      data[3] == 0x46 &&
      data[8] == 0x57 &&
      data[9] == 0x45 &&
      data[10] == 0x42 &&
      data[11] == 0x50) {
    return 'image/webp';
  }

  if (data[4] == 0x66 &&
      data[5] == 0x74 &&
      data[6] == 0x79 &&
      data[7] == 0x70 &&
      data[8] == 0x61 &&
      data[9] == 0x76 &&
      data[10] == 0x69 &&
      data[11] == 0x66) {
    return 'image/avif';
  }

  if (data[4] == 0x66 &&
      data[5] == 0x74 &&
      data[6] == 0x79 &&
      data[7] == 0x70 &&
      data[8] == 0x68 &&
      data[9] == 0x65 &&
      data[10] == 0x69 &&
      data[11] == 0x63) {
    return 'image/heic';
  }

  if (data[0] == 0x00 &&
      data[1] == 0x00 &&
      data[2] == 0x01 &&
      data[3] == 0x00) {
    return 'image/x-icon';
  }

  throw Exception('Unknown image format.');
}

extension on js_plr.PoseLandmarkerResult {
  PoseLandmarkerResult get toDart => PoseLandmarkerResult(
    landmarks: [
      for (final obj in landmarks.toDart)
        [for (final landmark in obj.toDart) landmark.toDart],
    ],
  );
}

extension on js_plr.NormalizedLandmark {
  NormalizedLandmark get toDart =>
      NormalizedLandmark(x: x, y: y, z: z, visibility: visibility ?? 0);
}
