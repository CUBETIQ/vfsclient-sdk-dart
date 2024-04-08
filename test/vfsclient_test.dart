import 'package:vfsclient/src/types.dart';
import 'package:vfsclient/vfsclient.dart';
import 'package:test/test.dart';

void main() {
  final bucketId = "demo";
  final cacheDir = ".cache";

  var fileId = "";

  group('Upload Tests', () {
    final sdk = VFSClient.withOptions(
        url: "http://localhost:5001", bucketId: bucketId, cacheDir: cacheDir);

    setUp(() {
      print("Setting up: ${sdk.getVersionInfo()}");
    });

    test('VFSClient should have options', () {
      expect(sdk.options, isNotNull);
    });

    test('VFSClient should have version info and match', () {
      expect(sdk.getVersionInfo(), isNotNull);
      expect(sdk.getVersionInfo(), equals("VFSClient:SDK-Dart/1.0.0-1"));
    });

    test('VFSClient should check', () async {
      final isOk = await sdk.check();
      expect(isOk, isTrue);
    });

    test('VFSClient should upload with cache and get', () async {
      // Upload
      final uploadResult = await (await sdk.upload(UploadRequest.fromFile(
              "/Users/cubetiq/projects/vfsclient-sdk-dart/example/cubetiq.jpeg")))
          ?.cache();
      expect(uploadResult, isNotNull);

      fileId = uploadResult?.fileId ?? "";
      expect(fileId, isNotNull);
      expect(fileId, isNotEmpty);

      // Get file
      final getResult = (await sdk.get(uploadResult?.fileId ?? ""));
      expect(getResult, isNotNull);

      // Check file
      expect(getResult?.fileId, equals(fileId));

      // Is file exists
      expect(getResult?.file, isNotNull);
    });

    test('VFSClient should delete', () async {
      var isDeleted = false;
      try {
        await sdk.delete(fileId);
        isDeleted = true;
      } catch (e) {
        isDeleted = false;
      }

      expect(isDeleted, isTrue);
    });
  });
}
