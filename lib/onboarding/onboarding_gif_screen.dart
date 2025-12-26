import 'package:flutter/material.dart';

class OnboardingGifScreen extends StatelessWidget {
  const OnboardingGifScreen({super.key});

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
                    'assets/figma_images/onboarding/onboarding-gif.gif',
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
                    '만약 도움이 필요할 땐\n‘도움버튼’을 눌러 말해주세요',
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
                        Navigator.pushNamed(context, '/last');
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
