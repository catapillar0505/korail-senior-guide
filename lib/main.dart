import 'package:flutter/material.dart';
import 'package:korail_ai_agent/onboarding/last_screen.dart';
import 'package:korail_ai_agent/onboarding/onboarding_gif_screen.dart';
import 'package:korail_ai_agent/onboarding/onboarding_image_screen.dart';
import 'package:korail_ai_agent/onboarding/start_screen_2.dart';
import 'package:korail_ai_agent/reservation/reservation_screen.dart';
import 'onboarding/start_screen.dart';

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
        '/reservation': (context) => const ReservationScreen(),
        '/start2': (context) => const StartScreen2(),
        '/onboarding-image': (context) => const OnboardingImageScreen(),
        '/gif': (context) => const OnboardingGifScreen(),
        '/last': (context) => const LastScreen(),
      },
    );
  }
}
