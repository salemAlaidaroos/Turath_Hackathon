import 'package:flutter/material.dart';
import 'package:turath_hackathon/screens/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:turath_hackathon/screens/play_screen.dart'; // أضف هذا السطر

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ==========================================
      // هذي الأسطر تجبر التطبيق والكيبورد يدعمون العربي
      // ==========================================
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // دعم اللغة العربية (السعودية)
        Locale('en', 'US'), // دعم الإنجليزي كاحتياط
      ],
      locale: const Locale('ar', 'SA'), // إجبار التطبيق يبدأ بالعربي
      // ==========================================
      home: const PlayScreen(),
    );
  }
}
