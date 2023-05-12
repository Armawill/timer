import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/edit_timer_view_model.dart';
import 'package:timer/view-model/timer_view_model.dart';

class AddTimerButton extends StatelessWidget {
  const AddTimerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          final scaffoldContext =
              Provider.of<TimerViewModel>(context, listen: false)
                  .scaffoldKey
                  .currentContext;
          showModalBottomSheet(
            context: scaffoldContext!,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  MediaQueryData.fromWindow(window).padding.top,
            ),
            builder: (dialogContext) {
              TextEditingController textController = TextEditingController();
              textController.text =
                  Provider.of<EditTimerViewModel>(context).title;
              return GestureDetector(
                child: Column(
                  children: [
                    _TopIcon(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _CnacelButton(),
                        const _PageTitle(),
                        _ApplyButton(
                            context: context, dialogContext: dialogContext),
                      ],
                    ),
                    _TimerTitleEditor(
                        context: context, textController: textController),
                    _TimerPickerSpinner()
                  ],
                ),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.grey.shade200,
          elevation: 0,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _TimerPickerSpinner extends StatelessWidget {
  const _TimerPickerSpinner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimePickerSpinner(
      is24HourMode: true,
      normalTextStyle: const TextStyle(fontSize: 24, color: Colors.grey),
      highlightedTextStyle: const TextStyle(fontSize: 24, color: Colors.black),
      spacing: 50,
      itemHeight: 80,
      isShowSeconds: true,
      time: Provider.of<EditTimerViewModel>(context).time,
      isForce2Digits: true,
      onTimeChange: (time) {
        Provider.of<EditTimerViewModel>(context, listen: false)
            .onTimeSelect(time);
      },
    );
  }
}

class _TimePickerSpinner extends StatelessWidget {
  const _TimePickerSpinner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimePickerSpinner(
        is24HourMode: true,
        normalTextStyle: const TextStyle(fontSize: 24, color: Colors.grey),
        highlightedTextStyle:
            const TextStyle(fontSize: 24, color: Colors.black),
        spacing: 50,
        itemHeight: 80,
        isShowSeconds: true,
        time: Provider.of<EditTimerViewModel>(context).time,
        isForce2Digits: true,
        onTimeChange: (time) {
          Provider.of<EditTimerViewModel>(context, listen: false)
              .onTimeSelect(time);
        });
  }
}

class _TimerTitleEditor extends StatelessWidget {
  final BuildContext context;
  const _TimerTitleEditor({
    Key? key,
    required this.textController,
    required this.context,
  }) : super(key: key);

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        style: TextStyle(fontSize: 18),
        controller: textController,
        onChanged: (value) {
          Provider.of<EditTimerViewModel>(context, listen: false)
              .setTitle(value);
        },
      ),
    );
  }
}

class _TopIcon extends StatelessWidget {
  const _TopIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.remove,
      size: 40,
      color: Colors.grey,
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Add timer',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ApplyButton extends StatelessWidget {
  final BuildContext context;
  final BuildContext dialogContext;
  const _ApplyButton({
    Key? key,
    required this.dialogContext,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return IconButton(
      onPressed: () {
        var time =
            Provider.of<EditTimerViewModel>(dialogContext, listen: false).time;
        var title =
            Provider.of<EditTimerViewModel>(dialogContext, listen: false).title;
        Provider.of<TimerViewModel>(dialogContext, listen: false)
            .onTimerAdded(title, time);
        Navigator.pop(dialogContext);
      },
      icon: const Icon(Icons.check),
    );
  }
}

class _CnacelButton extends StatelessWidget {
  const _CnacelButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.close));
  }
}

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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 5),
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
