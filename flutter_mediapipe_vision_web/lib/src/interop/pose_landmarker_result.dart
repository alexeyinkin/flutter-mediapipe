import 'dart:js_interop';

// https://github.com/google-ai-edge/mediapipe/blob/master/mediapipe/tasks/web/vision/pose_landmarker/pose_landmarker_result.ts
extension type PoseLandmarkerResult._(JSObject _) implements JSObject {
  external JSArray<JSArray<NormalizedLandmark>> get landmarks;
}

// https://github.com/google-ai-edge/mediapipe/blob/master/mediapipe/tasks/web/components/containers/landmark.d.ts
extension type NormalizedLandmark._(JSObject _) implements JSObject {
  external num get x;
  external num get y;
  external num get z;
  external num? get visibility;
}
