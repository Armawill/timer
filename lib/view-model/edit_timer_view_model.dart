import 'package:flutter/material.dart';

class EditTimerViewModel with ChangeNotifier {
  var _time = DateTime(0, 0, 0, 0, 15, 0);
  String _title = 'Timer';
  String _timeString = 'null';
  bool _isShow = false;

  bool get isShow => _isShow;

  set isShow(bool value) => _isShow = value;

  DateTime get time => _time;

  String get title => _title;

  String get timeString {
    return _timeString;
  }

  void setTimeString(String value) {
    _timeString = value;
    notifyListeners();
  }

  void onTimeSelect(DateTime time) {
    _time = time;
    notifyListeners();
  }

  void setTitle(String title) {
    _title = title;
    // notifyListeners();
  }
}
