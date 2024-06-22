import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainFrame extends StatelessWidget {
  final Widget headline;
  final Widget child;
  const MainFrame({required this.headline, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: CustomDefaultTextStyle(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGreen,
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.systemGrey4,
                    width: 1,
                  ),
                ),
              ),
              child: Center(child: headline),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class CustomDefaultTextStyle extends StatelessWidget {
  final Widget child;
  const CustomDefaultTextStyle({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 30),
      child: child,
    );
  }
}