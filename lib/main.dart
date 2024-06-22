import 'package:flutter/material.dart';

import 'backend/init.dart' as backend_init;
import 'ui/init.dart' as ui_init;

void main() async {
  await Future.wait([
    backend_init.initBeforeShowingUI(),
    ui_init.initBeforeShowingUI(),
  ]);
  runApp(const MainApp());
  await Future.wait([
    backend_init.initAfterShowingUI(),
    ui_init.initAfterShowingUI(),
  ]);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
