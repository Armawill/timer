import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:timer/services/overlay_service.dart';

class OverlayViewModel extends ChangeNotifier {
  void listenOverlay() {
    FlutterOverlayWindow.overlayListener.listen((data) {
      String time = 'null';
      if (data != null) {
        if (data['time'] != null) {
          time = data['time'];
          setTimeString(time);
          FlutterBackgroundService().invoke('setAsForeground');
        }
      }
    });
  }

  @override
  void dispose() {
    FlutterOverlayWindow.disposeOverlayListener();
  }

  String _timeString = 'null';
  String get timeString {
    return _timeString;
  }

  void setTimeString(String value) {
    _timeString = value;
    notifyListeners();
  }

  ///Closes overlay
  void onStopped() {
    OverlayService.close();
    FlutterBackgroundService().invoke('setAsBackground');
  }
}
