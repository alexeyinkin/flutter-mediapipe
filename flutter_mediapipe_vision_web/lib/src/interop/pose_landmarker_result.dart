import 'dart:js_interop';

extension type PoseLandmarkerResult._(JSObject _) implements JSObject {
  external JSArray<JSArray<NormalizedLandmark>> get landmarks;
}

extension type NormalizedLandmark._(JSObject _) implements JSObject {
  external double get x;
  external double get y;
  external double get z;
  external double? get visibility;
}
