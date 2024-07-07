import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_login_app/backend/init.dart';
import 'package:sas_login_app/ui/templates.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  static const double minimalTime = 0.01;

  @override
  Widget build(BuildContext context) {
    final List<TimeStudent> data = getTimeList();
    final List<String> days = getDays();

    final List<TableRow> children = [];
    for (int i = 0; i < data.length; i++) {
      if (i == 0 || data[i-1].className != data[i].className) {
        //Summerize the times of the next class
        children.add(
            TableRow(
              decoration: const BoxDecoration(
                color: Colors.orange,
              ),
              children: [
                TableCell(child: Text(data[i].className, textAlign: TextAlign.center)),
                const TableCell(child: Text("Summe")),
                ...List.generate(days.length, (index) {
                  int sum = 0;
                  int all = 0;
                  for (int j = i; j < data.length; j++) {
                    if (data[j].className != data[i].className) {
                      break;
                    }
                    if (data[j].times[index] >= minimalTime) {
                      sum += 1;
                    }
                    all += 1;
                  }
                  return TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        child: ColoredBox(
                            color: (sum == all) ? Colors.green : Colors.red,
                            child: Text("$sum/$all", textAlign: TextAlign.center)
                        ),
                      )
                  );
                }),
              ]
            )
        );
      }
      children.add(
          TableRow(
            decoration: BoxDecoration(
              color: (i % 2 == 0) ? Colors.grey[800] : null,
            ),
            children: [
              TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(data[i].className, textAlign: TextAlign.center)),
              TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: Text(data[i].name)),
              ...data[i].times.map((f) => TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.0),
                    child: ColoredBox(
                        color: (f < minimalTime) ? Colors.red : Colors.green,
                        child: Text(f.toStringAsFixed(2), textAlign: TextAlign.center)
                    ),
                  )
                )
              )
            ]
          )
      );
    }

    return MainFrame(
        small: true,
        headline: const Text("Aktuelle Statistik"),
        child: (data.isNotEmpty) ? SingleChildScrollView(
          child: Table(
            children: [
              TableRow(
                children: [
                  const TableCell(child: Text("Klasse", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                  const TableCell(child: SizedBox(child: Text("Name", overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false, style: TextStyle(fontWeight: FontWeight.bold)))),
                  ...days.map((e) => TableCell(child: SizedBox(child: Text(e, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)))),
                ]
              ),
              ...children
            ],
          ),
        ) :  const Center(
          child: Text("Bisher wurden keine Daten eingetragen"),
        )
    );
  }
}

/*
              TableRow(
                children: [
                  const Text("Klasse", overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false, style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text("Name", overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false, style: TextStyle(fontWeight: FontWeight.bold)),
                  ...days.map((e) => Text(e, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false, style: TextStyle(fontWeight: FontWeight.bold)))
                ]
              ),
              ...data.map((e) => TableRow(
                children: [
                  Text(e.className),
                  Text(e.name),
                  ...e.times.map((f) => Text(f.toStringAsFixed(2)))
                ]
              ))

 */
