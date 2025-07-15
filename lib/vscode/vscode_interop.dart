import 'dart:js_interop';

@JS()
external VsCode get vscode;

extension type VsCode(JSObject _) implements JSObject {
  external VSWindow get window;
}

extension type VSWindow(JSObject _) implements JSObject {
  external void registerWebviewViewProvider();
}
