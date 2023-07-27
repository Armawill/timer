import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/model/sound/sound.dart';
import 'package:timer/view-model/sound_change_screen_view_model.dart';

class SoundChangeScreen extends StatefulWidget {
  static const routeName = '/sound-change-screen';
  const SoundChangeScreen({super.key});

  @override
  State<SoundChangeScreen> createState() => _SoundChangeScreenState();
}

class _SoundChangeScreenState extends State<SoundChangeScreen> {
  @override
  Widget build(BuildContext context) {
    var systemSoundList =
        Provider.of<SoundChangeScreenViewModel>(context).systemSoundList;
    var appSoundList =
        Provider.of<SoundChangeScreenViewModel>(context).appSoundList;

    return WillPopScope(
      onWillPop: () async {
        Provider.of<SoundChangeScreenViewModel>(context, listen: false)
            .stopPlayback();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Sound'),
            leading: BackButton(
              onPressed: () {
                Provider.of<SoundChangeScreenViewModel>(context, listen: false)
                    .stopPlayback();
                Navigator.pop(context);
              },
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate(
                      [
                        const _CategoryName(text: 'CUSTOM'),
                        const _CustomSound(),
                        const _CustomDivider(),
                        const _CategoryName(text: 'TIMER TONES'),
                        _SoundList(soundList: appSoundList),
                        const _CustomDivider(),
                        const _CategoryName(text: 'SYSTEM'),
                      ],
                    ))),
              ];
            },
            body: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewPadding.top,
              child: Column(
                children: [
                  Expanded(child: _SoundList(soundList: systemSoundList)),
                ],
              ),
            ),
          )),
    );
  }
}

class _SoundList extends StatelessWidget {
  const _SoundList({
    required this.soundList,
  });

  final List<Sound> soundList;

  @override
  Widget build(BuildContext context) {
    var selectedSoundId =
        Provider.of<SoundChangeScreenViewModel>(context).selectedSound.id;

    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(soundList[index].title),
          trailing: Radio<String>(
            value: soundList[index].id,
            groupValue: selectedSoundId,
            onChanged: (value) {
              Provider.of<SoundChangeScreenViewModel>(context, listen: false)
                  .playSelectedSound(soundList[index].id);
            },
          ),
          onTap: () {
            Provider.of<SoundChangeScreenViewModel>(context, listen: false)
                .playSelectedSound(soundList[index].id);
          },
        );
      },
      itemCount: soundList.length,
    );
  }
}

class _CustomSound extends StatelessWidget {
  const _CustomSound();

  @override
  Widget build(BuildContext context) {
    var isCustomSound =
        Provider.of<SoundChangeScreenViewModel>(context).isCustomSound;
    var selectedSound =
        Provider.of<SoundChangeScreenViewModel>(context).selectedSound.title;
    return ListTile(
      title: const Text('Select from files'),
      subtitle: isCustomSound
          ? Text(
              selectedSound,
              style: const TextStyle(
                color: Colors.red,
              ),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Provider.of<SoundChangeScreenViewModel>(context, listen: false)
            .setCustomSound();
      },
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Divider(
        indent: 15,
        endIndent: 15,
        thickness: 1,
      ),
    );
  }
}

class _CategoryName extends StatelessWidget {
  final String text;
  const _CategoryName({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
