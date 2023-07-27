import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/sound_change_screen_view_model.dart';
import 'package:timer/view/screens/sound_change_screen.dart';
// import 'package:timer/services/ringtone_service.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings-screen';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var selectedSound =
        Provider.of<SoundChangeScreenViewModel>(context).selectedSound;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: ListView(
        children: [
          // ListTile(
          //   title: const Text('Timer'),
          //   onTap: () {},
          // ),
          ListTile(
            title: const Text('Sound'),
            subtitle: Text(
              selectedSound.title,
              style: const TextStyle(color: Colors.red),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pushNamed(SoundChangeScreen.routeName);
            },
          ),
          // ListTile(
          //   title: const Text('Date & Time'),
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }
}
