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
  final String organizerName;
  final String organizerAvatar;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.price,
    this.isFeatured = false,
    this.rating = 0,
    this.organizerName = '',
    this.organizerAvatar = '',
  });

  // Méthode pour convertir l'objet en Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'imageUrl': imageUrl,
      'price': price,
      'isFeatured': isFeatured,
      'rating': rating,
      'organizerName': organizerName,
      'organizerAvatar': organizerAvatar,
    };
  }

  // Méthode pour créer un objet Event à partir d'un Map
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      isFeatured: json['isFeatured'] ?? false,
      rating: json['rating'] ?? 0,
      organizerName: json['organizerName'] ?? '',
      organizerAvatar: json['organizerAvatar'] ?? '',
    );
  }
}