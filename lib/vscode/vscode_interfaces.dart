import 'dart:js_interop';

extension type ExtensionContext(JSObject _) implements JSObject {}

extension type VSUri(JSObject _) implements JSObject {}

extension type WebviewProvider(JSObject _) implements JSObject {}

extension type WebviewViewResolveContext(JSObject _) implements JSObject {}

extension type WebviewView(JSObject _) implements JSObject {
  external JSString get viewType;
  external Webview get webview;
  external JSString? get title;
  external JSString? get description;
  external ViewBadge? get badge;
  external JSBoolean get visible;
  external JSAny onDidDispose(JSFunction handler);
  external JSAny onDidChangeVisibility(JSFunction handler);
  external JSAny show(JSBoolean? preserveFocus);
}

extension type ViewBadge(JSObject _) implements JSObject {}

extension type Webview(JSObject _) implements JSObject {
  external JSString get html;
  external set html(JSString value);
  external WebviewOptions get options;
  external set options(WebviewOptions value);
  external JSAny onDidReceiveMessage(JSAny handler);
  external JSAny postMessage(JSString message);
}

extension type WebviewOptions._(JSObject _) implements JSObject {
  external WebviewOptions(
    JSBoolean enableScripts,
    JSArray<VSUri> localResourceRoots,
  );
  external JSBoolean enableScripts;
  external JSArray<VSUri> localResourceRoots;
}

extension type VSEvent<T>(JSObject _) implements JSObject {}

extension type CancellationToken(JSObject _) implements JSObject {}
