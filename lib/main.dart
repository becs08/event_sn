import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/events/presentation/screens/event_detail_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/events/presentation/screens/view_all_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/view_all': (context) => const ViewAllScreen(),
        '/event_detail': (context) => const EventDetailScreen(),
      },
    );
  }
}