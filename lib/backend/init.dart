import 'dart:io';

import 'package:intl/intl.dart';

late File _file;
String _delimiter = ";";
List<String> _types = [];
List<List<String>> _data = [];

Future initBeforeShowingUI() async {

}

Future initFile(String path, [String delimiter = ";"]) async {
  _delimiter = delimiter;
  _file = File(path);
  final lines = await _file.readAsLines();
  print(lines.join("\n"));
  if (lines.isEmpty) {
    throw Exception("File is empty");
  }
  _types = lines[0].split(delimiter);
  for (int i = 1; i < lines.length; i++) {
    final values = lines[i].split(delimiter);
    _data.add(values);
  }
}

void saveFile() {
  String content = _types.join(_delimiter);
  for (int i = 0; i < _data.length; i++) {
    content += "\n${_data[i].join(_delimiter)}";
  }
  print(content);
  _file.writeAsString(content);
}

Future initAfterShowingUI() async {
  //TODO: Add your code here
}

void onCode(int code, String checkType) {
  final now = DateTime.now();
  String time = DateFormat.yMd().format(now);
  int idx = -1;
  for (int i = 0; i < _types.length; i++) {
    if (time == _types[i]) {
      idx = i;
      break;
    }
  }
  if (idx == -1) {
    idx = _types.length;
    _types.add(time);
    for (int i=0; i < _data.length; i++) {
      _data[i].add("");
    }
  }

  if (code >= _data.length) {
    throw Exception("Invalid code");
  }

  if (idx >= _data[code].length) {
    throw Exception("Invalid code");
  }
  String checks = _data[code][idx];
  checks += "$checkType:${now.hour}-${now.minute};";
  _data[code][idx] = checks;
  saveFile();
}

