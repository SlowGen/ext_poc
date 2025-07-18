import 'package:flutter/material.dart';
import 'vscode_interop.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Counter VSCode Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late final WebviewMessageHandler _messageHandler;

  @override
  void initState() {
    super.initState();
    _messageHandler = WebviewMessageHandler();

    // Set up message handlers, this is separated in order to isolate the js_interop to one spot
    _messageHandler.setMessageHandler((message) {
      final messageType = message.type;

      switch (messageType) {
        case 'add':
          _incrementCounter();
          break;
        case 'reset':
          _resetCounter();
          break;
      }
    });

    // Send initial counter value
    _updateCounterInVsCode();
  }

  @override
  void dispose() {
    _messageHandler.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _updateCounterInVsCode();
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    _updateCounterInVsCode();
  }

  void _updateCounterInVsCode() {
    _messageHandler.sendMessage(
      Message(type: 'counterUpdate', value: _counter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
