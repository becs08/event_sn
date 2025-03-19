import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Se connecter avec email & mot de passe
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      debugPrint("Erreur d'authentification: $e");
      rethrow;
    }
  }

  // S'inscrire avec email & mot de passe
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mettre à jour le nom d'utilisateur
      await userCredential.user?.updateDisplayName(name);

      return userCredential;
    } catch (e) {
      debugPrint("Erreur d'inscription: $e");
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Stream pour l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}