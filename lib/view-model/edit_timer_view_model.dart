import 'package:flutter/material.dart';

class EditTimerViewModel with ChangeNotifier {
  var _time = DateTime(0, 0, 0, 0, 15, 0);
  String _title = 'Timer';

  bool _isShow = false;

  bool get isShow => _isShow;

  set isShow(bool value) => _isShow = value;

  DateTime get time => _time;

  String get title => _title;

  void onTimeSelect(DateTime time) {
    _time = time;
    notifyListeners();
  }

  void onTimerSelect(DateTime time, String title) {
    _time = time;
    _title = title;
  }

  void setTitle(String title) {
    _title = title;
    // notifyListeners();
  }
}
