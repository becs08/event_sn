import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/user.dart' as app_user;

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenir l'utilisateur actuel
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  // Stream pour suivre les changements d'état d'authentification
  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // S'inscrire avec e-mail et mot de passe
  Future<app_user.User?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Créer un nouvel utilisateur avec Firebase Auth
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Mettre à jour le nom d'utilisateur
        await credential.user!.updateDisplayName(displayName);

        // Créer un document utilisateur dans Firestore
        final user = app_user.User(
          id: credential.user!.uid,
          email: email,
          displayName: displayName,
        );

        await _firestore.collection('users').doc(credential.user!.uid).set(user.toFirestore());

        return user;
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'inscription: $e');
    }
    return null;
  }

  // Se connecter avec e-mail et mot de passe
  Future<app_user.User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Récupérer les données utilisateur depuis Firestore
        final doc = await _firestore.collection('users').doc(credential.user!.uid).get();

        if (doc.exists) {
          return app_user.User.fromFirestore(doc.data()!, doc.id);
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la connexion: $e');
    }
    return null;
  }

  // Se déconnecter
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Récupérer les données d'un utilisateur depuis Firestore
  Future<app_user.User?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return app_user.User.fromFirestore(doc.data()!, doc.id);
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération des données utilisateur: $e');
    }
    return null;
  }

  // Mettre à jour les données d'un utilisateur
  Future<bool> updateUserData(app_user.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toFirestore());
      return true;
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour des données utilisateur: $e');
      return false;
    }
  }
}