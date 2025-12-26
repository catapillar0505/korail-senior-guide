import 'package:flutter/material.dart';
import 'dart:ui';

class LastScreen extends StatelessWidget {
  const LastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 🔵 큰 하늘색 원 배경 (블러 처리)
            Positioned(
              top: 130,
              left: -150,
              right: -150,
              child: Container(
                height: 350,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      Color(0xFFD6EAF8),  // 중심 - 진한 하늘색
                      Color(0xFFEBF5FB),  // 중간
                      Color(0xFFF8FCFF),  // 외곽 - 매우 연한 하늘색
                      Colors.white,       // 가장자리 - 투명하게
                    ],
                    stops: [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            // 블러 필터 적용
            Positioned(
              top: 100,
              left: -150,
              right: -150,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(
                    height: 450,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            // 🔹 콘텐츠
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Main text
                  const Text(
                  '그럼 이제 저와 함께\n예매해볼까요?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Start button
                  SizedBox(
                    width: double.infinity,
                    height: 66,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reservation');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003D5B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '네 함께할래요!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Skip button
                  SizedBox(
                    width: double.infinity,
                    height: 66,
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate to main screen
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF9E9E9E),
                        side: const BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 1,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '혼자 해볼게요',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
