import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/overlay_view_model.dart';

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
      create: (context) => OverlayViewModel(),
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
          child: const Padding(
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
      onPressed:
          Provider.of<OverlayViewModel>(context, listen: false).onStopped,
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
  @override
  void initState() {
    Provider.of<OverlayViewModel>(context, listen: false).listenOverlay();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<OverlayViewModel>(context, listen: false).dispose();
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
          text: Provider.of<OverlayViewModel>(context).timeString,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    ));
  }
}
