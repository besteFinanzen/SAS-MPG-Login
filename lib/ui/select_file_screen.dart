import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_login_app/backend/init.dart';
import 'package:sas_login_app/ui/templates.dart';

class FileSelectorScreen extends StatefulWidget {
  const FileSelectorScreen({super.key});

  @override
  _FileSelectorScreenState createState() => _FileSelectorScreenState();
}

class _FileSelectorScreenState extends State<FileSelectorScreen> {
  final List<XFile> files = [];

  Future _addFile() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'csv',
      extensions: <String>['csv'],
    );
    final XFile? selectedFile = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    if (selectedFile != null) {
      if (files.contains(selectedFile)) return;
      initFile(await selectedFile.readAsString()).then((val) {
        if (!val) {
          if (!context.mounted) return;
          //Show snack bar with error message
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Fehler beim Lesen der Datei'),
            backgroundColor: CupertinoColors.systemRed,
          ));
        }
      });
      if (context.mounted) {
        setState(() {
          files.add(selectedFile);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainFrame(
      headline: const Text('Schülerliste hochladen'),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          (files.isNotEmpty)
              ? (files.length == 1) ? Text('Du hast diese Datei ausgewählt:\n${files.first.name}',
                  textAlign: TextAlign.center)
                : Text('Du hast diese Dateien ausgewählt:\n${files.map((e) => e.name).join(", ")}',
                    textAlign: TextAlign.center)
              : const Text(
                  'Wähle die Schülerliste aus, die du hochladen möchtest.',
                  textAlign: TextAlign.center),
          (files.isEmpty)
              ? CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  onPressed: _addFile,
                  child: const Text('Datei auswählen',
                      style: TextStyle(color: CupertinoColors.white)),
                )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: CupertinoButton(
                      color: CupertinoColors.systemRed,
                      onPressed: _addFile,
                      child: const Text('Weitere Datei hinzufügen',
                          style: TextStyle(color: CupertinoColors.white))
                    ),
                  ),
                  Flexible(
                    child: CupertinoButton(
                        color: CupertinoColors.activeGreen,
                        child: const Text('Starten',
                            style: TextStyle(color: CupertinoColors.white)),
                        onPressed: () => Navigator.of(context).pushNamed("/scan"),
                      ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
