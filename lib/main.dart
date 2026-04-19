import 'package:flutter/material.dart';
import 'package:turath_hackathon/screens/leaderboard_screen.dart';
import 'package:turath_hackathon/screens/main_screen.dart';
import 'package:turath_hackathon/screens/play_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.init();
    await NotificationService.scheduleDailyChallenge();
  } catch (e) {
    debugPrint('⚠️ Notification init failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
