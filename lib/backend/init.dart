import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

String _delimiter = ";";
List<String> _types = [];
List<List<String>> _data = [];
int _nameIdx = -1;
int _classIdx = -1;
File? output;
bool hasSavedFile = false;

Future initBeforeShowingUI() async {
  var val = await getApplicationDocumentsDirectory();
  output = File("${val.path}/output.csv");
  if (await output!.exists()) {
    var content = await output!.readAsString();
    await initFile(content);
    hasSavedFile = true;
  }
}

Future<bool> initFile(String content, [String delimiter = ";"]) async {
  _delimiter = delimiter;
  final lines = content.split("\n");
  if (lines.isEmpty) {
    return true;
  }

  var types = lines[0].replaceAll("\r", "").split(delimiter);
  var data = <List<String>>[];
  var nameIdx = -1;
  var classIdx = -1;
  for (int i = 1; i < lines.length; i++) {
    if (lines[i].isEmpty) {
      continue;
    }
    lines[i] = lines[i].replaceAll("\r", "");
    final values = lines[i].split(delimiter);
    data.add(values);
  }
  //print(data);
  for (int i = 0; i < types.length; i++) {
    if (types[i] == "Klasse") {
      classIdx = i;
    } else if (types[i].startsWith("Name")) {
      nameIdx = i;
    }
  }
  if (classIdx < 0 || nameIdx < 0) {
    return false;
  }
  if (_types.isEmpty && _data.isEmpty) {
    _types = types;
    _data = data;
    _nameIdx = nameIdx;
    _classIdx = classIdx;
  } else {
    var sidx = max(nameIdx, classIdx) + 1;
    for (int i = sidx; i < types.length; i++) {
      var type = types[i];
      int i2 = _types.indexOf(type);
      if (i2 != -1) {
        for (int j = 0; j < min(_data.length, data.length); j++) {
          _data[i2][j] += data[i][j];
        }
      } else {
        _types.add(types[i]);
        _data.add(data[i]);
      }
    }
  }
  hasSavedFile = true;
  return true;
}

void saveFile(File file) async {
  String content = "${_types.join(_delimiter)}\n";
  for (int i = 0; i < _data.length; i++) {
    var row = _data[i].join(_delimiter);
    content += "$row\n";
  }
  await file.writeAsString(content);
}

Future initAfterShowingUI() async {}

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
  } else if (checksA.last.startsWith(checkType)) {
    b = true;
  }
  checks += "$checkType:${now.hour}-${now.minute},";
  _data[code][idx] = checks;
  hasSavedFile = true;
  saveFile(output!);
  Student student = Student(name, className, b);
  return student;
}

List<TimeStudent> getTimeList() {
  List<TimeStudent> students = [];
  int idx = max(_classIdx, _nameIdx) + 1;
  for (int i = 0; i < _data.length; i++) {
    var student = _data[i];
    List<double> times = [];
    for (int j = idx; j < student.length; j++) {
      var time = student[j];
      if (time.isEmpty) {
        times.add(0);
        continue;
      }
      var logs = time.split(",");
      int minutes = 0;
      int lastHour = -1;
      int lastMin = -1;
      for (int k = 0; k < logs.length; k++) {
        if (logs[k].isEmpty) {
          continue;
        }
        var log = logs[k].split(":");
        int hour = int.parse(log[1].split("-")[0]);
        int min = int.parse(log[1].split("-")[1]);
        if (lastMin == -1 && lastHour == -1) {
          if (log[0] == "in") {
            lastHour = hour;
            lastMin = min;
          }
        } else if (log[0] == "out") {
          int m = (hour - lastHour) * 60;
          m += min - lastMin;
          minutes += m;
          lastHour = -1;
          lastMin = -1;
        }
      }
      times.add(minutes / 60);
    }
    var ts = TimeStudent(student[_nameIdx], student[_classIdx], times);
    students.add(ts);
  }
  return students;
}

List<String> getDays() {
  var idx = max(_nameIdx, _classIdx) + 1;
  return _types.sublist(idx);
}

class TimeStudent {
  final String name;
  final String className;
  final List<double> times;

  const TimeStudent(this.name, this.className, this.times);
}

void exportFile() async {
  String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Your File to desired location',
      fileName: "output.csv");

  File returnedFile = File('$outputFile');
  saveFile(returnedFile);
}

Future clearCache() async {
  await output?.delete();
  hasSavedFile = false;
}

class Student {
  String name;
  String className;
  bool confirm;

  Student(this.name, this.className, this.confirm);
}
