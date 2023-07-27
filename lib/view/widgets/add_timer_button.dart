import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view/widgets/custom_modal_bottom_sheet.dart';
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
          var currentTime =
              Provider.of<TimerViewModel>(context, listen: false).time;
          Provider.of<EditTimerViewModel>(context, listen: false)
              .setTime(currentTime);

          showModalBottomSheet(
            context: context,
            enableDrag: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  MediaQueryData.fromView(window).padding.top,
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
