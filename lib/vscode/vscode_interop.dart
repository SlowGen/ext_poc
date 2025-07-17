import 'dart:js_interop';
import 'package:web/web.dart';
import 'dart:js_interop_unsafe';


class Message {
  final String type;
  final int? value;

  Message({required this.type, this.value});

  factory Message.fromJsObject(JSObject jsObject) {
    final type = (jsObject['type'] as JSString).toDart;
    final value = jsObject['value'] != null ? (jsObject['value'] as JSNumber).toDartInt : null;
    return Message(type: type, value: value);
  }
}

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
try {
            final message = Message.fromJsObject(data as JSObject);
            _onMessage!({'type': message.type, 'value': message.value ?? 0});
          } catch (e) {
          }
        } else {
        }
      } catch (e) {
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
