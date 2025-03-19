import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Référence à la collection events
  CollectionReference get _eventsCollection => _firestore.collection('events');

  // Récupérer tous les événements - avec gestion des erreurs améliorée
  Future<List<Event>> getAllEvents() async {
    try {
      final snapshot = await _eventsCollection
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Event.fromFirestore(data, doc.id);
        } catch (e) {
          debugPrint('Erreur lors de la conversion du document ${doc.id}: $e');
          // Retourner un événement avec des valeurs par défaut en cas d'erreur
          return Event(
            id: doc.id,
            title: 'Événement (erreur de chargement)',
            description: 'Impossible de charger les détails',
            date: DateTime.now(),
            location: 'Inconnu',
            imageUrl: '',
            price: 0,
            category: 'Autre',
            organizerId: '',
          );
        }
      }).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des événements: $e');
      return [];
    }
  }

  // Récupérer les événements par catégorie - avec gestion des erreurs améliorée
  Future<List<Event>> getEventsByCategory(String category, {int limit = 10}) async {
    try {
      final snapshot = await _eventsCollection
          .where('category', isEqualTo: category)
          .orderBy('date', descending: false)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Event.fromFirestore(data, doc.id);
        } catch (e) {
          debugPrint('Erreur lors de la conversion du document ${doc.id}: $e');
          return Event(
            id: doc.id,
            title: 'Événement (erreur de chargement)',
            description: 'Impossible de charger les détails',
            date: DateTime.now(),
            location: 'Inconnu',
            imageUrl: '',
            price: 0,
            category: category,
            organizerId: '',
          );
        }
      }).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des événements par catégorie: $e');
      return [];
    }
  }

  // Récupérer les événements à la une
  Future<List<Event>> getFeaturedEvents({int limit = 5}) async {
    try {
      final snapshot = await _eventsCollection
          .where('isFeatured', isEqualTo: true)
          .orderBy('date', descending: false)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Event.fromFirestore(data, doc.id);
        } catch (e) {
          debugPrint('Erreur lors de la conversion du document ${doc.id}: $e');
          return Event(
            id: doc.id,
            title: 'Événement (erreur de chargement)',
            description: 'Impossible de charger les détails',
            date: DateTime.now(),
            location: 'Inconnu',
            imageUrl: '',
            price: 0,
            category: 'À la une',
            organizerId: '',
            isFeatured: true,
          );
        }
      }).toList();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des événements à la une: $e');
      return [];
    }
  }

  // Récupérer un événement par ID
  Future<Event?> getEventById(String id) async {
    try {
      final doc = await _eventsCollection.doc(id).get();
      if (!doc.exists) {
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      return Event.fromFirestore(data, doc.id);
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'événement: $e');
      return null;
    }
  }

  // Méthode pour ajouter des événements de test (à des fins de développement)
  Future<void> addSampleEvents() async {
    try {
      // Vérifier si des événements existent déjà
      final snapshot = await _eventsCollection.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        debugPrint('Des événements existent déjà dans la base de données.');
        return;
      }

      // Dates (prochains jours)
      final now = DateTime.now();
      final dates = List.generate(10, (i) =>
          DateTime(now.year, now.month, now.day + i + 5, 18, 0));

      // Liste d'événements à ajouter
      final sampleEvents = [
        {
          'title': 'Lutte: Combat Modou Lô vs Balla Gaye',
          'description': 'Combat très attendu entre les deux champions de lutte sénégalaise',
          'date': dates[0].toIso8601String(),
          'location': 'Arène National de Dakar',
          'imageUrl': 'https://via.placeholder.com/400x200?text=Lutte',
          'price': 10000,
          'category': 'Lutte',
          'organizerId': 'org1',
          'organizerName': 'Gaston Productions',
          'rating': 5,
          'isFeatured': true,
          'availableTickets': 1000,
          'soldTickets': 0,
        },
        {
          'title': 'Concert de Youssou Ndour',
          'description': 'Concert exceptionnel du roi du Mbalax au Grand Théâtre',
          'date': dates[1].toIso8601String(),
          'location': 'Grand Théâtre de Dakar',
          'imageUrl': 'https://via.placeholder.com/400x200?text=Concert',
          'price': 15000,
          'category': 'Concert',
          'organizerId': 'org2',
          'organizerName': 'Prince Arts',
          'rating': 4,
          'isFeatured': true,
          'availableTickets': 800,
          'soldTickets': 0,
        },
        {
          'title': 'Match Sénégal vs Côte d\'Ivoire',
          'description': 'Match de qualification pour la Coupe d\'Afrique des Nations',
          'date': dates[2].toIso8601String(),
          'location': 'Stade Léopold Sédar Senghor',
          'imageUrl': 'https://via.placeholder.com/400x200?text=Football',
          'price': 5000,
          'category': 'Football',
          'organizerId': 'org3',
          'organizerName': 'Fédération Sénégalaise de Football',
          'rating': 5,
          'isFeatured': true,
          'availableTickets': 2000,
          'soldTickets': 0,
        },
        {
          'title': 'Tournoi de Basket 3x3',
          'description': 'Tournoi de basket 3x3 avec les meilleurs joueurs du Sénégal',
          'date': dates[3].toIso8601String(),
          'location': 'Terrain de Basket de l\'UCAD',
          'imageUrl': 'https://via.placeholder.com/400x200?text=Basket',
          'price': 2000,
          'category': 'Basket',
          'organizerId': 'org4',
          'organizerName': 'Ligue de Basket de Dakar',
          'rating': 3,
          'isFeatured': false,
          'availableTickets': 500,
          'soldTickets': 0,
        },
        {
          'title': 'Festival des Arts Traditionnels',
          'description': 'Festival culturel présentant les arts traditionnels du Sénégal',
          'date': dates[4].toIso8601String(),
          'location': 'Musée des Civilisations Noires',
          'imageUrl': 'https://via.placeholder.com/400x200?text=Culture',
          'price': 3000,
          'category': 'Culture',
          'organizerId': 'org5',
          'organizerName': 'Ministère de la Culture',
          'rating': 4,
          'isFeatured': false,
          'availableTickets': 300,
          'soldTickets': 0,
        },
      ];

      // Ajouter les événements à Firestore
      for (final eventData in sampleEvents) {
        await _eventsCollection.add(eventData);
      }

      debugPrint('Événements de test ajoutés avec succès!');
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout des événements de test: $e');
    }
  }
}