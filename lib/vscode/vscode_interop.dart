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
  Function(Message)? _onMessage;

  WebviewMessageHandler() {
    _vscodeApi = acquireVsCodeApi();
    _setupMessageListener();
  }

  void messageHandler(MessageEvent event) {
    try {
      final data = event.data;
      if (data.isDefinedAndNotNull) {
        try {
          final message = Message.fromJsObject(data as JSObject);
          _onMessage ?? _onMessage!(message);
        } catch (e) {
          // unexpected message coming through
          throw Error();
        }
      }
    } catch (e) {
      print('receive message failed');
    }
  }

  void _setupMessageListener() {
    window.addEventListener('message', messageHandler.toJS);
  }

  void setMessageHandler(Function(Message) handler) {
    _onMessage = handler;
  }

  void sendMessage(Message message) {
    final api = _vscodeApi;
    if (api == null) throw Error();

    // .toJsMessage is our custom extension to convert
    final jsMessage = message.toJsMessage();

    if (jsMessage.isDefinedAndNotNull) {
      api.postMessage(jsMessage);
    }
  }
}

class Message {
  final String type;
  final int value;

  Message({required this.type, required this.value});

  factory Message.fromJsObject(JSObject jsObject) {
    final typeJs = jsObject['type'];
    final valueJs = jsObject['value'];

    final type = typeJs.isDefinedAndNotNull ? (typeJs as JSString).toDart : '';
    final value = valueJs.isDefinedAndNotNull
        ? (valueJs as JSNumber).toDartInt
        : 0;

    return Message(type: type, value: value);
  }
}

extension JSMessage on Message {
  JSObject toJsMessage() {
    final jsObject = JSObject();
    jsObject.setProperty('type'.toJS, type.toJS);
    jsObject.setProperty('value'.toJS, value.toJS);
    return jsObject;
  }
}
