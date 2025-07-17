import 'dart:js_interop';
import 'package:web/web.dart';
import 'dart:js_interop_unsafe';

// this is supplied by vscode in order to securely access their api
@JS('acquireVsCodeApi')
external VSCodeApi? acquireVsCodeApi();

extension type VSCodeApi(JSObject _) implements JSObject {
  external void postMessage(JSAny message);
}

class WebviewMessageHandler {
  late final VSCodeApi? _vscodeApi;
  Function(Map<String, dynamic>)? _onMessage;

  WebviewMessageHandler() {
    _vscodeApi = acquireVsCodeApi();
    _setupMessageListener();
  }

  void _setupMessageListener() {
    window.addEventListener(
      'message',
      (MessageEvent event) {
        try {
          final data = event.data;
          if (data.isDefinedAndNotNull) {
            final handler = _onMessage;
            if (handler != null) {
              try {
                final message = Message.fromJsObject(data as JSObject);
                handler({'type': message.type, 'value': message.value ?? 0});
              } catch (e) {
                // Handle conversion errors silently
              }
            }
          }
        } catch (e) {}
      }.toJS,
    );
  }

  void setMessageHandler(Function(Map<String, dynamic>) handler) {
    _onMessage = handler;
  }

  void sendMessage(Map<String, dynamic> message) {
    final api = _vscodeApi;
    if (api != null) {
      final jsMessage = message.jsify();
      if (jsMessage.isDefinedAndNotNull) {
        api.postMessage(jsMessage as JSAny);
      }
    }
  }
}

class Message {
  final String type;
  final int? value;

  Message({required this.type, this.value});

  factory Message.fromJsObject(JSObject jsObject) {
    final typeJs = jsObject['type'];
    final valueJs = jsObject['value'];

    final type = typeJs.isDefinedAndNotNull ? (typeJs as JSString).toDart : '';
    final value = valueJs.isDefinedAndNotNull
        ? (valueJs as JSNumber).toDartInt
        : null;

    return Message(type: type, value: value);
  }
}
