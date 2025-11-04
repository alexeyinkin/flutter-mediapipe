import 'dart:js_interop';

import 'package:web/web.dart';

import 'wasm_fileset.dart';

extension type PoseLandmarker._(JSObject _) implements JSObject {
  external JSPromise<PoseLandmarker> createFromOptions(
    WasmFileset fileset,
    PoseLandmarkerOptions options,
  );

  external void detect(HTMLImageElement img, JSFunction callback);
}

extension type PoseLandmarkerOptions._(JSObject _) implements JSObject {
  external PoseLandmarkerOptions({
    BaseOptions baseOptions,
    int numPoses,
    String runningMode,
  });

  // TODO: Move to TaskRunnerOptions, extended by VisionTaskOptions.
  external BaseOptions get baseOptions;

  external int get numPoses;

  external String get runningMode;
}

extension type BaseOptions._(JSObject _) implements JSObject {
  external BaseOptions({String modelAssetPath});

  external String get modelAssetPath;
}
