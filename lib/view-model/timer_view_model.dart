import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerViewModel with ChangeNotifier {
  var _time = DateTime(0, 0, 0, 0, 0, 10);
  var _isTimerStarted = false;

  DateTime get time => _time;
  // set time(DateTime time) {
  //   _time = time;
  //   notifyListeners();
  // }

  int getDuration() {
    final timestamp = _time.second + _time.minute * 60 + _time.hour * 3600;
    return timestamp;
  }

  void setTime(DateTime time) {
    _time = time;
    notifyListeners();
  }

  bool get isTimerStarted => _isTimerStarted;

  void onTimerStarted() {
    _isTimerStarted = true;
    notifyListeners();
  }

  void onTimerCompleted() {
    _isTimerStarted = false;
    notifyListeners();
  }
}
