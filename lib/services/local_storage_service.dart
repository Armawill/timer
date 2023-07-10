import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import 'package:timer/model/sound/sound.dart';
import 'package:timer/model/timer/timer.dart';

/// As local storage uses Hive
class LocalStorageService {
  static const _timerBox = 'TimerBox';
  static const _soundBox = 'SoundBox';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(TimerAdapter().typeId)) {
      Hive.registerAdapter(TimerAdapter());
    }
    if (!Hive.isAdapterRegistered(SoundAdapter().typeId)) {
      Hive.registerAdapter(SoundAdapter());
    }
    // clearSoundSettings();
  }

  /// Loads saved timers from Hive
  static Future<List<Timer>> loadTimers() async {
    if (!Hive.isAdapterRegistered(TimerAdapter().typeId)) {
      Hive.registerAdapter(TimerAdapter());
    }

    var box = await Hive.openBox<Timer>(_timerBox);
    List<Timer> list = [];
    box.toMap().forEach((key, value) {
      if (value.isChecked) {
        value = value.copyWith(isChecked: false);
      }
      list.add(value);
    });
    // box.close();
    return list;
  }

  /// Add timer to the Hive box
  static void saveTimer(Timer timer) async {
    var box = await Hive.openBox<Timer>(_timerBox);
    await box.put(timer.id, timer);
    // box.close();
  }

  /// Delete timer from Hive box by id
  static void deleteTimer(String id) async {
    var box = await Hive.openBox<Timer>(_timerBox);
    box.delete(id);
    // box.close();
  }

  /// Removes all entries
  static void clearTimerList() async {
    var box = await Hive.openBox<Timer>(_timerBox);
    box.clear();
    // box.close();
  }

  static Future<Sound> getOverlaySound() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(documentDirectory.path);
    if (!Hive.isAdapterRegistered(SoundAdapter().typeId)) {
      Hive.registerAdapter(SoundAdapter());
    }

    var box = await Hive.openBox<Sound>(_soundBox);

    Sound sound;

    if (box.values.isNotEmpty) {
      sound = box.values.last;
    } else {
      sound = Sound.empty();
    }
    box.close();
    return sound;
  }

  static Future<Sound> loadSoundSettings() async {
    if (!Hive.isAdapterRegistered(SoundAdapter().typeId)) {
      Hive.registerAdapter(SoundAdapter());
    }

    var box = await Hive.openBox<Sound>(_soundBox);
    Sound sound;
    if (box.values.isNotEmpty) {
      sound = box.values.last;
    } else {
      sound = Sound.empty();
    }

    return sound;
  }

  static void saveSound(Sound sound) async {
    var box = await Hive.openBox<Sound>(_soundBox);
    await box.put(selectedSoundKey, sound);
  }

  static void clearSoundSettings() async {
    var box = await Hive.openBox<Sound>(_soundBox);
    box.clear();
  }
}
