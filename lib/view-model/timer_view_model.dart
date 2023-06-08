import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timer/model/notification_service.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:timer/model/overlay_service.dart';
import 'package:timer/model/timer.dart';

void createIsolate(List<Object> args) async {
  final rootIsolateToken = args[0] as RootIsolateToken;
  final delay = args[1] as int;
  final time = args[2] as String;
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  Future.delayed(Duration(milliseconds: delay), () {
    OverlayService.shareData({
      'time': time,
    });

    OverlayService.show();
    // NotificationService.showNotification(
    //   id: 0,
    //   title: 'Timer',
    //   body: 'Timer will end at ',
    // );
  });

  // });
}

class TimerViewModel with ChangeNotifier {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  late Isolate isolate;
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

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

  void onTimerCancel() {
    _isTimerCanceled = true;
    _countDownController.reset();
    isolate.kill();
    NotificationService.cancelAllNotifications();
    notifyListeners();
  }

  void onTimerPause() {
    _countDownController.pause();
    isolate.kill();
    _newDuration = DateTime.now().difference(_targetTime).inMilliseconds.abs();
    log('pause ${_newDuration}');
    // NotificationService.cancelAllNotifications();
    notifyListeners();
  }

  void onTimerResume() async {
    _countDownController.resume();
    _targetTime = DateTime.now().add(Duration(milliseconds: _newDuration));
    isolate = await Isolate.spawn(createIsolate, [
      rootIsolateToken,
      _newDuration,
      getTimeString(),
    ]);
    notifyListeners();
  }

  void overlayIsolate(int duration) async {
    isolate = await Isolate.spawn(createIsolate, [
      rootIsolateToken,
      duration,
      getTimeString(),
    ]);
  }

  void onTimerStart() async {
    _isTimerCanceled = false;
    _isTimerStarted = true;
    // showNotification();
    var targetTime =
        DateTime.now().add(Duration(milliseconds: getDurationInMilliseconds()));
    log('Duration ${getDuration() * 1000}');
    log('targetTime $targetTime');
    _targetTime = targetTime;
    overlayIsolate(getDuration() * 1000);
    notifyListeners();
  }

  void onTimerCompleted(BuildContext context) async {
    _isTimerStarted = false;

    if (!_isTimerCanceled) {
      NotificationService.cancelAllNotifications();
    }

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

  // NotificationService.showScheduledNotification(
  //   title: 'Timer done',
  //   body: timeString,
  //   payload: 'Timer',
  //   scheduledDate: scheduledDate,
  // );
  // }
}
