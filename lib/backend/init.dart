import 'dart:io';

import 'package:intl/intl.dart';

late String _path;
String _delimiter = ";";
List<String> _types = [];
List<List<String>> _data = [];
int _nameIdx = -1;
int _classIdx = -1;

Future initBeforeShowingUI() async {

}

Future<bool> initFile(String path, [String delimiter = ";"]) async {
  _delimiter = delimiter;
  _path = path;
  final file = File(path);
  final lines = await file.readAsLines();
  if (lines.isEmpty) {
    return true;
  }
  _types = lines[0].split(delimiter);
  for (int i = 1; i < lines.length; i++) {
    final values = lines[i].split(delimiter);
    _data.add(values);
  }
  for (int i = 0; i < _types.length; i++) {
    if (_types[i] == "Klasse") {
      _classIdx = i;
    } else if (_types[i].startsWith("Name")) {
      _nameIdx = i;
    }
  }
  if (_classIdx < 0 || _nameIdx < 0) {
    return false;
  }
  return true;
}

void saveFile() async {
  String content = _types.join(_delimiter);
  for (int i = 0; i < _data.length; i++) {
    content += "\n${_data[i].join(_delimiter)}";
  }
  //_path = "/storage/emulated/0/Documents/Schülerexempel.csv";
  var file = File(_path);
  file = await file.writeAsString(content);
  file = File(_path);
  print(_path);
  print(content + await file.readAsString());
}

Future initAfterShowingUI() async {
  //TODO: Add your code here
}

Student? onCode(int code, String checkType) {
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
    for (int i = 0; i < _data.length; i++) {
      _data[i].add("");
    }
  }

  if (code >= _data.length) {
    return null;
  }

  if (idx >= _data[code].length) {
    return null;
  }
  String name = _data[code][_nameIdx];
  String className = _data[code][_classIdx];
  String checks = _data[code][idx];
  checks += "$checkType:${now.hour}-${now.minute},";
  _data[code][idx] = checks;
  saveFile();
  Student student = Student(name, className, false);
  return student;
}

class Student {
  String name;
  String className;
  bool confirm;

  Student(this.name, this.className, this.confirm);
}