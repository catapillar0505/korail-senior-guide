import 'package:flutter/material.dart';
import 'dart:ui';

class StartScreen2 extends StatelessWidget {
  const StartScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 🔵 큰 하늘색 원 배경 (블러 처리)
            Positioned(
              top: 200,
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
                children: [
                  const SizedBox(height: 320),

                  const Text(
                    'AI 단비는 온라인 예매가\n어려운 분들을 위해\n단계마다 설명과 도움을 드려요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 66,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/onboarding-image');
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
                        '다음',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
