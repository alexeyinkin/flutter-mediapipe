import 'dart:js_interop';

import 'fileset_resolver.dart' as fsr;
import 'pose_landmarker.dart' as plm;

// The module root object.
extension type MediaPipe._(JSObject _) implements JSObject {
  external fsr.FilesetResolver get FilesetResolver;

  external plm.PoseLandmarker get PoseLandmarker;
}
