import 'package:flutter/material.dart';

import '../model/timer.dart';

class EditTimerViewModel with ChangeNotifier {
  var _time = DateTime(0, 0, 0, 0, 15, 0);
  String _title = 'Timer';

  DateTime get time => _time;

  String get title => _title;

  void onTimeSelect(DateTime time) {
    _time = time;
    notifyListeners();
  }
}
