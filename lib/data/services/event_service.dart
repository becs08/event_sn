import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../../../../data/models/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Référence à la collection events
  CollectionReference get _eventsCollection => _firestore.collection('events');

  // Récupérer tous les événements
  Stream<List<Event>> getEvents() {
    return _eventsCollection
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Récupérer les événements par catégorie
  Stream<List<Event>> getEventsByCategory(String category) {
    return _eventsCollection
        .where('category', isEqualTo: category)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Récupérer les événements à la une
  Stream<List<Event>> getFeaturedEvents() {
    return _eventsCollection
        .where('isFeatured', isEqualTo: true)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Récupérer un événement par ID
  Future<Event?> getEventById(String id) async {
    try {
      final doc = await _eventsCollection.doc(id).get();
      if (doc.exists) {
        return Event.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'événement: $e');
    }
    return null;
  }

  // Ajouter un nouvel événement
  Future<String?> addEvent(Event event, File imageFile) async {
    try {
      // Uploader l'image dans Firebase Storage
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = _storage.ref().child('events/$fileName');
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Créer un nouvel événement avec l'URL de l'image
      final eventWithImage = event.copyWith(imageUrl: downloadUrl);

      // Ajouter l'événement à Firestore
      final docRef = await _eventsCollection.add(eventWithImage.toFirestore());
      return docRef.id;
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout de l\'événement: $e');
      return null;
    }
  }

  // Mettre à jour un événement
  Future<bool> updateEvent(Event event, {File? newImageFile}) async {
    try {
      String imageUrl = event.imageUrl;

      // Si une nouvelle image est fournie, la télécharger
      if (newImageFile != null) {
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = _storage.ref().child('events/$fileName');
        final UploadTask uploadTask = storageRef.putFile(newImageFile);

        final TaskSnapshot taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      // Mettre à jour l'événement avec la nouvelle URL d'image
      final updatedEvent = event.copyWith(imageUrl: imageUrl);

      await _eventsCollection.doc(event.id).update(updatedEvent.toFirestore());
      return true;
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de l\'événement: $e');
      return false;
    }
  }

  // Supprimer un événement
  Future<bool> deleteEvent(String id) async {
    try {
      await _eventsCollection.doc(id).delete();
      return true;
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'événement: $e');
      return false;
    }
  }
}