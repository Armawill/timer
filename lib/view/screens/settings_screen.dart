import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings-screen';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Timer'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Sound'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Date & Time'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
