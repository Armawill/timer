import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/model/timer.dart';
import 'package:timer/view/widgets/custom_modal_bottom_sheet.dart';
import 'package:timer/view-model/edit_timer_view_model.dart';
import 'package:timer/view-model/timer_view_model.dart';

class CircularTimerButton extends StatefulWidget {
  final Timer timer;
  const CircularTimerButton({
    super.key,
    required this.timer,
  });

  @override
  State<CircularTimerButton> createState() => _CircularTimerButtonState();
}

class _CircularTimerButtonState extends State<CircularTimerButton> {
  @override
  Widget build(BuildContext context) {
    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;
    return isEditMode
        ? Stack(
            fit: StackFit.expand,
            children: [
              _TimerButton(
                timer: widget.timer,
              ),
              Positioned(
                right: -10,
                top: -15,
                child: Checkbox(
                  value: widget.timer.isChecked,
                  onChanged: (value) {
                    if (value != null) {
                      Provider.of<TimerViewModel>(context, listen: false)
                          .changeCheckState(widget.timer.id, value);
                    }
                  },
                  side: BorderSide(
                    color: Colors.grey.shade500,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  fillColor: MaterialStateProperty.all(Colors.red),
                ),
              )
            ],
          )
        : _TimerButton(
            timer: widget.timer,
          );
  }
}

class _TimerButton extends StatelessWidget {
  const _TimerButton({
    super.key,
    required this.timer,
  });
  final Timer timer;

  @override
  Widget build(BuildContext context) {
    var isSelected =
        Provider.of<TimerViewModel>(context).currentTimerId == timer.id;
    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;
    return SizedBox(
      height: 100,
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          if (isEditMode) {
            Provider.of<EditTimerViewModel>(context, listen: false)
                .onTimerSelect(
              DateTime(0, 0, 0, timer.hours, timer.minutes, timer.seconds),
              timer.title,
            );
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15))),
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height -
                    MediaQueryData.fromWindow(window).padding.top,
              ),
              builder: (context) => CustomModalBottomSheet.timerSaveDialog(
                onSave: () {
                  var time =
                      Provider.of<EditTimerViewModel>(context, listen: false)
                          .time;
                  var title =
                      Provider.of<EditTimerViewModel>(context, listen: false)
                          .title;
                  Provider.of<TimerViewModel>(context, listen: false)
                      .onTimerEdited(timer.id, title, time);
                  Provider.of<TimerViewModel>(context, listen: false)
                      .turnOffEditMode();
                },
              ),
            );
          } else {
            var selectedTime =
                DateTime(0, 0, 0, timer.hours, timer.minutes, timer.seconds);
            Provider.of<TimerViewModel>(context, listen: false)
                .onTimerSelected(selectedTime, timer.id, timer.title);
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: (isSelected && !isEditMode)
              ? Colors.red.shade100
              : Colors.grey.shade100,
          foregroundColor:
              (isSelected && !isEditMode) ? Colors.red : Colors.black,
          elevation: 0,
        ),
        onLongPress: () {
          if (!isEditMode) {
            Provider.of<TimerViewModel>(context, listen: false)
                .turnOnEditMode(timer.id);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timer.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 5),
            isEditMode
                ? const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : _Time(
                    hours: timer.hours,
                    minutes: timer.minutes,
                    seconds: timer.seconds,
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
