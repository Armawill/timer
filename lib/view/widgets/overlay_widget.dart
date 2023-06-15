import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:provider/provider.dart';
import 'package:timer/model/overlay_service.dart';
import 'package:timer/view-model/edit_timer_view_model.dart';

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditTimerViewModel(),
      child: Container(
        padding: EdgeInsets.only(
          top: 46 +
              MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .padding
                  .top,
        ),
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AppInfo(),
                    SizedBox(height: 10),
                    _TimerInfo(),
                  ],
                ),
                _StopButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  const _StopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        OverlayService.close();
        FlutterBackgroundService().invoke('setAsBackground');
      },
      child: const Text(
        'Stop',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _AppInfo extends StatelessWidget {
  const _AppInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/app_icon.png',
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 5),
        const Text(
          'Timer',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class _TimerInfo extends StatefulWidget {
  const _TimerInfo({
    super.key,
  });

  @override
  State<_TimerInfo> createState() => _TimerInfoState();
}

class _TimerInfoState extends State<_TimerInfo> {
  String time = 'null';

  @override
  void initState() {
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data != null) {
        if (data['time'] != null) {
          time = data['time'];
          Provider.of<EditTimerViewModel>(context, listen: false)
              .setTimeString(time);
          FlutterBackgroundService().invoke('setAsForeground');
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    FlutterOverlayWindow.disposeOverlayListener();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
      style: const TextStyle(fontSize: 18),
      children: [
        const TextSpan(
          text: 'Timer done',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: Provider.of<EditTimerViewModel>(context).timeString,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    ));
  }
}
