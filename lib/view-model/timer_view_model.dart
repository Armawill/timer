import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '../model/timer.dart';

class TimerViewModel with ChangeNotifier {
  var _time = DateTime(0, 0, 0, 0, 0, 10);
  var _isTimerStarted = false;
  String? currentTimerTitle;
  String? currentTimerId;

  final CountDownController _countDownController = CountDownController();
  CountDownController get controller => _countDownController;
  bool get isTimerPaused => _countDownController.isPaused;

  DateTime get time => _time;

  List<Timer> timerList = [
    Timer(id: 't1', title: 'Plank', hours: 0, minutes: 2, seconds: 0),
    Timer(id: 't2', title: 'Test', hours: 0, minutes: 5, seconds: 0),
    Timer(id: 't3', title: 'Other', hours: 0, minutes: 10, seconds: 0),
    Timer(id: 't4', title: 'Timer', hours: 1, minutes: 0, seconds: 0),
    Timer(id: 't5', title: 'Gym', hours: 0, minutes: 0, seconds: 40),
    Timer(id: 't6', title: 'Test 2', hours: 0, minutes: 0, seconds: 10),
    Timer(id: 't7', title: 'Test 3', hours: 0, minutes: 15, seconds: 0),
  ];

  List<List<Timer>> getPages() {
    int pageCount = (timerList.length / 6).ceil();

    List<List<Timer>> pages = [];
    for (var i = 0; i < pageCount; i++) {
      List<Timer> subList;
      if (i == 0) {
        subList = timerList.sublist(i, 6);
      } else if (i == pageCount - 1) {
        subList = timerList.sublist(i * 6);
      } else {
        subList = timerList.sublist(i * 6, i * 6 + 6);
      }
      pages.add(subList);
    }
    return pages;
  }

  int getDuration() {
    final timestamp = _time.second + _time.minute * 60 + _time.hour * 3600;
    return timestamp;
  }

  bool get isTimerStarted => _isTimerStarted;

  void onTimerAdded(String title) {
    timerList.add(
      Timer(
        id: DateTime.now().toIso8601String(),
        title: title,
        hours: time.hour,
        minutes: time.minute,
        seconds: time.second,
      ),
    );
    notifyListeners();
  }

  void onTimerSelected(DateTime selectedTime, [String? id, String? title]) {
    _time = selectedTime;
    currentTimerTitle = title;
    currentTimerId = id;
    notifyListeners();
  }

  void onTimerCancel() {
    _countDownController.reset();
    notifyListeners();
  }

  void onTimerPause() {
    _countDownController.pause();
    notifyListeners();
  }

  void onTimerResume() {
    _countDownController.resume();
    notifyListeners();
  }

  void onTimerStart() {
    _isTimerStarted = true;
    notifyListeners();
  }

  void onTimerCompleted() {
    _isTimerStarted = false;
    notifyListeners();
  }
}
