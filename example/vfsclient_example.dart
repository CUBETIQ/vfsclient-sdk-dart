import 'package:vfsclient/src/types.dart';
import 'package:vfsclient/vfsclient.dart';

void main() async {
  final opts = VFSClientOptions(url: "http://localhost:5001", apiKey: "", bucketId: "demo", cacheDir: ".");
  final sdk = VFSClient(opts);
  
  // final result = (await sdk.upload(UploadRequest.fromFile("cubetiq.jpeg")))?.cache();
  final fileId = "7d1d7e54f40477f9454f99a6982ae0fc2bc62842bb5bd63bbd4083c80d936489";
  final result = (await sdk.get(fileId))?.file;
  print(result);
}
