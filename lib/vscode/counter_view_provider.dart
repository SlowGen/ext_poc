import 'dart:convert';
import 'dart:io';
import 'dart:js_interop';

import 'package:ext_poc/vscode/vscode_interfaces.dart';
import 'package:path/path.dart' as path;

class CounterViewProvider {
  CounterViewProvider(this.extensionUri);
  final VSUri extensionUri;

  static const viewType = 'counter.counterView';
  WebviewView? _view;
  int _counter = 0;

  void resolveWebviewView(
    WebviewView webviewView,
    WebviewViewResolveContext context,
    CancellationToken token,
  ) {
    _view = webviewView;

    webviewView.webview.options = WebviewOptions(
      true.toJS,
      [extensionUri].toJS,
    );

    // Set up the webview HTML content
    webviewView.webview.html = _getWebviewContent().toJS;

    // Set up message handler for webview communication
    webviewView.webview.onDidReceiveMessage(
      (JSString data) {
        _handleMessage(data);
        return null;
      }.toJS,
    );

    // Send initial counter value to webview
    _postMessage({'type': 'counterUpdate', 'value': _counter});
  }

  /// Handles messages received from the webview
  void _handleMessage(JSString data) {
    try {
      final messageData = jsonDecode(data.toDart);
      final messageType = messageData['type'] as String?;

      switch (messageType) {
        case 'increment':
          _incrementCounter();
          break;
        case 'decrement':
          _decrementCounter();
          break;
        case 'reset':
          _resetCounter();
          break;
        case 'getCounter':
          _postMessage({'type': 'counterUpdate', 'value': _counter});
          break;
        default:
          print('Unknown message type: $messageType');
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  /// Increments the counter and updates the webview
  void _incrementCounter() {
    _counter++;
    _postMessage({'type': 'counterUpdate', 'value': _counter});
  }

  /// Decrements the counter and updates the webview
  void _decrementCounter() {
    _counter--;
    _postMessage({'type': 'counterUpdate', 'value': _counter});
  }

  /// Resets the counter to 0 and updates the webview
  void _resetCounter() {
    _counter = 0;
    _postMessage({'type': 'counterUpdate', 'value': _counter});
  }

  /// Posts a message to the webview
  void _postMessage(Map<String, dynamic> message) {
    _view?.webview.postMessage(jsonEncode(message).toJS);
  }

  /// Returns the HTML content for the webview by reading web/index.html
  String _getWebviewContent() {
    try {
      // Get the path to the web/index.html file
      final htmlPath = path.join(path.dirname(path.dirname(path.current)), 'web', 'index.html');
      final htmlFile = File(htmlPath);
      
      if (htmlFile.existsSync()) {
        return htmlFile.readAsStringSync();
      } else {
        print('HTML file not found at: $htmlPath');
        return _getFallbackContent();
      }
    } catch (e) {
      print('Error reading HTML file: $e');
      return _getFallbackContent();
    }
  }
  
  /// Returns a fallback HTML content if the file cannot be read
  String _getFallbackContent() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Counter View</title>
</head>
<body>
    <h2>Counter View</h2>
    <p>Error loading content. Please check that web/index.html exists.</p>
</body>
</html>
''';
  }
}
