class TimeFormatter {
  static String formatTime(String iso) {
    final time = iso.split('T')[1].substring(0, 5);
    final hour = int.parse(time.split(':')[0]);
    final minute = time.split(':')[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  static String formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}h ${m}m';
  }
}
