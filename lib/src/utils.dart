import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vfsclient/src/logger.dart';

class Utils {
  static String getDefaultCacheDir() {
    // get default platform cache dir
    return '.cache';
  }

  static Future<void> download(String url, File file) async {
    // Download file from url to file with http
    Logs.d('Downloading file from $url to ${file.path}');
    final response = await http.get(Uri.parse(url));
    await file.writeAsBytes(response.bodyBytes);
  }

  static void writeContent(String content, File file) {
    // Write content to file
    Logs.d('Writing content to ${file.path}');
    file.writeAsStringSync(content);
  }

  static void copyFile(File source, File target) {
    // Copy file from source to target
    Logs.d('Copying file from ${source.path} to ${target.path}');
    source.copySync(target.absolute.path);
  }

  static bool isImage(String? type) {
    type ??= '';
    // Check mine type is image
    return type.startsWith('image');
  }
}
