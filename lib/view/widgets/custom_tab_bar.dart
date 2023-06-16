import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TabBar(
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
