import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/timer_view_model.dart';

import '../widgets/timer_tab.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
