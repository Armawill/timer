import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/timer_view_model.dart';

class TimerTab extends StatefulWidget {
  const TimerTab({super.key});

  @override
  State<TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Provider.of<TimerViewModel>(context).isTimerStarted
            ? const _CircularTimer()
            : const _TimeSpinner(),
        const _SavedTimers(),
        const _StartButton(),
      ],
    );
  }
}

class _CircularTimer extends StatelessWidget {
  const _CircularTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: CircularCountDownTimer(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        initialDuration: 0,
        duration: Provider.of<TimerViewModel>(context).getDuration(),
        fillColor: Colors.red,
        ringColor: Colors.grey.shade300,
        isReverse: true,
        isReverseAnimation: true,
        textStyle: const TextStyle(fontSize: 28),
        onComplete: () => Provider.of<TimerViewModel>(context, listen: false)
            .onTimerCompleted(),
      ),
    );
  }
}

class _TimeSpinner extends StatelessWidget {
  const _TimeSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimePickerSpinner(
      is24HourMode: true,
      normalTextStyle: const TextStyle(fontSize: 24, color: Colors.grey),
      highlightedTextStyle: const TextStyle(fontSize: 24, color: Colors.black),
      spacing: 50,
      itemHeight: 80,
      isShowSeconds: true,
      time: Provider.of<TimerViewModel>(context).time,
      isForce2Digits: true,
      onTimeChange: (time) =>
          Provider.of<TimerViewModel>(context, listen: false).setTime(time),
    );
  }
}

class _SavedTimers extends StatelessWidget {
  const _SavedTimers({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: FractionalOffset.bottomCenter,
        padding: EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<TimerViewModel>(context, listen: false)
                  .onTimerStarted();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Start',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
