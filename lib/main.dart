import 'package:flutter/material.dart';
import 'package:turath_hackathon/screens/free_play_screen.dart';
import 'package:turath_hackathon/screens/settings_screen.dart';
import 'package:turath_hackathon/screens/stats_screen.dart';
// سوينا إمبورت لملف الشاشة الرئيسية
import 'screens/home_screen.dart';

void main() {
  runApp(const SiyakApp());
}

class SiyakApp extends StatelessWidget {
  const SiyakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سياق المعنى',
      // إجبار التطبيق على الاتجاه من اليمين لليسار عشان العربي
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const SettingsScreen(),
    );
  }
}
