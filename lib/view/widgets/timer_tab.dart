import 'package:flutter/material.dart';

import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:timer/model/timer/timer.dart';
import 'package:timer/presentation/custom_icons_icons.dart';
import 'package:timer/view/widgets/custom_animated_positioned.dart';
import 'package:timer/view/widgets/custom_modal_bottom_sheet.dart';
import 'package:timer/view-model/timer_view_model.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
// import 'package:timer/view/widgets/time_spinner.dart';

import 'circular_timer_button.dart';
import 'add_timer_button.dart';
import 'circular_timer.dart';

class TimerTab extends StatefulWidget {
  const TimerTab({super.key});

  @override
  State<TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab> {
  @override
  Widget build(BuildContext context) {
    var isTimerStarted = Provider.of<TimerViewModel>(context).isTimerStarted;
    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              Provider.of<TimerViewModel>(context).isTimerStarted
                  ? const CircularTimer()
                  : const _TimePickerSpinner(),
              !Provider.of<TimerViewModel>(context).isTimerStarted
                  ? const _SavedTimers()
                  : Container(),
            ],
          ),
        ),
        isTimerStarted
            ? const _TimerControlButtons()
            : isEditMode
                ? const CustomAnimatedPositionedFromBottom(
                    child: _DeleteButton())
                : const CustomAnimatedPositionedFromBottom(
                    child: _StartButton(),
                  ),
      ],
    );
  }
}

class _DeleteButton extends StatefulWidget {
  const _DeleteButton();

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  @override
  Widget build(BuildContext context) {
    var isAnyTimerChecked =
        Provider.of<TimerViewModel>(context).isAnyTimerChecked;

    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 50,
        child: IgnorePointer(
          ignoring: isAnyTimerChecked ? false : true,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isDismissible: false,
                enableDrag: false,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15))),
                builder: (context) =>
                    CustomModalBottomSheet.timerDeleteDialog(),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey.shade50),
              foregroundColor: MaterialStateProperty.all(
                  isAnyTimerChecked ? Colors.black : Colors.grey.shade400),
            ),
            child: Column(
              children: [
                Icon(
                  CustomIcons.trash,
                  size: 20,
                  color:
                      isAnyTimerChecked ? Colors.black : Colors.grey.shade400,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Delete',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerControlButtons extends StatelessWidget {
  const _TimerControlButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<TimerViewModel>(context, listen: false)
                        .onTimerCancel();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade100),
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Provider.of<TimerViewModel>(context).isTimerPaused
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<TimerViewModel>(context, listen: false)
                              .onTimerResume();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text(
                          'Resume',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<TimerViewModel>(context, listen: false)
                              .onTimerPause();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text(
                          'Pause',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimePickerSpinner extends StatelessWidget {
  const _TimePickerSpinner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;
    return TimePickerSpinner(
      isEnable: isEditMode ? false : true,
      is24HourMode: true,
      isLabelShow: true,
      normalTextStyle: const TextStyle(fontSize: 24, color: Colors.grey),
      highlightedTextStyle: const TextStyle(fontSize: 24, color: Colors.black),
      spacing: 30,
      itemHeight: 80,
      itemWidth: MediaQuery.of(context).size.width * 0.2,
      isShowSeconds: true,
      time: Provider.of<TimerViewModel>(context).time,
      isForce2Digits: true,
      onTimeChange: (time) {
        Provider.of<TimerViewModel>(context, listen: false)
            .onTimerSelected(time);
      },
    );
  }
}

class _SavedTimers extends StatefulWidget {
  const _SavedTimers();

  @override
  State<_SavedTimers> createState() => _SavedTimersState();
}

class _SavedTimersState extends State<_SavedTimers> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages =
        Provider.of<TimerViewModel>(context).getPages().map((page) {
      return _Page(
        count: page.length,
        items: page,
        isLastPage: page.length < 6,
      );
    }).toList();

    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.33,
          child: PageView(
            physics: (isEditMode && pages.length == 1)
                ? const NeverScrollableScrollPhysics()
                : null,
            controller: Provider.of<TimerViewModel>(context).pageController,
            children: pages,
            onPageChanged: (page) {
              Provider.of<TimerViewModel>(context, listen: false)
                  .onPageChanged(page);
            },
          ),
        ),
        pages.length > 1
            ? PageViewDotIndicator(
                currentItem: Provider.of<TimerViewModel>(context).selectedPage,
                count: pages.length,
                unselectedColor: Colors.grey,
                selectedColor: Colors.red,
                duration: const Duration(milliseconds: 200),
                size: const Size(8, 8),
              )
            : Container(),
      ],
    );
  }
}

class _Page extends StatelessWidget {
  final int count;
  final List<Timer> items;
  final bool isLastPage;
  const _Page({
    required this.count,
    required this.items,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;
    bool isListEmpty = false;
    if (count == 0) {
      isListEmpty = true;
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: isListEmpty
          ? 1
          : isLastPage
              ? count + 1
              : count,
      itemBuilder: (context, index) {
        if (isLastPage && index >= items.length) {
          return AnimatedOpacity(
            opacity: isEditMode ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: const AddTimerButton(),
          );
        } else {
          return CircularTimerButton(
            timer: items[index],
          );
        }
      },
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            Provider.of<TimerViewModel>(context, listen: false).onTimerStart();
            // Provider.of<TimerViewModel>(context, listen: false)
            //     .onTimerStateChanged();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            textStyle: Theme.of(context).elevatedButtonTheme.style?.textStyle,
          ),
          child: const Text(
            'Start',
          ),
        ),
      ),
    );
  }
}
