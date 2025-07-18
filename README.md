# ext_poc

Flutter VSCode extension demo!

## Getting Started

This project demonstrates how to utilized Flutter as a Webview UI in a VSCode extension.

Steps to get started:

1. You must have Flutter and Node installed (whatever lts is fine)
2. Run `flutter pub get` and `npm install` to get all packages
3. With VSCode open, hit `f5` to start a debug session and this will automatically compile and run everything for you.
4. You'll see a new VSCode instance open, you can open a debugger to see the console for the flutter webview by opening the Command Pallette for VSCode and selecting `Developer: Open Webview Developer Tools`

## Notable pieces of this code

1. The Flutter `index.html` and `flutter_bootstrap.js` are custom, this is in order to accommodate strict csp rules.
2. Both the JS side and the Dart side play key roles in communicating with the various parts of the JS runtime. While you can use `js_interop` to bridge that communication, there are ultimately different runtimes that need accommodating. The `extension.ts` file handles the VSCode runtime (which is JS) and the JS runtime that the Flutter engine sits atop is entirely separate. This is bridged through passing messages using `js_interop` and `web`.
3. There is a build script: `scripts/compile.sh` that handles both the JS and Flutter builds, it is called automatically by VSCode's `launch.json` that is declared in `package.json`.





