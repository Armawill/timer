import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timer/services/background_service.dart';
import 'package:timer/services/local_storage_service.dart';
import 'package:timer/services/overlay_service.dart';
import 'package:timer/utils/custom_scroll_behavior.dart';
import 'package:timer/view-model/edit_timer_view_model.dart';
import 'package:timer/view-model/timer_view_model.dart';
import 'package:timer/view/widgets/overlay_widget.dart';
import 'view/widgets/custom_tab_bar.dart';
import 'view/widgets/timer_tab.dart';
import 'view/widgets/top_menu.dart';

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
    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: Provider.of<TimerViewModel>(context).scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          title: const TopMenu(),
          bottom: const CustomTabBar(),
          elevation: 0,
        ),
        body: TabBarView(
          physics:
              isEditMode ? NeverScrollableScrollPhysics() : PageScrollPhysics(),
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
