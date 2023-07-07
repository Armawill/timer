import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timer/services/background_service.dart';
import 'package:timer/services/local_storage_service.dart';
import 'package:timer/services/overlay_service.dart';
import 'package:timer/utils/app_theme.dart';
import 'package:timer/utils/custom_scroll_behavior.dart';
import 'package:timer/view-model/edit_timer_view_model.dart';
import 'package:timer/view-model/timer_view_model.dart';
import 'package:timer/view/screens/settings_screen.dart';
import 'package:timer/view/widgets/overlay_widget.dart';
import 'package:timer/view/screens/home_screen.dart';

final service = FlutterBackgroundService();

@pragma('vm:entry-point')
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.initialize();
  // await NotificationService.initialize();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  await OverlayService.initialize();

  runApp(MyApp());
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
      debugShowCheckedModeBanner: false,
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
        // debugShowCheckedModeBanner: false,
        home: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: HomeScreen(),
        ),
        theme: AppTheme.getThemeData(),
        onGenerateRoute: (settings) {
          if (settings.name == SettingsScreen.routeName) {
            return AppTheme.buildRoute(const SettingsScreen(), settings);
          }
        },
      ),
    );
  }
}
