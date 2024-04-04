import 'package:vfsclient/src/types.dart';
import 'package:vfsclient/vfsclient.dart';

void main() async {
  final opts = VFSClientOptions(url: "http://localhost:5002", apiKey: "", bucketId: "demo");
  final sdk = VFSClient(opts);
  
  final result = await sdk.upload(UploadRequest.fromFile("cubetiq.jpeg"));
  print(result);
}
