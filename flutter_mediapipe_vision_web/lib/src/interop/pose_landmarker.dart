import 'dart:js_interop';

import 'package:web/web.dart';

import 'wasm_fileset.dart';

// https://github.com/google-ai-edge/mediapipe/blob/master/mediapipe/tasks/web/vision/pose_landmarker/pose_landmarker.ts
extension type PoseLandmarker._(JSObject _) implements JSObject {
  external JSPromise<PoseLandmarker> createFromOptions(
    WasmFileset fileset,
    PoseLandmarkerOptions options,
  );

  external void detect(HTMLImageElement img, JSFunction callback);
}

// https://github.com/google-ai-edge/mediapipe/blob/master/mediapipe/tasks/web/vision/pose_landmarker/pose_landmarker_options.d.ts
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

// https://github.com/google-ai-edge/mediapipe/blob/master/mediapipe/tasks/web/core/task_runner_options.d.ts
// https://github.com/google-ai-edge/mediapipe/blob/master/mediapipe/tasks/web/vision/core/vision_task_options.d.ts
extension type BaseOptions._(JSObject _) implements JSObject {
  external BaseOptions({String modelAssetPath});

  external String get modelAssetPath;
}
