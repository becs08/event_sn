class Ticket {
  final String id;
  final String eventId;
  final String userId;
  final String ticketNumber;
  final double price;
  final DateTime purchaseDate;
  final bool isUsed;
  final String? qrCode;

  Ticket({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.ticketNumber,
    required this.price,
    required this.purchaseDate,
    this.isUsed = false,
    this.qrCode,
  });

  // Méthode pour créer un objet Ticket à partir de données Firebase
  factory Ticket.fromFirestore(Map<String, dynamic> data, String id) {
    return Ticket(
      id: id,
      eventId: data['eventId'] ?? '',
      userId: data['userId'] ?? '',
      ticketNumber: data['ticketNumber'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      purchaseDate: DateTime.parse(data['purchaseDate']),
      isUsed: data['isUsed'] ?? false,
      qrCode: data['qrCode'],
    );
  }

  // Méthode pour convertir l'objet Ticket en Map pour Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'userId': userId,
      'ticketNumber': ticketNumber,
      'price': price,
      'purchaseDate': purchaseDate.toIso8601String(),
      'isUsed': isUsed,
      'qrCode': qrCode,
    };
  }
}