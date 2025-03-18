import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../data/models/ticket.dart';
import '../../../../data/models/event.dart';
import 'dart:math';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Référence à la collection tickets
  CollectionReference get _ticketsCollection => _firestore.collection('tickets');

  // Référence à la collection events
  CollectionReference get _eventsCollection => _firestore.collection('events');

  // Générer un numéro de ticket aléatoire
  String _generateTicketNumber() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Acheter un ticket
  Future<Ticket?> purchaseTicket(String eventId, String userId, double price) async {
    try {
      // Vérifier si l'événement existe et a des tickets disponibles
      final eventDoc = await _eventsCollection.doc(eventId).get();

      if (!eventDoc.exists) {
        return null;
      }

      final eventData = eventDoc.data() as Map<String, dynamic>;
      final availableTickets = eventData['availableTickets'] ?? 0;
      final soldTickets = eventData['soldTickets'] ?? 0;

      if (availableTickets <= 0) {
        return null;
      }

      // Générer un numéro de ticket unique
      final ticketNumber = _generateTicketNumber();

      // Créer un nouveau ticket
      final ticket = Ticket(
        id: '', // Sera remplacé par l'ID généré par Firestore
        eventId: eventId,
        userId: userId,
        ticketNumber: ticketNumber,
        price: price,
        purchaseDate: DateTime.now(),
      );

      // Ajouter le ticket à Firestore
      final docRef = await _ticketsCollection.add(ticket.toFirestore());

      // Mettre à jour le nombre de tickets disponibles et vendus
      await _eventsCollection.doc(eventId).update({
        'availableTickets': availableTickets - 1,
        'soldTickets': soldTickets + 1,
      });

      // Mettre à jour l'utilisateur avec le nouveau ticket
      await _firestore.collection('users').doc(userId).update({
        'purchasedTickets': FieldValue.arrayUnion([docRef.id]),
      });

      return Ticket(
        id: docRef.id,
        eventId: ticket.eventId,
        userId: ticket.userId,
        ticketNumber: ticket.ticketNumber,
        price: ticket.price,
        purchaseDate: ticket.purchaseDate,
      );
    } catch (e) {
      debugPrint('Erreur lors de l\'achat du ticket: $e');
      return null;
    }
  }

  // Récupérer tous les tickets d'un utilisateur
  Stream<List<Ticket>> getUserTickets(String userId) {
    return _ticketsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Ticket.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Récupérer un ticket par ID
  Future<Ticket?> getTicketById(String id) async {
    try {
      final doc = await _ticketsCollection.doc(id).get();
      if (doc.exists) {
        return Ticket.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération du ticket: $e');
    }
    return null;
  }

  // Marquer un ticket comme utilisé
  Future<bool> markTicketAsUsed(String id) async {
    try {
      await _ticketsCollection.doc(id).update({
        'isUsed': true,
      });
      return true;
    } catch (e) {
      debugPrint('Erreur lors du marquage du ticket comme utilisé: $e');
      return false;
    }
  }
}