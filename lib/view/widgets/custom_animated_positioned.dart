import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/timer_view_model.dart';

class CustomAnimatedPositionedFromBottom extends StatelessWidget {
  const CustomAnimatedPositionedFromBottom({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var isModeChanged = Provider.of<TimerViewModel>(context).isModeChanged;
    // var isTimerStateChanged =
    //     Provider.of<TimerViewModel>(context).isTimerStateChanged;
    // if (isTimerStateChanged) {
    //   print('isTimerStateChanged $isTimerStateChanged');
    //   return AnimatedOpacity(
    //     opacity: isTimerStateChanged ? 0.0 : 1.0,
    //     duration: const Duration(milliseconds: 200),
    //     onEnd: () {
    //       Provider.of<TimerViewModel>(context, listen: false)
    //           .onTimerStateChanged();
    //     },
    //     child: child,
    //   );
    // } else {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      right: MediaQuery.of(context).size.width * 0.2,
      left: MediaQuery.of(context).size.width * 0.2,
      bottom: !isModeChanged ? 0 : -100,
      onEnd: () {
        Provider.of<TimerViewModel>(context, listen: false).onModeChanged();
      },
      child: child,
    );
  }
  // }
}

// class CustomAnimatedPositionedFromLeft extends StatelessWidget {
//   const CustomAnimatedPositionedFromLeft({super.key, required this.child});

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     var isTimerStateChanged =
//         Provider.of<TimerViewModel>(context).isTimerStateChanged;
//     return AnimatedPositioned(
//       duration: const Duration(milliseconds: 200),
//       right: !isTimerStateChanged
//           ? MediaQuery.of(context).size.width * 0.2
//           : MediaQuery.of(context).size.width * 0.3,
//       bottom: 50,
//       onEnd: () {
//         Provider.of<TimerViewModel>(context, listen: false)
//             .onTimerStateChanged();
//       },
//       child: child,
//     );
//   }
// }
