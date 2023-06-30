import 'package:hive_flutter/adapters.dart';
import 'package:timer/model/timer.dart';

/// As local storage uses Hive
class LocalStorageService {
  static const _timerBox = 'TimerBox';

  static Future<void> initialize() async {
    await Hive.initFlutter();
  }

  /// Add timer to the Hive box
  static void save(Timer timer) async {
    var box = await Hive.openBox<Timer>(_timerBox);
    await box.put(timer.id, timer);
    // box.close();
  }

  /// Delete timer from Hive box by id
  static void delete(String id) async {
    var box = await Hive.openBox<Timer>(_timerBox);
    box.delete(id);
    // box.close();
  }

  /// Removes all entries
  static void clear() async {
    var box = await Hive.openBox<Timer>(_timerBox);
    box.clear();
    // box.close();
  }

  /// Loads saved timers from Hive
  static Future<List<Timer>> load() async {
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
}
