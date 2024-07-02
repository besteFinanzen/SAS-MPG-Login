import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sas_login_app/ui/scan_screen.dart';
import 'package:sas_login_app/ui/select_file_screen.dart';

import 'backend/init.dart' as backend_init;
import 'backend/init.dart';
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
    Permission.manageExternalStorage.request();
    Permission.manageExternalStorage.isGranted.then((val) {
      if (!val) {
        Permission.manageExternalStorage.request();
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      initialRoute: (!hasSavedFile) ? "/file" : "/scan",
      routes: {
        "/file": (_) => const FileSelectorScreen(),
        "/scan": (_) => const ScanScreen(),
      },
    );
  }
}
