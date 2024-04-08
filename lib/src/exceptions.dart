class FileNotFoundException implements Exception {
  final String message;

  FileNotFoundException(this.message);

  @override
  String toString() {
    return 'FileNotFoundException: $message';
  }
}

class UnkownException implements Exception {
  final String message;

  UnkownException(this.message);

  @override
  String toString() {
    return 'UnkownException: $message';
  }
}

class BucketIDRequiredException implements Exception {
  final String message;

  BucketIDRequiredException(this.message);

  @override
  String toString() {
    return 'BucketIDRequiredException: $message';
  }
}