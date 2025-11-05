import 'dart:js_interop';

import 'wasm_fileset.dart';

// https://github.com/google-ai-edge/mediapipe/blob/master/mediapipe/tasks/web/core/fileset_resolver.ts.template
extension type FilesetResolver._(JSObject _) implements JSObject {
  external JSPromise<WasmFileset> forVisionTasks(String basePath);
}
