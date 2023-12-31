import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/services/local_storage_service.dart';
import 'package:timer/services/notification_service.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:timer/services/overlay_service.dart';
import 'package:timer/model/timer/timer.dart';

class TimerViewModel with ChangeNotifier {
  TimerViewModel() {
    loadTimers();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  var _time = DateTime(0, 0, 0, 0, 0, 10);
  var _isTimerStarted = false;
  var _isEditMode = false;

  /// [_isCheckedAll] is true, if all timers are checked
  var _isCheckedAll = false;

  /// [_isAnyTimerChecked] is true, if any timer is checked
  var _isAnyTimerChecked = false;

  /// It is needed to animate start button and delete button. [_isModeChanged] is true, if if edit mode was called.
  var _isModeChanged = false;

  // var _isTimerStateChanged = false;
  String? currentTimerTitle;
  String? currentTimerId;
  DateTime _targetTime = DateTime.now();
  int _newDuration = 0;
  int _countOfCheckedTimers = 0;
  int _selectedPage = 0;

  List<Timer> timerList = [
    // Timer(id: 't1', title: 'Plank', hours: 0, minutes: 0, seconds: 2),
    // Timer(id: 't2', title: 'Test', hours: 0, minutes: 5, seconds: 0),
    // Timer(id: 't3', title: 'Other', hours: 0, minutes: 10, seconds: 0),
    // Timer(id: 't4', title: 'Timer', hours: 1, minutes: 0, seconds: 0),
    // Timer(id: 't5', title: 'Gym', hours: 0, minutes: 0, seconds: 40),
    // Timer(id: 't6', title: 'Test 2', hours: 0, minutes: 0, seconds: 10),
    // Timer(id: 't7', title: 'Test 3', hours: 0, minutes: 15, seconds: 0),
  ];
  final PageController _pageController = PageController(initialPage: 0);
  final CountDownController _countDownController = CountDownController();

  int get selectedPage => _selectedPage;

  int get countOfCheckedTimers => _countOfCheckedTimers;

  PageController get pageController => _pageController;

  CountDownController get controller => _countDownController;

  bool get isTimerStarted => _isTimerStarted;

  bool get isTimerPaused => _countDownController.isPaused;

  bool get isEditMode => _isEditMode;

  // bool get isTimerCanceled => _isTimerCanceled;

  /// It is needed to animate start button and delete button. [_isModeChanged] is true, if if edit mode was called.
  bool get isModeChanged => _isModeChanged;

  /// [isCheckedAll] is true, if all timers are checked
  bool get isCheckedAll => _isCheckedAll;

  /// [isAnyTimerChecked] is true, if any timer is checked
  bool get isAnyTimerChecked => _isAnyTimerChecked;

  // bool get isTimerStateChanged => _isTimerStateChanged;

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

  /// Loads timers from local storage
  void loadTimers() async {
    timerList = await LocalStorageService.loadTimers();
    notifyListeners();
  }

  /// Returns list of pages which contain timer list
  List<List<Timer>> getPages() {
    int pageCount = _isEditMode
        ? (timerList.length / 6).ceil()
        : ((timerList.length + 1) / 6).ceil();

    List<List<Timer>> pages = [];
    for (var i = 0; i < pageCount; i++) {
      if (i * 6 < timerList.length) {
        List<Timer> subList;
        if (i == 0) {
          if (timerList.length >= 6) {
            subList = timerList.sublist(i, 6);
          } else {
            subList = timerList;
          }
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

  void onPageChanged(int page) {
    _selectedPage = page;
    notifyListeners();
  }

  ///Return duration in seconds
  int getDuration() {
    final timestamp = (_time.second + _time.minute * 60 + _time.hour * 3600);
    return timestamp;
  }

  ///Return duration in milliseconds
  int getDurationInMilliseconds() {
    final timestamp =
        (_time.second + _time.minute * 60 + _time.hour * 3600) * 1000;
    return timestamp;
  }

  void onModeChanged() {
    if (_isModeChanged) {
      _isEditMode = !_isEditMode;
    }
    _isModeChanged = false;
    notifyListeners();
  }

  void turnOnEditMode([String? id]) {
    if (id != null) {
      changeCheckState(id, true);
    }
    // _isEditMode = true;
    _isModeChanged = true;
    notifyListeners();
  }

  void turnOffEditMode() {
    // _isEditMode = false;
    _isModeChanged = true;
    _isCheckedAll = false;
    _uncheckAll();
    notifyListeners();
  }

  ///Changes [isChecked] param of all timers
  void changeAllCheckState(bool? value) {
    if (value != null) {
      _isCheckedAll = value;
      if (value) {
        _checkAll();
      } else {
        _uncheckAll();
      }
      notifyListeners();
    }
  }

  void _checkAll() {
    for (var i = 0; i < timerList.length; i++) {
      timerList
          .replaceRange(i, i + 1, [timerList[i].copyWith(isChecked: true)]);
    }
    _isAnyTimerChecked = true;
    _countOfCheckedTimers = timerList.length;
  }

  void _uncheckAll() {
    for (var i = 0; i < timerList.length; i++) {
      if (timerList[i].isChecked) {
        timerList
            .replaceRange(i, i + 1, [timerList[i].copyWith(isChecked: false)]);
      }
    }
    _isAnyTimerChecked = false;
    _countOfCheckedTimers = 0;
  }

  ///Changes [isChecked] param of timer by id
  void changeCheckState(String id, bool value) {
    var timer = timerList.firstWhere((item) => item.id == id);
    int index = timerList.indexWhere((item) => item.id == id);
    timerList
        .replaceRange(index, index + 1, [timer.copyWith(isChecked: value)]);
    if (value) {
      _countOfCheckedTimers++;
    } else {
      _countOfCheckedTimers--;
    }

    if (timerList.every((element) => element.isChecked)) {
      _isCheckedAll = true;
    } else {
      _isCheckedAll = false;
    }

    if (timerList.every((element) => !element.isChecked)) {
      _isAnyTimerChecked = false;
    } else {
      if (!_isAnyTimerChecked) {
        _isAnyTimerChecked = true;
      }
    }
    notifyListeners();
  }

  void onTimerAdded(String title, DateTime time) {
    var id = DateTime.now().toIso8601String();
    final timer = Timer(
      id: id,
      title: title,
      hours: time.hour,
      minutes: time.minute,
      seconds: time.second,
      isChecked: false,
    );
    timerList.add(
      timer,
    );
    LocalStorageService.saveTimer(timer);
    currentTimerId = id;
    currentTimerTitle = title;
    onTimerSelected(time);
    notifyListeners();
  }

  void onTimerEdited(String id, String title, DateTime time) {
    var index = timerList.indexWhere((element) => element.id == id);
    var timer = timerList.elementAt(index).copyWith(
          title: title,
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
        );
    timerList.replaceRange(index, index + 1, [timer]);
    _time = time;
    LocalStorageService.saveTimer(timer);
    notifyListeners();
  }

  void onTimerDeleted() {
    timerList.removeWhere((element) {
      if (element.isChecked) {
        LocalStorageService.deleteTimer(element.id);
      }
      return element.isChecked;
    });
    // _isEditMode = false;
    _isModeChanged = true;
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
    _isTimerStarted = true;
    // _isTimerStateChanged = true;
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
    // _isTimerStateChanged = true;
    notifyListeners();
  }

  // void onTimerStateChanged() {
  //   if (_isTimerStateChanged) {
  //     _isTimerStarted = !_isTimerStarted;
  //   }
  //   _isTimerStateChanged = false;
  //   notifyListeners();
  // }

  // Future<void> showNotification() async {
  //   var targetTime =
  //       DateTime.now().add(Duration(milliseconds: getDurationInMilliseconds()));
  //   NotificationService.showNotification(
  //     id: 0,
  //     title: 'Timer',
  //     body: 'Timer will end at ${DateFormat.Hms().format(targetTime)}',
  //   );
  // }
}
