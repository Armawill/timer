class Timer {
  final String id;
  final String title;
  final int hours;
  final int minutes;
  final int seconds;

  Timer({
    required this.id,
    required this.title,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  Timer copyWith(
      {String? id, String? title, int? hours, int? minutes, int? seconds}) {
    return Timer(
        id: id ?? this.id,
        title: title ?? this.title,
        hours: hours ?? this.hours,
        minutes: minutes ?? this.minutes,
        seconds: seconds ?? this.seconds);
  }
}
