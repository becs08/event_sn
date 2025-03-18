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
    this.isFeatured = false,
    this.rating = 0,
    required this.organizerId,
    this.organizerName = '',
    this.organizerAvatar = '',
    this.availableTickets = 0,
    this.soldTickets = 0,
  });

  // Méthode pour convertir l'objet en Map pour Firebase
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
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Méthode pour créer un objet Event à partir de données Firebase
  static Event fromFirestore(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: DateTime.parse(data['date']),
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      rating: data['rating'] ?? 0,
      organizerId: data['organizerId'] ?? '',
      organizerName: data['organizerName'] ?? '',
      organizerAvatar: data['organizerAvatar'] ?? '',
      availableTickets: data['availableTickets'] ?? 0,
      soldTickets: data['soldTickets'] ?? 0,
    );
  }

  // Compatibilité avec les anciennes méthodes
  Map<String, dynamic> toJson() => toFirestore();

  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      rating: json['rating'] ?? 0,
      organizerId: json['organizerId'] ?? '',
      organizerName: json['organizerName'] ?? '',
      organizerAvatar: json['organizerAvatar'] ?? '',
      availableTickets: json['availableTickets'] ?? 0,
      soldTickets: json['soldTickets'] ?? 0,
    );
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    String? imageUrl,
    double? price,
    bool? isFeatured,
    int? rating,
    String? category,
    String? organizerId,
    String? organizerName,
    String? organizerAvatar,
    int? availableTickets,
    int? soldTickets,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isFeatured: isFeatured ?? this.isFeatured,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      organizerAvatar: organizerAvatar ?? this.organizerAvatar,
      availableTickets: availableTickets ?? this.availableTickets,
      soldTickets: soldTickets ?? this.soldTickets,
    );
  }
}