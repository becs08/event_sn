class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final List<String> favoriteEvents;
  final List<String> purchasedTickets;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.favoriteEvents = const [],
    this.purchasedTickets = const [],
  });

  // Méthode pour créer un objet User à partir de données Firebase
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      favoriteEvents: List<String>.from(data['favoriteEvents'] ?? []),
      purchasedTickets: List<String>.from(data['purchasedTickets'] ?? []),
    );
  }

  // Méthode pour convertir l'objet User en Map pour Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'favoriteEvents': favoriteEvents,
      'purchasedTickets': purchasedTickets,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    List<String>? favoriteEvents,
    List<String>? purchasedTickets,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteEvents: favoriteEvents ?? this.favoriteEvents,
      purchasedTickets: purchasedTickets ?? this.purchasedTickets,
    );
  }
}