import 'package:logger/logger.dart';
import 'package:vfsclient/src/types.dart';
import 'package:vfsclient/src/vfsclient_service.dart';

class VFSClient {
  static final name = 'VFSClient';
  static final version = '1.0.0';
  static final versionCode = "1";
  static final userAgent = '$name:SDK-Dart/$version-$versionCode';
  static final cacheExtension = '.manifest';

  static final Logger logger = Logger();

  final VFSClientOptions options;
  VFSClient(this.options);

  Future<UploadResponse?> upload(UploadRequest request) async {
    logger.d('upload request: $request');

    if (request.file == null) {
      throw Exception('file is required');
    }

    final bucketId = request.bucketId ?? options.bucketId;
    if (bucketId == null) {
      throw Exception('bucketId is required');
    }

    final response = await VFSClientService.upload(
      options.url,
      options.apiKey,
      bucketId,
      request.file!,
    );

    if (response.statusCode != 200) {
      throw Exception('Upload failed: ${response.body}');
    }

    logger.d('upload response: ${response.body}');
    return UploadResponse.fromJson(response.body, filePath: request.file!.path);
  }
}
