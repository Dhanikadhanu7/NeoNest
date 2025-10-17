class DateTimeUtils {
  static String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}";
  }

  static String _formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  static String formatOnlyDate(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  static String formatOnlyTime(DateTime dateTime) {
    return _formatTime(dateTime);
  }
}
