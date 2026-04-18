import 'package:flutter/material.dart';
import 'package:turath_hackathon/screens/main_screen.dart';
// import 'main_screen.dart'; // استورد شاشة المدير

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), // هنا السحر! لازم تشغل MainScreen
    );
  }
}
