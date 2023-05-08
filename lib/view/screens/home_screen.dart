import 'package:flutter/material.dart';

import '../widgets/timer_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(tabs: [
            Tab(
              text: 'Timer',
            ),
            Tab(
              text: 'Sequence',
            ),
          ]),
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
