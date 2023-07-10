import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:timer/services/local_storage_service.dart';
import 'package:uri_to_file/uri_to_file.dart';

class OverlayService {
  static final AudioPlayer audioPlayer = AudioPlayer();
  static Future initialize() async {
    bool status = await FlutterOverlayWindow.isPermissionGranted();
    if (!status) {
      await FlutterOverlayWindow.requestPermission();
    }
  }

  static Future<void> play() async {
    var sound = await LocalStorageService.getOverlaySound();

    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    print('sound $sound');
    if (sound.isFromAsset) {
      await audioPlayer.play(AssetSource(sound.assetPath!));
    } else if (sound.isFromUri) {
      File file = await toFile(sound.uri!);
      await audioPlayer.play(DeviceFileSource(file.path));
    } else {
      await audioPlayer
          .play(AssetSource('audio/musical_alert_notification.wav'));
    }
  }

  static Future<void> stop() async {
    await audioPlayer.stop();
  }

  static void show() async {
    FlutterOverlayWindow.showOverlay(
      alignment: OverlayAlignment.topCenter,
      height: 530,
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
