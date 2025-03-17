import 'package:flutter/foundation.dart';

import '../../data/models/event.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events => _events;
  List<Event> get featuredEvents => _events.where((e) => e.isFeatured).toList();

  Future<void> fetchEvents() async {
    // Implémentez la logique pour récupérer les événements
    notifyListeners();
  }
}