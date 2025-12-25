import 'package:flutter/material.dart';
import 'package:korail_ai_agent/reservation/reservation_screen.dart';
import 'onboarding/start_screen.dart';
import 'onboarding/guide_screen.dart';
import 'onboarding/guide_screen_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Korail AI Agent',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003D5B)),
        useMaterial3: true,
      ),
      home: const StartScreen(),
      routes: {
        '/guide': (context) => const GuideScreen(),
        '/guide2': (context) => const GuideScreen2(),
        '/reservation': (context) => const ReservationScreen(),
      },
    );
  }
}
