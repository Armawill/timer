import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer/model/notification_service.dart';
import 'package:workmanager/workmanager.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:timer/model/overlay_service.dart';
import 'package:timer/model/timer.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // await Isolate.run(() async {
    // await Future.delayed(
    //   Duration(seconds: 2),
    // () {
    switch (task) {
      case 'timerNotification':
        print("timerNotification was executed. inputData = $inputData");
        if (inputData != null) {
          // if (inputData['time'] != null) {
          //   OverlayService.show();
          // }

          // NotificationService.showNotification(
          //     title: 'timer done', body: inputData['time']);

          // NotificationService.showNotification(
          //   title: inputData['title'],
          //   body: inputData['body'],
          //   actionType: ActionType.KeepOnTop,
          //   category: NotificationCategory.Alarm,
          //   actionButtons: [
          //     NotificationActionButton(
          //       key: 'stop',
          //       label: 'Stop',
          //       actionType: ActionType.SilentAction,
          //     )
          //   ],
          // );
        }

        break;
      default:
    }
    //   },
    // );
    // });
    return Future.value(true);
  });
}

class TimerViewModel with ChangeNotifier {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  var _time = DateTime(0, 0, 0, 0, 0, 10);
  var _isTimerStarted = false;
  var _isTimerCanceled = false;
  String? currentTimerTitle;
  String? currentTimerId;

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

  int getDuration() {
    final timestamp = _time.second + _time.minute * 60 + _time.hour * 3600;
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
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    // SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
    notifyListeners();
  }

  void onTimerCancel() {
    _isTimerCanceled = true;
    _countDownController.reset();
    NotificationService.cancelAllNotifications();
    notifyListeners();
  }

  void onTimerPause() {
    _countDownController.pause();
    // NotificationService.cancelAllNotifications();
    notifyListeners();
  }

  void onTimerResume() {
    _countDownController.resume();

    notifyListeners();
  }

  void onTimerStart() async {
    _isTimerCanceled = false;
    _isTimerStarted = true;
    showNotification();

    notifyListeners();
  }

  void onTimerCompleted(BuildContext context) async {
    _isTimerStarted = false;

    if (!_isTimerCanceled) {
      NotificationService.cancelAllNotifications();
      OverlayService.shareData({
        'time': getTimeString(),
      });

      OverlayService.show();
    }

    // Workmanager().registerOneOffTask(
    //   'notification',
    //   'timerNotification',
    //   inputData: {
    //     'time': getTimeString(),
    //   },
    //   //initialDelay: Duration(seconds: getDuration()),
    // );

    notifyListeners();
  }

  Future<void> showNotification() async {
    var targetTime = DateTime.now().add(Duration(seconds: getDuration()));
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
