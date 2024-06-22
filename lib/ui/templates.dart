import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Main Frame'),
      ),
      child: Center(
        child: FilledButton(
          onPressed: () {
            //TODO: Do something
          },
          child: const Text('Action Button'),
        ),
      ),
    );
  }
}