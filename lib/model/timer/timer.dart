import 'package:hive/hive.dart';

part 'timer.g.dart';

@HiveType(typeId: 1)
class Timer {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int hours;

  @HiveField(3)
  final int minutes;

  @HiveField(4)
  final int seconds;

  @HiveField(5)
  final bool isChecked;

  Timer({
    required this.id,
    required this.title,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.isChecked,
  });

  Timer copyWith({
    String? id,
    String? title,
    int? hours,
    int? minutes,
    int? seconds,
    bool? isChecked,
  }) {
    return Timer(
      id: id ?? this.id,
      title: title ?? this.title,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
