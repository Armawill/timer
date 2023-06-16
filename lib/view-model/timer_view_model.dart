import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/model/notification_service.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:timer/model/overlay_service.dart';
import 'package:timer/model/timer.dart';

class TimerViewModel with ChangeNotifier {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  var _time = DateTime(0, 0, 0, 0, 0, 10);
  var _isTimerStarted = false;
  var _isTimerCanceled = false;
  String? currentTimerTitle;
  String? currentTimerId;
  DateTime _targetTime = DateTime.now();
  int _newDuration = 0;

  final CountDownController _countDownController = CountDownController();
  CountDownController get controller => _countDownController;
  bool get isTimerPaused => _countDownController.isPaused;
  bool get isTimerCanceled => _isTimerCanceled;
  bool _isShow = false;

  bool get isShow => _isShow;

  set isShow(bool value) => _isShow = value;

  DateTime get time => _time;
  String getTimeString() {
    var timeString =
        '${time.hour != 0 ? '${time.hour} h' : ''} ${time.minute != 0 ? '${time.minute} min' : ''} ${time.second != 0 ? '${time.second} sec' : ''}';
    return timeString;
  }

  ///Return remaining duration in seconds
  String getRemainingDuration(int duration) {
    var newDuration = duration;
    if (duration < getDuration()) {
      newDuration = duration + 1;
    }
    final int hours = newDuration ~/ 3600;
    final int minutes = (newDuration % 3600) ~/ 60;
    final int seconds = ((newDuration % 3600) % 60);
    final hoursStr = '${hours < 10 ? '0$hours' : hours}';
    final minutesStr = '${minutes < 10 ? '0$minutes' : minutes}';
    final secondsStr = '${seconds < 10 ? '0$seconds' : seconds}';
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  List<Timer> timerList = [
    Timer(id: 't1', title: 'Plank', hours: 0, minutes: 0, seconds: 2),
    Timer(id: 't2', title: 'Test', hours: 0, minutes: 5, seconds: 0),
    Timer(id: 't3', title: 'Other', hours: 0, minutes: 10, seconds: 0),
    Timer(id: 't4', title: 'Timer', hours: 1, minutes: 0, seconds: 0),
    Timer(id: 't5', title: 'Gym', hours: 0, minutes: 0, seconds: 40),
    Timer(id: 't6', title: 'Test 2', hours: 0, minutes: 0, seconds: 10),
    // Timer(id: 't7', title: 'Test 3', hours: 0, minutes: 15, seconds: 0),
  ];

  List<List<Timer>> getPages() {
    int pageCount = ((timerList.length + 1) / 6).ceil();

    List<List<Timer>> pages = [];
    for (var i = 0; i < pageCount; i++) {
      if (i * 6 < timerList.length) {
        List<Timer> subList;
        if (i == 0) {
          subList = timerList.sublist(i, 6);
        } else if (i == pageCount - 1) {
          subList = timerList.sublist(i * 6);
        } else {
          subList = timerList.sublist(i * 6, i * 6 + 6);
        }
        pages.add(subList);
      } else {
        pages.add([]);
      }
    }
    return pages;
  }

  int _selectedPage = 0;
  int get selectedPage => _selectedPage;

  PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;
  void onPageChanged(int page) {
    _selectedPage = page;
    notifyListeners();
  }

  ///Return duration in seconds
  int getDuration() {
    final timestamp = (_time.second + _time.minute * 60 + _time.hour * 3600);
    return timestamp;
  }

  int getDurationInMilliseconds() {
    final timestamp =
        (_time.second + _time.minute * 60 + _time.hour * 3600) * 1000;
    return timestamp;
  }

  bool get isTimerStarted => _isTimerStarted;

  void onTimerAdded(String title, DateTime time) {
    var id = DateTime.now().toIso8601String();
    timerList.add(
      Timer(
        id: id,
        title: title,
        hours: time.hour,
        minutes: time.minute,
        seconds: time.second,
      ),
    );
    currentTimerId = id;
    currentTimerTitle = title;
    onTimerSelected(time);
    notifyListeners();
  }

  void onTimerSelected(DateTime selectedTime,
      [String? id, String? title]) async {
    _time = selectedTime;
    currentTimerTitle = title;
    currentTimerId = id;

    notifyListeners();
  }

  void onTimerCancel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isShow', false);
    await prefs.setBool('setAsForeground', false);

    _isTimerCanceled = true;
    _countDownController.reset();
    NotificationService.cancelAllNotifications();
    notifyListeners();
  }

  void onTimerPause() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _countDownController.pause();
    _newDuration = DateTime.now().difference(_targetTime).inMilliseconds.abs();
    await prefs.setString('targetTime', 'null');
    notifyListeners();
  }

  void onTimerResume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _countDownController.resume();
    _targetTime = DateTime.now().add(Duration(milliseconds: _newDuration));
    await prefs.setString('targetTime', DateFormat.Hms().format(_targetTime));
    notifyListeners();
  }

  void onTimerStart() async {
    _isTimerCanceled = false;
    _isTimerStarted = true;
    var targetTime =
        DateTime.now().add(Duration(milliseconds: getDurationInMilliseconds()));
    _targetTime = targetTime;

    OverlayService.shareData({
      'time': getTimeString(),
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('targetTime', DateFormat.Hms().format(targetTime));
    await prefs.setString('time', getTimeString());
    await prefs.setInt('duration', getDurationInMilliseconds());
    await prefs.setBool('isShow', true);
    await prefs.setBool('setAsForeground', true);

    notifyListeners();
  }

  void onTimerCompleted(BuildContext context) async {
    _isTimerStarted = false;

    // if (!_isTimerCanceled) {
    //   NotificationService.cancelAllNotifications();
    // }

    notifyListeners();
  }

  Future<void> showNotification() async {
    var targetTime =
        DateTime.now().add(Duration(milliseconds: getDurationInMilliseconds()));
    NotificationService.showNotification(
      id: 0,
      title: 'Timer',
      body: 'Timer will end at ${DateFormat.Hms().format(targetTime)}',
    );
  }
}
