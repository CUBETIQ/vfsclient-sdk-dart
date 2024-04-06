import 'package:vfsclient/src/types.dart';
import 'package:vfsclient/vfsclient.dart';

void main() async {
  final opts = VFSClientOptions(url: "http://localhost:5001", apiKey: "", bucketId: "demo", cacheDir: ".");
  final sdk = VFSClient(opts);
  
  final uploadResult = (await sdk.upload(UploadRequest.fromFile("cubetiq.jpeg")))?.cache();
  print(uploadResult);
  // final fileId = uploadResult?.fileId ?? "";
  final fileId = "e6efe4904dea1d1cca4e29e6bdc923e4fa91118d0c375b5ca6a42a1d335be10b";
  // final getResult = (await sdk.get(fileId, bucketId: "demo"))?.file;
  // print(getResult);
  await sdk.delete(fileId);
}
