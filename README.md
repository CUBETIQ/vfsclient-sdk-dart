# VFS Client SDK for Dart

**Features:**

-   [x] Upload
-   [x] Download
-   [x] Delete
-   [x] Cache
-   [x] Support for Get file by File ID, File Key (`{bucket_id}:{file_id}`) and File URL (`/v`).

### ToDo

-   [ ] Enhance the Get file and cache it by file URL. (For now, it's only work for URL with `/v` prefix)
-   [ ] Cache improvement.

### Basic Usage

```dart
import 'package:vfsclient/src/types.dart';
import 'package:vfsclient/vfsclient.dart';

void main() async {
  final sdk = VFSClient.withOptions(
      url: "http://localhost:5001",
      apiKey: "",
      bucketId: "demo",
      cacheDir: ".cache");

  print("VFS Client SDK info: ${sdk.getVersionInfo()}");

  final isOk = await sdk.check();
  print("VFS Server is ok: $isOk");

  // Upload
  final uploadResult = await sdk.upload(UploadRequest.fromFile("cubetiq.jpeg"));
  print("Upload result: $uploadResult");

  // Cache file
  final cachedResult = await uploadResult?.cache();
  print("Cached result: $cachedResult");

  // Get file
  final fileId = uploadResult?.fileId ?? "";
  final getResult = await sdk.get(fileId);
  print("Get result: $getResult");

  // Delete file
  await sdk.delete(fileId);
  print("File deleted: $fileId");
}
```

### Contributors

-   Sambo Chea <sombochea@cubetiqs.com>
