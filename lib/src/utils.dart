import 'dart:io';
import 'package:http/http.dart' as http;

class Utils {
  static String getDefaultCacheDir() {
    // get default platform cache dir
    return '';
  }

  static void download(String url, File file) {
    // Download file from url to file with http
    http.get(Uri.parse(url)).then((response) {
      file.writeAsBytesSync(response.bodyBytes);
    });
  }

  static void writeContent(String content, File file) {
    // Write content to file
    file.writeAsStringSync(content);
  }

  static void copyFile(File source, File target) {
    // Copy file from source to target
    source.copySync(target.path);
  }

  static bool isImage(String? type) {
    type ??= '';
    // Check mine type is image
    return type.startsWith('image');
  }
}