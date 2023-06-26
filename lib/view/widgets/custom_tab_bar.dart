import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/timer_view_model.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;
    var countOfCheckedTimers =
        Provider.of<TimerViewModel>(context).countOfCheckedTimers;
    return isEditMode
        ? Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                countOfCheckedTimers > 0
                    ? '$countOfCheckedTimers selected'
                    : 'Select items',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : const TabBar(
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
          );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
