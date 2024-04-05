import 'dart:async';

import 'package:vfsclient/src/logger.dart';
import 'package:vfsclient/src/types.dart';
import 'package:vfsclient/src/vfsclient_service.dart';

class VFSClient {
  static final name = 'VFSClient';
  static final version = '1.0.0';
  static final versionCode = "1";
  static final userAgent = '$name:SDK-Dart/$version-$versionCode';
  static final cacheExtension = '.manifest';

  final VFSClientOptions options;
  VFSClient(this.options);

  VFSClient.withOptions({
    required String url,
    String? apiKey,
    String? bucketId,
  }) : options = VFSClientOptions(
            url: url, apiKey: apiKey ?? "", bucketId: bucketId);

  Future<UploadResponse?> upload(UploadRequest request) async {
    Logs.d('upload request: $request');

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

    Logs.d('upload response: ${response.body}');
    return UploadResponse.fromJson(
      response.body,
      filePath: request.file!.absolute.path,
      cacheDir: options.cacheDir,
    );
  }

  Future<UploadResponse?> get(String fileId, {String? bucketId}) async {
    // check if fileId contains ':' then split it [bucketId:fileId]
    if (fileId.contains(':')) {
      final parts = fileId.split(':');
      if (parts.length == 2) {
        bucketId = parts[0];
        fileId = parts[1];
      }
    }

    final bId = bucketId ?? options.bucketId;
    if (bId == null) {
      throw Exception('bucketId is required');
    }

    // TODO: check cache first

    // Retrieve file info from server
    final response = await VFSClientService.get(
        options.url, options.apiKey, bId, fileId,
        contentType: 'application/json');

    if (response.statusCode != 200) {
      throw Exception('Get failed: ${response.body}');
    }

    return UploadResponse.fromJson(
      response.body,
      cacheDir: options.cacheDir,
    );
  }

  Future<void> delete(String fileId, {String? bucketId}) async {
    // check if fileId contains ':' then split it [bucketId:fileId]
    if (fileId.contains(':')) {
      final parts = fileId.split(':');
      if (parts.length == 2) {
        bucketId = parts[0];
        fileId = parts[1];
      }
    }

    final bId = bucketId ?? options.bucketId;
    if (bId == null) {
      throw Exception('bucketId is required');
    }

    final response = await VFSClientService.delete(
      options.url,
      options.apiKey,
      bId,
      fileId,
    );

    if (response.statusCode != 200) {
      throw Exception('Delete failed: ${response.body}');
    }

    // TODO: clear cache
  }

  String getVersionInfo() {
    return userAgent;
  }
}
