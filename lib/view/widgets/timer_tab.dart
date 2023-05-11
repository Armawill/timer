import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:timer/model/timer.dart';
import 'package:timer/view-model/timer_view_model.dart';
import 'package:timer/view/widgets/circular_timer_button.dart';

import 'circular_timer.dart';
// import 'time_spinner.dart';

class TimerTab extends StatefulWidget {
  const TimerTab({super.key});

  @override
  State<TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab> {
  @override
  Widget build(BuildContext context) {
    var time = Provider.of<TimerViewModel>(context).time;
    return Stack(
      children: [
        Column(
          children: [
            Provider.of<TimerViewModel>(context).isTimerStarted
                ? CircularTimer()
                : const _TimePickerSpinner(),
            !Provider.of<TimerViewModel>(context).isTimerStarted
                ? _SavedTimers()
                : Container(),
          ],
        ),
        Provider.of<TimerViewModel>(context).isTimerStarted
            ? const _TimerControlButtons()
            : const _StartButton(),
      ],
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
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
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
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 18),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red.shade100),
                foregroundColor: MaterialStateProperty.all(Colors.red),
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
                    child: const Text(
                      'Resume',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
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
                    child: Text(
                      'Pause',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                  ),
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
    return TimePickerSpinner(
        is24HourMode: true,
        normalTextStyle: const TextStyle(fontSize: 24, color: Colors.grey),
        highlightedTextStyle:
            const TextStyle(fontSize: 24, color: Colors.black),
        spacing: 50,
        itemHeight: 80,
        isShowSeconds: true,
        time: Provider.of<TimerViewModel>(context).time,
        isForce2Digits: true,
        onTimeChange: (time) {
          Provider.of<TimerViewModel>(context, listen: false)
              .onTimerSelected(time);
        });
  }
}

class _SavedTimers extends StatelessWidget {
  const _SavedTimers({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PageController();

    final List<Widget> _pages = Provider.of<TimerViewModel>(context)
        .getPages()
        .map((page) => _Page(count: page.length, items: page))
        .toList();

    int _activePage = 0;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.33,
      child: PageView(controller: controller, children: _pages),
    );
  }
}

class _Page extends StatelessWidget {
  final int count;
  final List<Timer> items;
  const _Page({super.key, required this.count, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count + 1,
      itemBuilder: (context, index) {
        if (index < count) {
          return CircularTimerButton(
            title: items[index].title,
            hours: items[index].hours,
            minutes: items[index].minutes,
            seconds: items[index].seconds,
          );
        } else {
          // return TimePickerSpinner();
          return AddTimerButton();
        }
      },
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Provider.of<TimerViewModel>(context, listen: false).onTimerStart();
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
