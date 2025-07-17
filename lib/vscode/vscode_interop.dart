import 'dart:js_interop';
import 'package:web/web.dart';

@JS()
external VsCode get vscode;

@JS('acquireVsCodeApi')
external VSCodeApi? acquireVsCodeApi();

extension type VsCode(JSObject _) implements JSObject {
  external VSWindow get window;
}

extension type VSWindow(JSObject _) implements JSObject {
  external void registerWebviewViewProvider();
  external void postMessage(JSAny message);
}

extension type VSCodeApi(JSObject _) implements JSObject {
  external void postMessage(JSAny message);
  external void setState(JSAny state);
  external JSAny getState();
}

class WebviewMessageHandler {
  late final VSCodeApi? _vscodeApi;
  Function(Map<String, dynamic>)? _onMessage;

  WebviewMessageHandler() {
    _vscodeApi = acquireVsCodeApi();
    _setupMessageListener();
  }

  void _setupMessageListener() {
    window.addEventListener('message', (MessageEvent event) {
      try {
        final data = event.data;
        if (data != null && _onMessage != null) {
          // Convert JS object to Dart Map
          final dartData = (data as JSObject).dartify() as Map<String, dynamic>;
          _onMessage!(dartData);
        }
      } catch (e) {
        print('Error handling message: $e');
      }
    }.toJS);
  }

  void setMessageHandler(Function(Map<String, dynamic>) handler) {
    _onMessage = handler;
  }

  void sendMessage(Map<String, dynamic> message) {
    _vscodeApi?.postMessage(message.jsify() ?? ''.toJS);
  }
}
