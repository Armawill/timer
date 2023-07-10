import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

class RingtoneService {
  static List<Ringtone> _ringtones = [];

  static List<Ringtone> get ringtones => _ringtones;
  static Future<List<Ringtone>> loadSound() async {
    try {
      _ringtones = await FlutterSystemRingtones.getRingtoneSounds();
      return _ringtones;
    } on PlatformException {
      debugPrint('Failed to get platform version.');
      throw (PlatformException);
    }
  }
}
