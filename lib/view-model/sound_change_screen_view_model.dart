import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/model/sound/sound.dart';
import 'package:timer/services/file_picker_service.dart';
import 'package:timer/services/local_storage_service.dart';
import 'package:timer/services/ringtone_service.dart';
import 'package:uri_to_file/uri_to_file.dart';

const _isCustomSoundKey = 'isCustomSound';

class SoundChangeScreenViewModel extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();

  final List<Sound> _soundList = [];

  String _customSound = '';

  bool _isCustomSound = false;

  Sound _selectedSound = Sound.empty();

  Sound get selectedSound => _selectedSound;

  String get customSound => _customSound;

  List<Sound> get soundList => _soundList;

  bool get isCustomSound => _isCustomSound;

  void loadSettings() async {
    _selectedSound = await LocalStorageService.loadSoundSettings();
    // await getSounds();
  }

  /// Loads sounds from asset and system alarm sounds
  Future<void> getSounds() async {
    if (_soundList.isEmpty) {
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      json.decode(manifestJson).keys.forEach((String key) {
        if (key.startsWith('assets/audio')) {
          if (!_soundList.any((element) =>
              (element.isFromAsset && 'assets/${element.assetPath}' == key))) {
            var title = key.replaceAll(RegExp('assets/audio/'), '');
            title = title.replaceAll(RegExp('_'), ' ');
            title = title.replaceAll(RegExp('.wav'), '');
            var path = key.replaceAll('assets/', '');
            _soundList.add(Sound.fromAsset(title: title, assetPath: path));
          }
        }
      });

      var alarmList = await RingtoneService.loadSound();
      for (var element in alarmList) {
        if (!_soundList
            .any((sound) => (sound.isFromUri && element.id == sound.id))) {
          _soundList.add(Sound.fromUri(
              id: element.id, title: element.title, uri: element.uri));
        }
      }
    }

    _selectedSound = await LocalStorageService.loadSoundSettings();
    var prefs = await SharedPreferences.getInstance();
    _selectedSound = await LocalStorageService.loadSoundSettings();

    var isCustomSoundTemp = prefs.getBool(_isCustomSoundKey);
    _isCustomSound = isCustomSoundTemp ?? false;

    if (_selectedSound.id == '') {
      _selectedSound = _soundList[0];
      LocalStorageService.saveSound(_selectedSound);
    }

    notifyListeners();
  }

  List<Sound> getSystemSounds() {
    List<Sound> systemSoundList = [];
    for (var sound in _soundList) {
      if (sound.isFromUri) {
        systemSoundList.add(sound);
      }
    }
    return systemSoundList;
  }

  List<Sound> getAppSounds() {
    List<Sound> appSoundList = [];
    for (var sound in _soundList) {
      if (sound.isFromAsset) {
        appSoundList.add(sound);
      }
    }
    return appSoundList;
  }

  void setCustomSound() async {
    var prefs = await SharedPreferences.getInstance();
    FilePickerService.initialize();
    var filePath = await FilePickerService.pickFile();

    if (filePath != 'not found') {
      var index = filePath.lastIndexOf('/');
      _customSound = filePath.substring(index + 1);
      _isCustomSound = true;
      _selectedSound =
          Sound.fromUri(id: 'custom', title: _customSound, uri: filePath);
      prefs.setBool(_isCustomSoundKey, _isCustomSound);
      LocalStorageService.saveSound(_selectedSound);
      audioPlayer.setReleaseMode(ReleaseMode.release);
      File soundFile = await toFile(_selectedSound.uri!);
      audioPlayer.play(DeviceFileSource(soundFile.path));
    }

    notifyListeners();
  }

  void playSelectedSound(String id) async {
    var sound = _soundList.firstWhere((element) => element.id == id);

    audioPlayer.setReleaseMode(ReleaseMode.release);
    _selectedSound = sound;
    LocalStorageService.saveSound(sound);

    if (sound.isFromAsset) {
      audioPlayer.play(AssetSource(sound.assetPath!));
    } else {
      File soundFile = await toFile(sound.uri!);
      audioPlayer.play(DeviceFileSource(soundFile.path));
    }

    if (_isCustomSound) {
      _isCustomSound = false;
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool(_isCustomSoundKey, _isCustomSound);
    }

    notifyListeners();
  }

  void stopPlayback() async {
    await audioPlayer.stop();
  }
}
