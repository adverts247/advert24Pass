String formatTime(DateTime time) {
  String period = time.hour >= 12 ? 'pm' : 'am';
  int hour = time.hour > 12 ? time.hour - 12 : time.hour;
  // Handle midnight (0) and noon (12)
  hour = hour == 0 ? 12 : hour;

  return '$hour:${time.minute.toString().padLeft(2, '0')}$period';
}
