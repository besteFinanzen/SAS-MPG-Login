import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_login_app/backend/init.dart';
import 'package:sas_login_app/ui/stats_screen.dart';

class MainFrame extends StatelessWidget {
  final Widget headline;
  final Widget child;
  final bool small;
  final Color backgroundColor;
  const MainFrame({required this.headline, required this.child, this.backgroundColor = CupertinoColors.systemGreen, this.small = false, super.key});

  @override
  Widget build(BuildContext context) {
    print(hasSavedFile);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (hasSavedFile) PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file),
                    SizedBox(width: 10),
                    Text("Exportieren")
                  ],
                ),
                onTap: () => exportFile(),
              ),
              PopupMenuItem(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.show_chart),
                    SizedBox(width: 10),
                    Text("Statistik")
                  ],
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) => const StatisticScreen()
                ))),
              PopupMenuItem(
                  onTap: () async {
                    final bool? yes = await showCustomErrorDialog(context, "Daten löschen", "Ja", "Sollen wirklich alle Daten gelöscht werden?", falseOptionString: "Nein");
                    if (yes == true) await clearCache();
                    if (!context.mounted) return;
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacementNamed("/file");
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.show_chart),
                      SizedBox(width: 10),
                      Text("Aktuellen Daten löschen")
                    ],
                  )
              )
            ],
          ),
        ],
      ),
      body: CustomDefaultTextStyle(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: (!small) ? MediaQuery.of(context).size.height / 4 : MediaQuery.of(context).size.height / 6,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: const Border(
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

Future<bool?> showCustomErrorDialog(BuildContext context, String title, String trueOptionString, String description, {String? falseOptionString}) async {
  return await showCupertinoDialog<bool?>(context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          if (falseOptionString != null) CupertinoDialogAction(
            child: Text(falseOptionString),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          CupertinoDialogAction(
            child: Text(trueOptionString),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}