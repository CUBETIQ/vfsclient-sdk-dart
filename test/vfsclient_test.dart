import 'package:vfsclient/vfsclient.dart';
import 'package:test/test.dart';

void main() {
  group('Upload Tests', () {
    final sdk = VFSClient.withOptions(url: "http://localhost:5001");

    setUp(() {
      print("Setting up: ${sdk.getVersionInfo()}");

    });

    test('VFSClient should have options', () {
      expect(sdk.options, isNotNull);
    });
  });
}
