class Logs {
  // level 0: debug, 1: error, 2: info, 3: warning, 4: verbose
  static void _print(
    int level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final prefix = time != null ? '[${time.toIso8601String()}]' : '';
    final errorMessage = error != null ? 'Error: $error' : '';
    final stackTraceMessage =
        stackTrace != null ? 'StackTrace: $stackTrace' : '';
    print('$prefix $message $errorMessage $stackTraceMessage');
  }

  static void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _print(0, message, time: time, error: error, stackTrace: stackTrace);
  }

  static void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _print(1, message, time: time, error: error, stackTrace: stackTrace);
  }

  static void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _print(2, message, time: time, error: error, stackTrace: stackTrace);
  }
}
