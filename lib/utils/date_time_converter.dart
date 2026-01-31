
class DateTimeConverter {
  /// Backend → UI (local DateTime)
  static DateTime? fromBackend(dynamic seconds) {
    if (seconds == null) return null;

    // ❗ DO NOT use DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true)
    // ❗ DO NOT use toLocal()
    // Backend stores LOCAL seconds, so we read them as LOCAL.
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: false);
  }

  /// UI Calendar → backend seconds (LOCAL, NO UTC SHIFT)
  static int uiDateToSeconds(DateTime local) {
    final normalized = DateTime(
      local.year,
      local.month,
      local.day,
      0,
      0,
      0,
      0,
      0,
    );

    return normalized.millisecondsSinceEpoch ~/ 1000;
  }

  /// UI Time → backend seconds (LOCAL, NO UTC SHIFT)
  static int uiTimeToSeconds(DateTime local) {
    final normalized = DateTime(
      2000,
      1,
      1,
      local.hour,
      local.minute,
      0,
    );

    return normalized.millisecondsSinceEpoch ~/ 1000;
  }
}
