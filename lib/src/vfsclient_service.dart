import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vfsclient/vfsclient.dart';

class VFSClientService {
  static Future<http.Response> check(String url, String apiKey) async {
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'User-Agent': VFSClient.userAgent,
        'x-api-key': apiKey,
      },
    );
    return response;
  }

  static Future<http.Response> upload(
      String url, String apiKey, String bucketId, File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('$url/api/upload'))
      ..headers['User-Agent'] = VFSClient.userAgent
      ..headers['x-api-key'] = apiKey
      ..fields['bucket_id'] = bucketId
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await http.Response.fromStream(await request.send());
    return response;
  }

  static Future<http.Response> delete(
      String url, String apiKey, String bucketId, String fileId) async {
    var response = await http.delete(
      Uri.parse('$url/api/upload/unlink/$bucketId/$fileId'),
      headers: <String, String>{
        'User-Agent': VFSClient.userAgent,
        'x-api-key': apiKey,
      },
    );
    return response;
  }

  static Future<http.Response> deleteById(
      String url, String apiKey, String id) async {
    var response = await http.delete(
      Uri.parse('$url/api/upload/$id'),
      headers: <String, String>{
        'User-Agent': VFSClient.userAgent,
        'x-api-key': apiKey,
      },
    );
    return response;
  }

  static Future<http.Response> deleteAll(
      String url, String apiKey, String bucketId) async {
    var response = await http.delete(
      Uri.parse('$url/api/upload/bucket/$bucketId'),
      headers: <String, String>{
        'User-Agent': VFSClient.userAgent,
        'x-api-key': apiKey,
      },
    );
    return response;
  }

  static Future<http.Response> get(
      String url, String apiKey, String bucketId, String fileId) async {
    var response = await http.get(
      Uri.parse('$url/v/$bucketId/$fileId'),
      headers: <String, String>{
        'User-Agent': VFSClient.userAgent,
        'x-api-key': apiKey,
      },
    );
    return response;
  }
}
