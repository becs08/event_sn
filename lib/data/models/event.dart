class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String imageUrl;
  final double price;
  final bool isFeatured;
  final int rating;
  final String category;
  final String organizerId;
  final String organizerName;
  final String organizerAvatar;
  final int availableTickets;
  final int soldTickets;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.organizerId,
    this.isFeatured = false,
    this.rating = 0,
    this.organizerName = '',
    this.organizerAvatar = '',
    this.availableTickets = 0,
    this.soldTickets = 0,
  });

  // Méthode pour convertir l'objet en Map pour Firebase avec gestion des valeurs null
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'imageUrl': imageUrl,
      'price': price,
      'isFeatured': isFeatured,
      'rating': rating,
      'category': category,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'organizerAvatar': organizerAvatar,
      'availableTickets': availableTickets,
      'soldTickets': soldTickets,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // Méthode pour créer un objet Event à partir de données Firebase avec gestion robuste des valeurs nullables
  static Event fromFirestore(Map<String, dynamic> data, String docId) {
    // Traitement sécurisé de la date
    DateTime parsedDate;
    try {
      final dateStr = data['date'] as String?;
      if (dateStr != null) {
        parsedDate = DateTime.parse(dateStr);
      } else {
        parsedDate = DateTime.now();
      }
    } catch (e) {
      parsedDate = DateTime.now(); // Date par défaut en cas d'erreur
    }

    // Traitement sécurisé des valeurs numériques
    double getDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      try {
        return double.parse(value.toString());
      } catch (_) {
        return 0.0;
      }
    }

    int getInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      try {
        return int.parse(value.toString());
      } catch (_) {
        return 0;
      }
    }

    bool getBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is num) return value != 0;
      return false;
    }

    String getString(dynamic value) {
      if (value == null) return '';
      return value.toString();
    }

    return Event(
      id: docId,
      title: getString(data['title']),
      description: getString(data['description']),
      date: parsedDate,
      location: getString(data['location']),
      imageUrl: getString(data['imageUrl']),
      price: getDouble(data['price']),
      category: getString(data['category']),
      isFeatured: getBool(data['isFeatured']),
      rating: getInt(data['rating']),
      organizerId: getString(data['organizerId']),
      organizerName: getString(data['organizerName']),
      organizerAvatar: getString(data['organizerAvatar']),
      availableTickets: getInt(data['availableTickets']),
      soldTickets: getInt(data['soldTickets']),
    );
  }
}