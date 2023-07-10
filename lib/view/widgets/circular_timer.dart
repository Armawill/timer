import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/timer_view_model.dart';

class CircularTimer extends StatefulWidget {
  const CircularTimer({super.key});

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  // OverlayEntry? entry;
  void printTimeWithTitle(Duration duration, String title) {
    print('$duration/n$title');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const paddingTop = 40.0;
    // final timerWidth = MediaQuery.of(context).size.width * 0.8;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: paddingTop),
          child: CircularCountDownTimer(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            initialDuration: 0,
            duration: Provider.of<TimerViewModel>(context).getDuration(),
            fillColor: Provider.of<TimerViewModel>(context).isTimerPaused
                ? Colors.red.shade100
                : Colors.red,
            ringColor: Colors.grey.shade300,
            isReverse: true,
            isReverseAnimation: true,
            textStyle: const TextStyle(fontSize: 28),
            controller: Provider.of<TimerViewModel>(context).controller,
            onComplete: () {
              Provider.of<TimerViewModel>(context, listen: false)
                  .onTimerCompleted(context);
            },
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              return Provider.of<TimerViewModel>(context, listen: false)
                  .getRemainingDuration(duration.inSeconds);
            },
            strokeCap: StrokeCap.round,
          ),
        ),
        Positioned.fill(
          top: 120,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              Provider.of<TimerViewModel>(context).currentTimerTitle ?? '',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
