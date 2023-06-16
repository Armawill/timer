import 'package:flutter/material.dart';

import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:timer/model/timer.dart';
import 'package:timer/view-model/timer_view_model.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

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
    return Stack(
      children: [
        Column(
          children: [
            // CircularTimer(),
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

class _SavedTimers extends StatefulWidget {
  const _SavedTimers({super.key});

  @override
  State<_SavedTimers> createState() => _SavedTimersState();
}

class _SavedTimersState extends State<_SavedTimers> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = Provider.of<TimerViewModel>(context)
        .getPages()
        .map((page) => _Page(
              count: page.length,
              items: page,
              isLastPage: page.length < 6,
            ))
        .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.33,
          child: PageView(
            controller: Provider.of<TimerViewModel>(context).pageController,
            children: _pages,
            onPageChanged: (page) {
              Provider.of<TimerViewModel>(context, listen: false)
                  .onPageChanged(page);
            },
          ),
        ),
        PageViewDotIndicator(
          currentItem: Provider.of<TimerViewModel>(context).selectedPage,
          count: _pages.length,
          unselectedColor: Colors.grey,
          selectedColor: Colors.red,
          duration: const Duration(milliseconds: 200),
          size: Size(8, 8),
        ),
      ],
    );
  }
}

class _Page extends StatelessWidget {
  final int count;
  final List<Timer> items;
  final bool isLastPage;
  const _Page(
      {super.key,
      required this.count,
      required this.items,
      required this.isLastPage});

  @override
  Widget build(BuildContext context) {
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
        if (isLastPage) {
          if (!isListEmpty && index < count) {}
        }
        if (isLastPage && index >= items.length) {
          return AddTimerButton();
        } else {
          return CircularTimerButton(
            id: items[index].id,
            title: items[index].title,
            hours: items[index].hours,
            minutes: items[index].minutes,
            seconds: items[index].seconds,
          );
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
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
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
