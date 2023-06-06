import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  static final AudioPlayer audioPlayer = AudioPlayer();
  static Future initialize() async {
    bool status = await FlutterOverlayWindow.isPermissionGranted();
    if (!status) {
      await FlutterOverlayWindow.requestPermission();
    }
  }

  static Future<void> play() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(AssetSource('audio/musical_alert_notification.wav'));
  }

  static Future<void> stop() async {
    await audioPlayer.stop();
  }

  static void show() async {
    FlutterOverlayWindow.showOverlay(
      alignment: OverlayAlignment.topCenter,
      height: 530,
      overlayTitle: 'Timer done',
    );
  }

  static void shareData(Map<String, dynamic> data) async {
    await FlutterOverlayWindow.shareData(data);
  }

  static void close() async {
    stop();
    FlutterOverlayWindow.closeOverlay();
  }
}
