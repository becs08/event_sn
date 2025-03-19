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

  // Méthode pour ajouter des événements de test enrichis (au moins 3 par catégorie)
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
      final dates = List.generate(25, (i) =>
          DateTime(now.year, now.month, now.day + i + 2, 18, 0));

      // Liste d'événements à ajouter - LUTTE (4 événements)
      final lutteSampleEvents = [
        {
          'title': 'Combat Modou Lô vs Balla Gaye 2',
          'description': 'Le choc des titans de l\'arène! Un combat très attendu entre les deux champions de lutte sénégalaise. Modou Lô, le Rock des Parcelles Assainies, affronte Balla Gaye 2, le Lion de Guédiawaye, pour un combat qui promet d\'être spectaculaire.',
          'date': dates[0].toIso8601String(),
          'location': 'Arène Nationale de Dakar',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Flutte.jpeg?alt=media&token=19ee35a9-4033-47fa-a54a-957e0afe83c9',
          'price': 10000,
          'category': 'Lutte',
          'organizerId': 'org1',
          'organizerName': 'Gaston Productions',
          'organizerAvatar': 'https://i.postimg.cc/59tVNvYk/sponsor1.jpg',
          'rating': 5,
          'isFeatured': true,
          'availableTickets': 1000,
          'soldTickets': 750,
        },
        {
          'title': 'Lutte: Ada Fass vs Boy Niang 2',
          'description': 'Un combat de lutte traditionnel entre deux espoirs de la lutte sénégalaise. Ada Fass de l\'écurie Fass et Boy Niang 2 de l\'écurie Pikine s\'affrontent dans un duel qui verra s\'opposer deux styles différents: la technique face à la puissance.',
          'date': dates[4].toIso8601String(),
          'location': 'Stade Iba Mar Diop',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Flutte.jpeg?alt=media&token=19ee35a9-4033-47fa-a54a-957e0afe83c9',
          'price': 5000,
          'category': 'Lutte',
          'organizerId': 'org2',
          'organizerName': 'Jambaar Productions',
          'organizerAvatar': 'https://i.postimg.cc/xd3qWP7S/sponsor2.jpg',
          'rating': 4,
          'isFeatured': false,
          'availableTickets': 800,
          'soldTickets': 350,
        },
        {
          'title': 'Journée de Lutte Traditionnelle',
          'description': 'Une journée complète dédiée à la lutte traditionnelle sénégalaise avec plusieurs combats au programme. Des lutteurs venus des différentes régions du Sénégal s\'affronteront pour célébrer cet art ancestral inscrit au patrimoine culturel immatériel de l\'humanité.',
          'date': dates[8].toIso8601String(),
          'location': 'Place du Souvenir, Dakar',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Flutte.jpeg?alt=media&token=19ee35a9-4033-47fa-a54a-957e0afe83c9',
          'price': 2000,
          'category': 'Lutte',
          'organizerId': 'org3',
          'organizerName': 'Comité National de Gestion de la Lutte',
          'organizerAvatar': 'https://i.postimg.cc/cL1vNNmh/sponsor3.jpg',
          'rating': 4,
          'isFeatured': false,
          'availableTickets': 600,
          'soldTickets': 200,
        },
        {
          'title': 'Tournoi des Espoirs de la Lutte',
          'description': 'Un tournoi dédié aux jeunes lutteurs sénégalais de moins de 25 ans. Ce tournoi vise à détecter les futurs champions de l\'arène et à promouvoir la relève dans la lutte sénégalaise.',
          'date': dates[15].toIso8601String(),
          'location': 'Centre de Formation CNGL, Parcelles Assainies',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Flutte.jpeg?alt=media&token=19ee35a9-4033-47fa-a54a-957e0afe83c9',
          'price': 1000,
          'category': 'Lutte',
          'organizerId': 'org1',
          'organizerName': 'Gaston Productions',
          'organizerAvatar': 'https://i.postimg.cc/59tVNvYk/sponsor1.jpg',
          'rating': 3,
          'isFeatured': false,
          'availableTickets': 400,
          'soldTickets': 50,
        },
      ];

      // CONCERT (4 événements)
      final concertSampleEvents = [
        {
          'title': 'Grand Concert de Youssou Ndour',
          'description': 'Concert exceptionnel du roi du Mbalax, Youssou Ndour, qui revient enchanter son public avec ses plus grands tubes et ses nouvelles créations. Une soirée inoubliable en perspective avec le plus grand artiste sénégalais.',
          'date': dates[1].toIso8601String(),
          'location': 'Grand Théâtre National de Dakar',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2FYoussou.jpg?alt=media&token=326d6ca0-d34f-4f20-b976-eb4d3cfc95d9',
          'price': 15000,
          'category': 'Concert',
          'organizerId': 'org2',
          'organizerName': 'Prince Arts',
          'organizerAvatar': 'https://i.postimg.cc/xd3qWP7S/sponsor2.jpg',
          'rating': 5,
          'isFeatured': true,
          'availableTickets': 800,
          'soldTickets': 650,
        },
        {
          'title': 'Soirée Rap Galsen All Stars',
          'description': 'Une soirée entièrement dédiée au rap sénégalais avec les plus grands noms de la scène locale: Dip Doundou Guiss, Omzo Dollar, Samba Peuzzi et bien d\'autres. Le meilleur du rap galsen sur une seule scène!',
          'date': dates[5].toIso8601String(),
          'location': 'Monument de la Renaissance Africaine',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Frap.jpeg?alt=media&token=f0a02aa2-f9a1-4554-8dc9-7e8757f2d54b',
          'price': 5000,
          'category': 'Concert',
          'organizerId': 'org4',
          'organizerName': 'Urban Culture',
          'organizerAvatar': 'https://i.postimg.cc/8ccdXyqN/sponsor4.jpg',
          'rating': 4,
          'isFeatured': false,
          'availableTickets': 1200,
          'soldTickets': 800,
        },
        {
          'title': 'Festival Afropolis',
          'description': 'Un grand festival de musiques africaines urbaines avec des artistes venus de tout le continent. Afrobeat, Hip-Hop, R&B et Trap africaine se mêleront pour une expérience musicale unique.',
          'date': dates[10].toIso8601String(),
          'location': 'Magic Land, Route de la Corniche',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Fafrolis.jpeg?alt=media&token=158c8d91-332a-4935-95ec-399f0c17ffcb',
          'price': 8000,
          'category': 'Concert',
          'organizerId': 'org5',
          'organizerName': 'Africa Music Events',
          'organizerAvatar': 'https://i.postimg.cc/cL1vNNmh/sponsor3.jpg',
          'rating': 4,
          'isFeatured': true,
          'availableTickets': 2000,
          'soldTickets': 1200,
        },
        {
          'title': 'Soirée Acoustique avec Wally Seck',
          'description': 'Une soirée intime en acoustique avec Wally Seck, l\'une des plus grandes voix du Sénégal. L\'artiste reprendra ses plus grands succès dans une ambiance feutrée propice à l\'émotion.',
          'date': dates[17].toIso8601String(),
          'location': 'Hôtel Radisson Blu, Dakar',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Fwally.jpg?alt=media&token=f35c92b1-e51c-4c73-b336-5120aa7ba23d',
          'price': 20000,
          'category': 'Concert',
          'organizerId': 'org2',
          'organizerName': 'Prince Arts',
          'organizerAvatar': 'https://i.postimg.cc/xd3qWP7S/sponsor2.jpg',
          'rating': 5,
          'isFeatured': false,
          'availableTickets': 300,
          'soldTickets': 280,
        },
      ];

      // FOOTBALL (3 événements)
      final footballSampleEvents = [
        {
          'title': 'Match Sénégal vs Côte d\'Ivoire',
          'description': 'Match de qualification pour la Coupe d\'Afrique des Nations 2025. Les Lions de la Téranga affronteront les Éléphants dans ce qui s\'annonce comme l\'un des plus grands chocs du football africain.',
          'date': dates[2].toIso8601String(),
          'location': 'Stade Abdoulaye Wade, Diamniadio',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2FSenegal-Cote-d-Ivoire.jpg?alt=media&token=41e2637f-ad4c-48e9-9e32-b487bd96e826',
          'price': 5000,
          'category': 'Football',
          'organizerId': 'org3',
          'organizerName': 'Fédération Sénégalaise de Football',
          'organizerAvatar': 'https://i.postimg.cc/cL1vNNmh/sponsor3.jpg',
          'rating': 5,
          'isFeatured': true,
          'availableTickets': 2000,
          'soldTickets': 1800,
        },
        {
          'title': 'Finale Super Coupe du Sénégal',
          'description': 'La finale de la Super Coupe du Sénégal opposera le champion de la Ligue 1 au vainqueur de la Coupe du Sénégal. Un match qui promet du spectacle et du suspense pour déterminer le meilleur club sénégalais de la saison.',
          'date': dates[6].toIso8601String(),
          'location': 'Stade Léopold Sédar Senghor, Dakar',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Fligue%201.jpg?alt=media&token=832bc554-a1e4-43ea-8a73-bc36c4945568',
          'price': 3000,
          'category': 'Football',
          'organizerId': 'org3',
          'organizerName': 'Fédération Sénégalaise de Football',
          'organizerAvatar': 'https://i.postimg.cc/cL1vNNmh/sponsor3.jpg',
          'rating': 4,
          'isFeatured': false,
          'availableTickets': 1500,
          'soldTickets': 1000,
        },
        {
          'title': 'Tournoi de Football Jeunes Talents',
          'description': 'Un tournoi destiné aux jeunes footballeurs de 15 à 18 ans venus des quatre coins du Sénégal. Ce tournoi, suivi par plusieurs recruteurs européens, est une occasion pour ces talents de se faire remarquer.',
          'date': dates[12].toIso8601String(),
          'location': 'Centre d\'Excellence Jules Bocandé, Toubab Dialaw',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Fligue%201.jpg?alt=media&token=832bc554-a1e4-43ea-8a73-bc36c4945568',
          'price': 1000,
          'category': 'Football',
          'organizerId': 'org6',
          'organizerName': 'Association des Jeunes Footballeurs',
          'organizerAvatar': 'https://i.postimg.cc/59tVNvYk/sponsor1.jpg',
          'rating': 3,
          'isFeatured': false,
          'availableTickets': 800,
          'soldTickets': 400,
        },
      ];

      // BASKET (3 événements)
      final basketSampleEvents = [
        {
          'title': 'Tournoi de Basket 3x3 Dakar',
          'description': 'Tournoi de basketball 3x3 avec les meilleurs joueurs du Sénégal et de la sous-région. Le basket 3x3, nouvelle discipline olympique, trouve au Sénégal un terrain d\'expression privilégié.',
          'date': dates[3].toIso8601String(),
          'location': 'Terrain de Basket de l\'UCAD',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2F3vs3%20basket.jpeg?alt=media&token=6df2ad2a-412a-46d2-9228-4fb50cf237da',
          'price': 2000,
          'category': 'Basket',
          'organizerId': 'org4',
          'organizerName': 'Ligue de Basket de Dakar',
          'organizerAvatar': 'https://i.postimg.cc/8ccdXyqN/sponsor4.jpg',
          'rating': 4,
          'isFeatured': false,
          'availableTickets': 500,
          'soldTickets': 300,
        },
        {
          'title': 'Match All-Star de la NBA Africa League',
          'description': 'Un match d\'exhibition réunissant les meilleurs joueurs de la Basketball Africa League, branche africaine de la NBA. Venez admirer les dunks et actions spectaculaires des stars du basket africain.',
          'date': dates[9].toIso8601String(),
          'location': 'Dakar Arena, Diamniadio',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Fnba.jpg?alt=media&token=8ec6219a-98d7-4bd2-857f-cc2d24a91bbd',
          'price': 7000,
          'category': 'Basket',
          'organizerId': 'org4',
          'organizerName': 'NBA Africa',
          'organizerAvatar': 'https://i.postimg.cc/8ccdXyqN/sponsor4.jpg',
          'rating': 5,
          'isFeatured': true,
          'availableTickets': 1000,
          'soldTickets': 950,
        },
        {
          'title': 'Finale du Championnat de Basket',
          'description': 'La finale du championnat national de basketball qui mettra aux prises les deux meilleures équipes de la saison. Le basketball sénégalais, plusieurs fois champion d\'Afrique, promet un spectacle de qualité.',
          'date': dates[14].toIso8601String(),
          'location': 'Stadium Marius Ndiaye, Dakar',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Fbasket.jpeg?alt=media&token=92f5dca2-8a71-415a-b0e9-a8ccc95a8fa5',
          'price': 1500,
          'category': 'Basket',
          'organizerId': 'org4',
          'organizerName': 'Fédération Sénégalaise de Basketball',
          'organizerAvatar': 'https://i.postimg.cc/8ccdXyqN/sponsor4.jpg',
          'rating': 4,
          'isFeatured': false,
          'availableTickets': 800,
          'soldTickets': 500,
        },
      ];

      // CULTURE (3 événements)
      final cultureSampleEvents = [
        {
          'title': 'Festival des Arts Traditionnels du Sénégal',
          'description': 'Festival culturel présentant les arts traditionnels des différentes ethnies du Sénégal: danse, musique, costumes et artisanat. Une immersion totale dans le patrimoine culturel sénégalais.',
          'date': dates[7].toIso8601String(),
          'location': 'Musée des Civilisations Noires, Dakar',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Ffestival.jpeg?alt=media&token=856540a4-f33c-4b48-ad42-4febf600dc50',
          'price': 3000,
          'category': 'Culture',
          'organizerId': 'org5',
          'organizerName': 'Ministère de la Culture',
          'organizerAvatar': 'https://i.postimg.cc/cL1vNNmh/sponsor3.jpg',
          'rating': 4,
          'isFeatured': false,
          'availableTickets': 300,
          'soldTickets': 200,
        },
        {
          'title': 'Exposition d\'Art Contemporain Africain',
          'description': 'Une exposition collective d\'art contemporain africain réunissant les œuvres d\'artistes émergents et confirmés du continent. Peintures, sculptures et installations reflètent la créativité et la diversité de l\'art africain contemporain.',
          'date': dates[11].toIso8601String(),
          'location': 'Galerie Le Manège, Institut Français',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Fart_compt.jpeg?alt=media&token=5d432831-4efa-47d1-995d-4bb35c701307',
          'price': 1500,
          'category': 'Culture',
          'organizerId': 'org5',
          'organizerName': 'Institut Français du Sénégal',
          'organizerAvatar': 'https://i.postimg.cc/cL1vNNmh/sponsor3.jpg',
          'rating': 5,
          'isFeatured': true,
          'availableTickets': 200,
          'soldTickets': 150,
        },
        {
          'title': 'Festival International du Film de Dakar',
          'description': 'Le premier festival international du cinéma à Dakar, réunissant des films du monde entier avec un focus particulier sur les productions africaines. Projections, masterclass et rencontres avec les réalisateurs sont au programme.',
          'date': dates[16].toIso8601String(),
          'location': 'Complexe Cinématographique de Dakar',
          'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/eventsn-cd5a9.firebasestorage.app/o/events%2Ffilm.jpeg?alt=media&token=84354f88-9461-4818-a457-47bf9e799b7c',
          'price': 4000,
          'category': 'Culture',
          'organizerId': 'org7',
          'organizerName': 'Association pour la Promotion du Cinéma Africain',
          'organizerAvatar': 'https://i.postimg.cc/8ccdXyqN/sponsor4.jpg',
          'rating': 4,
          'isFeatured': false,
          'availableTickets': 500,
          'soldTickets': 300,
        },
      ];

      // Combiner tous les événements
      final allSampleEvents = [
        ...lutteSampleEvents,
        ...concertSampleEvents,
        ...footballSampleEvents,
        ...basketSampleEvents,
        ...cultureSampleEvents,
      ];

      // Ajouter les événements à Firestore
      for (final eventData in allSampleEvents) {
        await _eventsCollection.add(eventData);
      }

      debugPrint('Événements de test enrichis ajoutés avec succès! Total: ${allSampleEvents.length} événements');
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout des événements de test: $e');
    }
  }
}