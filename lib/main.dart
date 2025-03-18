import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/events/presentation/screens/event_detail_screen.dart';
import 'features/events/presentation/screens/view_all_screen.dart';
import 'core/services/firebase_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialiser Firebase
  await FirebaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventSN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/view_all': (context) => const ViewAllScreen(),
        '/event_detail': (context) => const EventDetailScreen(),
      },
    );
  }
}