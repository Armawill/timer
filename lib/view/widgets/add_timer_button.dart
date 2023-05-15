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
          showTimerEditor(context, () {
            var time =
                Provider.of<EditTimerViewModel>(context, listen: false).time;
            var title =
                Provider.of<EditTimerViewModel>(context, listen: false).title;
            Provider.of<TimerViewModel>(context, listen: false)
                .onTimerAdded(title, time);
          });
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

  void showTimerEditor(BuildContext context, VoidCallback onAdd) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            MediaQueryData.fromWindow(window).padding.top,
      ),
      builder: (context) {
        TextEditingController textController = TextEditingController();
        textController.text = Provider.of<EditTimerViewModel>(context).title;
        textController.selection = TextSelection.fromPosition(
            TextPosition(offset: textController.text.length));
        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                _TopIcon(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _CnacelButton(),
                    const _PageTitle(),
                    _ApplyButton(onAdd: onAdd),
                  ],
                ),
                _TimerTitleEditor(
                    context: context, textController: textController),
                _TimerPickerSpinner()
              ],
            ),
          ),
        );
      },
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
        maxLength: 40,
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        style: const TextStyle(fontSize: 18),
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
  final VoidCallback onAdd;
  const _ApplyButton({
    Key? key,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
        onAdd();
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