import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/model/background_service.dart';
import 'package:timer/model/local_storage_service.dart';
import 'package:timer/model/overlay_service.dart';
import 'package:timer/utils/custom_scroll_behavior.dart';

import 'package:timer/view-model/edit_timer_view_model.dart';
import 'package:timer/view-model/timer_view_model.dart';
import 'package:timer/view/widgets/overlay_widget.dart';
import 'view/widgets/timer_tab.dart';

final service = FlutterBackgroundService();

@pragma('vm:entry-point')
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.initialize();
  // await NotificationService.initialize();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  await OverlayService.initialize();

  runApp(const MyApp());
}

// getOverlayPermission() async {
//   await OverlayService.initialize();
// }

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundService.initilizeService();
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
        home: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: HomeScreen(),
        ),
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

    // NotificationService.initialize();
    // listenNotifications();

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle())
  }

  // void listenNotifications() =>
  //     NotificationService.onNotifications.stream.listen((payload) {});

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
