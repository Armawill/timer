import 'package:hive_flutter/adapters.dart';
import 'package:timer/model/timer.dart';

/// As local storage uses Hive
class LocalStorageService {
  static const _timerBox = 'TimerBox';

  static Future<void> initialize() async {
    await Hive.initFlutter();
  }

  /// Add timer to the Hive box
  static void add(Timer timer) async {
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
      list.add(value);
    });
    // box.close();
    return list;
  }
}

class TimerAdapter extends TypeAdapter<Timer> {
  final _typeId = 0;

  @override
  int get typeId => _typeId;

  @override
  Timer read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final hours = reader.readInt();
    final minutes = reader.readInt();
    final seconds = reader.readInt();
    return Timer(
      id: id,
      title: title,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  @override
  void write(BinaryWriter writer, Timer obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeInt(obj.hours);
    writer.writeInt(obj.minutes);
    writer.writeInt(obj.seconds);
  }
}
