import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_login_app/backend/init.dart';
import 'package:sas_login_app/ui/templates.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TimeStudent> data = getTimeList();
    final List<String> days = getDays();
    return MainFrame(
        headline: const Text("Aktuelle Statistik"),
        child: (data.isNotEmpty) ? SingleChildScrollView(
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text("Klasse"),
                  const Text("Name"),
                  ...days.map((e) => Text(e)),
                ]
              ),
              ...data.map((e) => TableRow(
                children: [
                  Text(e.className),
                  Text(e.name),
                  ...e.times.map((f) => Text(f.toString()))
                ]
              ))
            ],
          ),
        ) :  const Center(
          child: Text("Bisher wurden keine Daten eingetragen"),
        )
    );
  }
}

