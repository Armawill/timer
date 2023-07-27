import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/sound_change_screen_view_model.dart';
import 'package:timer/view-model/timer_view_model.dart';
import 'package:timer/view/widgets/custom_tab_bar.dart';
import 'package:timer/view/widgets/timer_tab.dart';
import 'package:timer/view/widgets/top_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    init();

    // NotificationService.initialize();
    // listenNotifications();

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle())
  }

  // void listenNotifications() =>
  //     NotificationService.onNotifications.stream.listen((payload) {});

  void init() async {
    await Provider.of<SoundChangeScreenViewModel>(context, listen: false)
        .getSounds();
  }

  @override
  Widget build(BuildContext context) {
    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: Provider.of<TimerViewModel>(context).scaffoldKey,
        appBar: AppBar(
          title: const TopMenu(),
          bottom: const CustomTabBar(),
        ),
        body: TabBarView(
          physics: isEditMode
              ? const NeverScrollableScrollPhysics()
              : const PageScrollPhysics(),
          children: const [
            TimerTab(),
            Center(
              child: Text('Work in progress'),
            ),
          ],
        ),
      ),
    );
  }
}
