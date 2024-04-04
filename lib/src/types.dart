import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:vfsclient/src/utils.dart';
import 'package:vfsclient/vfsclient.dart';

class VFSClientOptions {
  final String url; // this url is required
  final String apiKey; // this apiKey is required
  String? bucketId;
  int? maxRetryCount;
  int? retryDelay;
  int? connectionTimeout;
  String? cacheDir;

  VFSClientOptions({
    required this.url,
    required this.apiKey,
    required this.bucketId,
    this.maxRetryCount,
    this.retryDelay,
    this.connectionTimeout,
    this.cacheDir,
  });

  @override
  String toString() {
    return 'VFSClientOptions{url: $url, apiKey: $apiKey, bucketId: $bucketId, maxRetryCount: $maxRetryCount, retryDelay: $retryDelay, connectionTimeout: $connectionTimeout, cacheDir: $cacheDir}';
  }
}

class UploadRequest {
  String? bucketId;
  File? file;
  Map<String, dynamic>? metadata;
  String? contentType;

  UploadRequest({
    this.bucketId,
    this.file,
    this.metadata,
    this.contentType,
  });

  @override
  String toString() {
    return 'UploadRequest{bucketId: $bucketId, file: $file, metadata: $metadata, contentType: $contentType}';
  }

  String getMetadataString() {
    if (metadata == null) {
      return '';
    }
    return jsonEncode(metadata);
  }

  UploadRequest addMetadata(String key, dynamic value) {
    metadata ??= {};
    metadata![key] = value;
    return this;
  }

  UploadRequest addMetadataMap(Map<String, dynamic> appendMetadata) {
    metadata ??= {};
    metadata!.addAll(appendMetadata);
    return this;
  }

  static UploadRequest fromFile(String filePath) {
    return UploadRequest(file: File(filePath));
  }
}

class UploadResponse {
  String? id;
  String? bucketId;
  String? fileId;
  String? extension;
  String? name;
  int? size;
  String? path;
  String? type;
  Map<String, dynamic>? metadata;
  DateTime? createdAt;
  String? url;
  String? key;
  String? filePath;

  UploadResponse({
    this.id,
    this.bucketId,
    this.fileId,
    this.extension,
    this.name,
    this.size,
    this.path,
    this.type,
    this.metadata,
    this.createdAt,
    this.url,
    this.key,
    this.filePath,
  });

  @override
  String toString() {
    return 'UploadResponse{id: $id, bucketId: $bucketId, fileId: $fileId, extension: $extension, name: $name, size: $size, path: $path, type: $type, metadata: $metadata, createdAt: $createdAt, url: $url, key: $key, filePath: $filePath}';
  }

  UploadResponse cache() {
    final cacheDir = Utils.getDefaultCacheDir();
    final cacheFilePath = '$cacheDir/$bucketId/$fileId';
    final cacheManifestExt = VFSClient.cacheExtension;

    final cacheFile = File(cacheFilePath);
    final cacheManifestFile = File('$cacheFilePath$cacheManifestExt');

    if (cacheFile.existsSync() &&
        cacheFile.statSync().type == FileSystemEntityType.file &&
        cacheManifestFile.existsSync() &&
        cacheManifestFile.statSync().type == FileSystemEntityType.file) {
      return this;
    }

    if (filePath == null || filePath!.isEmpty) {
      filePath = cacheFilePath;
      final manifest = jsonEncode(this);
      Utils.download(url!, cacheFile);
      Utils.writeContent(manifest, cacheManifestFile);
    } else {
      final existedFile = File(filePath!);
      if (!existedFile.existsSync() ||
          existedFile.statSync().type != FileSystemEntityType.file) {
        filePath = cacheFilePath;
        final manifest = jsonEncode(this);
        Utils.download(url!, cacheFile);
        Utils.writeContent(manifest, cacheManifestFile);
      } else {
        final manifest = jsonEncode(this);
        Utils.copyFile(existedFile, cacheFile);
        Utils.writeContent(manifest, cacheManifestFile);
      }
    }

    return this;
  }

  String fileKey() {
    return '$bucketId:$fileId';
  }

  bool isImage() {
    return Utils.isImage(type);
  }

  static UploadResponse? fromJson(String? jsonString, {String? filePath}) {
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    final json = jsonDecode(jsonString);
    return UploadResponse(
      id: json['id'],
      bucketId: json['bucket_id'],
      fileId: json['fileId'],
      extension: json['extension'],
      name: json['name'],
      size: json['size'],
      path: json['path'],
      type: json['type'],
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
      url: json['url'],
      key: json['key'],
      filePath: filePath,
    );
  }
}

class UploadErrorResponse {
  String? error;

  UploadErrorResponse({
    this.error,
  });

  factory UploadErrorResponse.from(http.Response response) {
    try {
      return UploadErrorResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return UploadErrorResponse(error: response.body);
    }
  }

  factory UploadErrorResponse.fromJson(Map<String, dynamic> json) {
    return UploadErrorResponse(
      error: json['error'],
    );
  }
}
