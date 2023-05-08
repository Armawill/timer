import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/timer_view_model.dart';

import 'view/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => TimerViewModel(),
        child: HomeScreen(),
      ),
    );
  }
}
