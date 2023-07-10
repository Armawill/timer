import 'dart:developer';
import 'dart:io';

// import 'package:file_manager/file_manager.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static void initialize() async {
    // await FileManager.requestFilesAccessPermission();
  }

  static Future<String> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      try {
        File file = File(result.files.single.path!);
        return file.path;
      } catch (err) {
        log('File is not exist');
        rethrow;
      }
    }
    return 'not found';
  }
}
