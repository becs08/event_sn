import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/events/presentation/screens/event_detail_screen.dart';
import 'features/events/presentation/screens/view_all_screen.dart';
import 'core/services/firebase_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

// Définir cette constante à true pour le développement, false en production
const bool FORCE_LOGIN_SCREEN = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialiser Firebase
  await FirebaseService.initialize(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Déconnexion pour les tests
  if (FORCE_LOGIN_SCREEN) {
    await FirebaseAuth.instance.signOut();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventSN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: FORCE_LOGIN_SCREEN ? const LoginScreen() : const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/view_all': (context) => const ViewAllScreen(),
        '/event_detail': (context) => const EventDetailScreen(),
      },
    );
  }
}

// Wrapper pour gérer l'authentification
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si l'utilisateur est connecté, afficher la page d'accueil
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        // Sinon, afficher la page de connexion
        return const LoginScreen();
      },
    );
  }
}
