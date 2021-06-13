import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // The node used to request the keyboard focus.
  final FocusNode focusNode = FocusNode();
// The message to display.
  String? message;

  // Focus nodes need to be disposed.
  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

// Handles the key events from the RawKeyboardListener and update the
// _message.
  void _handleKeyEvent(RawKeyEvent event) {
    setState(() {
      if (event.logicalKey == LogicalKeyboardKey.keyQ) {
        message = 'Pressed the "Q" key!';
      } else {
        if (kReleaseMode) {
          message =
              'Not a Q: Pressed 0x${event.logicalKey.keyId.toRadixString(16)}';
        } else {
          // The debugName will only print useful information in debug mode.
          message = 'Not a Q: Pressed ${event.logicalKey.debugName}';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: textTheme.headline4!,
        child: RawKeyboardListener(
          focusNode: focusNode,
          onKey: _handleKeyEvent,
          child: AnimatedBuilder(
            animation: focusNode,
            builder: (BuildContext context, Widget? child) {
              if (!focusNode.hasFocus) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(focusNode);
                  },
                  child: const Text('Tap to focus'),
                );
              }
              return Text(message ?? 'Press a key');
            },
          ),
        ),
      ),
    );
  }
}
