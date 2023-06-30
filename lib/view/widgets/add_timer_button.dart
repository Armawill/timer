import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view/widgets/custom_modal_bottom_sheet.dart';
import 'package:timer/view-model/edit_timer_view_model.dart';
import 'package:timer/view-model/timer_view_model.dart';

class AddTimerButton extends StatefulWidget {
  const AddTimerButton({super.key});

  @override
  State<AddTimerButton> createState() => _AddTimerButtonState();
}

class _AddTimerButtonState extends State<AddTimerButton>
    with TickerProviderStateMixin {
  // late AnimationController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = BottomSheet.createAnimationController(this);
  //   controller.duration = const Duration(seconds: 1);
  //   controller.reverseDuration = const Duration(seconds: 1);
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            enableDrag: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
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
                    .onTimerAdded(title, time);
              },
            ),
          );
          // .whenComplete(() {
          //   controller = BottomSheet.createAnimationController(this);
          // });
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.grey.shade200,
          elevation: 0,
        ),
        child: Icon(
          Icons.add,
          color: Colors.grey.shade700,
          size: 30,
        ),
      ),
    );
  }
}
