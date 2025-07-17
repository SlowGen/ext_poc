import 'package:flutter/material.dart';
import 'vscode/vscode_interop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

    // Set up message handlers
    _messageHandler.setMessageHandler((message) {
      final messageType = message['type'] as String?;
      
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
    _messageHandler.sendMessage({
      'type': 'counterUpdate',
      'value': _counter
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
