import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

String _delimiter = ";";
List<String> _types = [];
List<List<String>> _data = [];
int _nameIdx = -1;
int _classIdx = -1;
late File output;

Future initBeforeShowingUI() async {}

Future<bool> initFile(String content, [String delimiter = ";"]) async {
  getApplicationDocumentsDirectory().then((val) {
    output = File("${val.path}/output.csv");
  });
  _delimiter = delimiter;
  final lines = content.split("\n");
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
  await output.writeAsString(content);
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
  var checksA = checks.split(",");
  var b = false;
  if (checksA.isEmpty) {
    b = false;
  } else if (checksA.last.startsWith(checkType)){
    b = true;
  }
  checks += "$checkType:${now.hour}-${now.minute},";
  _data[code][idx] = checks;
  saveFile();
  Student student = Student(name, className, b);
  return student;
}

class Student {
  String name;
  String className;
  bool confirm;

  Student(this.name, this.className, this.confirm);
}
