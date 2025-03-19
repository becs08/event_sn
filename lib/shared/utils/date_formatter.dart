class DateFormatter {
  // Format: "14 Juin 2025"
  static String formatEventDate(DateTime date) {
    final months = [
      '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];

    return '${date.day} ${months[date.month]} ${date.year}';
  }

  // Format court: "14 Juin"
  static String formatEventDateShort(DateTime date) {
    final months = [
      '', 'Jan', 'Fév', 'Mars', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sept', 'Oct', 'Nov', 'Déc'
    ];

    return '${date.day} ${months[date.month]}';
  }

  // Format: "14 Juin 2025 • 16:00"
  static String formatEventDateTime(DateTime date) {
    final formattedDate = formatEventDate(date);
    final formattedTime = formatTime(date);

    return '$formattedDate • $formattedTime';
  }

  // Format: "16:00"
  static String formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  // Format: "Samedi, 14 Juin 2025 • 16:00 - 21:00"
  static String formatEventFullDateTime(DateTime start, [DateTime? end]) {
    final weekdays = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
    ];

    final weekday = weekdays[start.weekday - 1];
    final formattedDate = formatEventDate(start);
    final formattedStartTime = formatTime(start);

    if (end != null) {
      final formattedEndTime = formatTime(end);
      return '$weekday, $formattedDate • $formattedStartTime - $formattedEndTime';
    } else {
      return '$weekday, $formattedDate • $formattedStartTime';
    }
  }

  // Format relatif: "Dans 3 jours", "Aujourd'hui", "Demain", etc.
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(date.year, date.month, date.day);

    final difference = eventDate.difference(today).inDays;

    if (difference == 0) {
      return 'Aujourd\'hui';
    } else if (difference == 1) {
      return 'Demain';
    } else if (difference == -1) {
      return 'Hier';
    } else if (difference > 1 && difference < 7) {
      return 'Dans $difference jours';
    } else if (difference < 0 && difference > -7) {
      return 'Il y a ${-difference} jours';
    } else {
      return formatEventDate(date);
    }
  }
}