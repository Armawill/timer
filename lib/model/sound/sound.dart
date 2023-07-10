import 'package:hive/hive.dart';

part 'sound.g.dart';

const timerSoundIdKey = 'timerSoundId';
const timerSoundPathKey = 'timerSoundPath';
const selectedSoundKey = 'selectedSound';

@HiveType(typeId: 2)
class Sound {
  static var _counter = 0;

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  Sound(
      {required this.id,
      required this.title,
      required this.isFromAsset,
      required this.isFromUri,
      this.assetPath,
      this.uri});

  @HiveField(2)
  String? assetPath;

  @HiveField(3)
  String? uri;

  @HiveField(4)
  bool isFromAsset = false;

  @HiveField(5)
  bool isFromUri = false;

  Sound.fromAsset({required this.title, required this.assetPath})
      : id = 'ast${(_counter++).toString()}' {
    isFromAsset = true;
  }
  Sound.fromUri({required this.id, required this.title, required this.uri}) {
    isFromUri = true;
  }

  Sound.empty()
      : id = '',
        title = '';

  @override
  String toString() {
    return "Sound(id: $id, title: $title, isFromAsset: $isFromAsset, assetPath: $assetPath, isFromUri: $isFromUri, uri: $uri)";
  }

  Sound copyWith(
      {String? id,
      String? title,
      String? assetPath,
      String? uri,
      bool? isFromAsset,
      bool? isFromUri}) {
    return Sound(
        id: id ?? this.id,
        title: title ?? this.title,
        assetPath: assetPath ?? this.assetPath,
        uri: uri ?? this.uri,
        isFromAsset: isFromAsset ?? this.isFromAsset,
        isFromUri: isFromUri ?? this.isFromUri);
  }
}
