import 'dart:js_interop';

import 'wasm_fileset.dart';

extension type FilesetResolver._(JSObject _) implements JSObject {
  external JSPromise<WasmFileset> forVisionTasks(String basePath);
}
