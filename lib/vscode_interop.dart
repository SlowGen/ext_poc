import 'dart:js_interop';
import 'package:web/web.dart';
import 'dart:js_interop_unsafe';
import 'dart:async';

// this is supplied by vscode in order to securely access their api
@JS('acquireVsCodeApi')
external VSCodeApi? acquireVsCodeApi();

extension type VSCodeApi(JSObject _) implements JSObject {
  external void postMessage(JSObject message);
}

class WebviewMessageHandler {
  late final VSCodeApi? _vscodeApi;
  Function(Message)? _onMessage;

  WebviewMessageHandler() {
    try {
      _vscodeApi = acquireVsCodeApi();
      // Defer the message listener setup to ensure window is initialized
      Future.microtask(() {
        _setupMessageListener();
      });
    } catch (e) {
      print('missing vscode');
    }
  }

  void messageHandler(MessageEvent event) {
    try {
      final data = event.data;
      if (data.isDefinedAndNotNull) {
        try {
          final message = Message.fromJsObject(data as JSObject);
          _onMessage?.call(message);
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
    print('setup listener method');
    try {
      // Only attempt to add event listener if window is available
      if (window.isDefinedAndNotNull) {
        window.addEventListener('message', messageHandler.toJS);
        print('listener method setup');
      } else {
        print('window is not available yet');
      }
    } catch (e) {
      print('Error setting up message listener: $e');
    }
  }

  void setMessageHandler(Function(Message) handler) {
    _onMessage = handler;
  }

  void dispose() {
    try {
      if (window.isDefinedAndNotNull) {
        window.removeEventListener('message', messageHandler.toJS);
      }
    } catch (e) {
      print('Error removing event listener: $e');
    }
  }

  void sendMessage(Message message) {
    final api = _vscodeApi;
    final vscodeApi = api;
    if (vscodeApi case null) {
      print('VSCode API is not available, cannot send message');
      return;
    }

    print('sending message type: ${message.type} value: ${message.value}');

    try {
      // .toJsMessage is our custom extension to convert
      final jsMessage = message.toJsMessage();

      if (jsMessage.isDefinedAndNotNull) {
        vscodeApi.postMessage(jsMessage);
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}

class Message {
  final String type;
  final int value;

  Message({required this.type, this.value = 0});

  factory Message.fromJsObject(JSObject jsObject) {
    try {
      final typeJs = jsObject['type'];
      final valueJs = jsObject['value'];

      final type = typeJs.isDefinedAndNotNull
          ? (typeJs as JSString).toDart
          : '';
      final value = valueJs.isDefinedAndNotNull
          ? (valueJs as JSNumber).toDartInt
          : 0;

      return Message(type: type, value: value);
    } catch (e) {
      print('inside message factory');
    }
    throw Error();
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
