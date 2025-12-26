import 'package:flutter/material.dart';

class OnboardingImageScreen extends StatelessWidget {
  const OnboardingImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 이미지 영역
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Image.asset(
                    'assets/figma_images/onboarding/onboarding-image.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // 텍스트 + 버튼 영역
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  const Text(
                    '저는 언제나 화면 아래에서\n안내를 도울거예요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 66,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/gif');
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
