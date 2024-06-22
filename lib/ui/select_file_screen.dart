import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_login_app/backend/init.dart';
import 'package:sas_login_app/ui/scan_screen.dart';
import 'package:sas_login_app/ui/templates.dart';

class FileSelectorScreen extends StatefulWidget {
  const FileSelectorScreen({super.key});
  @override
  _FileSelectorScreenState createState() => _FileSelectorScreenState();
}

class _FileSelectorScreenState extends State<FileSelectorScreen> {
  XFile? file;

  @override
  Widget build(BuildContext context) {
    return MainFrame(
      headline: const Text('Schülerliste hochladen'),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          (file != null) ? Text('Du hast diese Datei ausgewählt:\n${file!.name}' , textAlign: TextAlign.center) : const Text('Wähle die Schülerliste aus, die du hochladen möchtest.', textAlign: TextAlign.center),
          (file == null) ? CupertinoButton(
            color: CupertinoColors.activeBlue,
            child: const Text('Datei auswählen', style: TextStyle(color: CupertinoColors.white)),
            onPressed: () async {
              const XTypeGroup typeGroup = XTypeGroup(
                label: 'csv',
                extensions: <String>['csv'],
              );
              final XFile? selectedFile = await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
              if (selectedFile != null) {
                try {
                  final path = selectedFile.path;
                  //TODO: Add your code here
                } catch (e) {
                  if (!context.mounted) return;
                  //Show snack bar with error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Fehler beim Lesen der Datei: $e'),
                    backgroundColor: CupertinoColors.systemRed,
                  ));
                  return;
                }
                setState(() {
                  file = selectedFile;
                });
              }
            },
          ) : CupertinoButton(
            color: CupertinoColors.activeGreen,
            child: const Text('Starten', style: TextStyle(color: CupertinoColors.white)),
            onPressed: () {
              if (file == null) {
                // TODO: error handling
              }
              initFile(file!.path);
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (BuildContext context) => ScanScreen()
              ));
            },
          ),
        ],
      ),
    );
  }
}