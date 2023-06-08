import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/model/overlay_service.dart';

import 'package:timer/view-model/edit_timer_view_model.dart';
import 'package:timer/view-model/timer_view_model.dart';
import 'package:timer/view/widgets/overlay_widget.dart';

import 'model/notification_service.dart';
import 'view/widgets/timer_tab.dart';

@pragma('vm:entry-point')
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationService.initialize();
  runApp(const MyApp());
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: OverlayWidget(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TimerViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditTimerViewModel(),
        ),
      ],
      child: MaterialApp(
        home: HomeScreen(),
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ))),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getPermission();

    NotificationService.initialize();
    listenNotifications();

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle())
  }

  getPermission() async {
    await OverlayService.initialize();
  }

  void listenNotifications() =>
      NotificationService.onNotifications.stream.listen((payload) {});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: Provider.of<TimerViewModel>(context).scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TabBar(
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            labelColor: Colors.black,
            indicatorColor: Colors.red,
            indicatorWeight: 3.0,
            tabs: [
              Tab(
                text: 'Timer',
              ),
              Tab(
                text: 'Sequence',
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          TimerTab(),
          Center(
            child: Text('Work in progress'),
          ),
        ]),
      ),
    );
  }
}
