import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/timer_view_model.dart';

class CircularTimerButton extends StatefulWidget {
  final String id;
  final String title;
  final int hours;
  final int minutes;
  final int seconds;
  const CircularTimerButton({
    super.key,
    required this.title,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.id,
  });

  @override
  State<CircularTimerButton> createState() => _CircularTimerButtonState();
}

class _CircularTimerButtonState extends State<CircularTimerButton> {
  @override
  Widget build(BuildContext context) {
    var isSelected =
        Provider.of<TimerViewModel>(context).currentTimerId == widget.id;
    return SizedBox(
      height: 100,
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          var selectedTime =
              DateTime(0, 0, 0, widget.hours, widget.minutes, widget.seconds);
          Provider.of<TimerViewModel>(context, listen: false)
              .onTimerSelected(selectedTime, widget.id, widget.title);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor:
              isSelected ? Colors.red.shade100 : Colors.grey.shade100,
          foregroundColor: isSelected ? Colors.red : Colors.black,
          elevation: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 5),
            _Time(
              hours: widget.hours,
              minutes: widget.minutes,
              seconds: widget.seconds,
            ),
          ],
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int hours;
  final int minutes;
  final int seconds;
  const _Time({
    super.key,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    String h = hours.toString();
    String m = minutes.toString();
    String s = seconds.toString();
    if (hours < 10) {
      h = '0$h';
    }
    if (minutes < 10) {
      m = '0$m';
    }
    if (seconds < 10) {
      s = '0$s';
    }
    return Text(
      '$h:$m:$s',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
