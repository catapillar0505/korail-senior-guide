import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int currentGuideIndex = 0;
  String displayedText = '';
  bool showNextButton = true;
  bool isDanbiHighlighted = false;
  bool isDanbiSpeaking = false;

  final List<String> guideTexts = [
    '안녕하세요, AI 안내원 단비입니다!\n저는 앞으로 여기서 안내를 도와줄게요',
    '질문이 있을 때는 저를 눌러주세요!',
    '한번 연습해볼까요?\n저를 누르고 "왕복으로 하고 싶어."\n라고 말해주세요',
    '"왕복으로 하고 싶어."',
  ];

  @override
  void initState() {
    super.initState();
    displayedText = guideTexts[0];
  }

  Future<void> _typeWriterEffect(String text) async {
    setState(() {
      displayedText = '';
    });

    for (int i = 0; i < text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          displayedText = text.substring(0, i + 1);
        });
      }
    }
  }

  void _onNextPressed() async {
    if (currentGuideIndex == 0) {
      // First click - show guideTexts[1] and blink Danbi button after 1 second
      setState(() {
        currentGuideIndex = 1;
        displayedText = guideTexts[1];
      });
      await Future.delayed(const Duration(seconds: 1));
      _blinkDanbiButton();
    } else if (currentGuideIndex == 1) {
      // Second click - show guideTexts[2], hide next button, and blink after 2 seconds
      setState(() {
        currentGuideIndex = 2;
        showNextButton = false;
        displayedText = guideTexts[2];
      });
      // Wait 2 seconds then blink Danbi button
      await Future.delayed(const Duration(seconds: 2));
      _blinkDanbiButton();
    }
  }

  void _blinkDanbiButton() async {
    for (int i = 0; i < 2; i++) {
      setState(() {
        isDanbiHighlighted = true;
      });
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        isDanbiHighlighted = false;
      });
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  void _onDanbiPressed() async {
    if (currentGuideIndex == 2) {
      // Change to speak button
      setState(() {
        isDanbiSpeaking = true;
      });

      // Show guideTexts[3] with typing effect after 3 seconds
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        currentGuideIndex = 3;
      });
      await _typeWriterEffect(guideTexts[3]);

      // Navigate to guide_screen_2 after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/guide2');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            // Original Content
            Column(
              children: [
                // Top Navigation Bar (Image)
                Image.asset(
                  'assets/figma_images/onboarding/top-navbar.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title and options
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '승차권 예매',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFBDBDBD),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '왕복',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.more_vert,
                                  color: Color(0xFF666666),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1, color: Color(0xFFE0E0E0)),

                      // Station Selection Section
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            // Departure and Arrival Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Departure Section
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        '출발',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF999999),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        '서울',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF003D5B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Swap Button
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFF003D5B),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.swap_horiz,
                                      color: Color(0xFF003D5B),
                                      size: 24,
                                    ),
                                  ),
                                ),

                                // Arrival Section
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        '도착',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF999999),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        '부산',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF003D5B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Date Selection
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '가는날',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF0288D1),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '2025년 07월 17일 (목) 18:12',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFF999999),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Passenger Selection
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '인원선택',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF0288D1),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '경로 1명',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFF999999),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB0D4E3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '간편구매',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF003D5B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB0D4E3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '열차조회',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF003D5B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
            ],
          ),

          // Dark Overlay with Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),

          // Guide Text and Next Button
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayedText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                if (showNextButton)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _onNextPressed,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        '다음 >',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
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
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Button (Image)
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/figma_images/onboarding/home-bnt.png',
                  fit: BoxFit.contain,
                ),
              ),

              // Danbi Button (Custom or Speak Button)
              GestureDetector(
                onTap: _onDanbiPressed,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 140,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDanbiHighlighted
                        ? const Color(0xFFCDE0EE)
                        : const Color(0xFF003D5B),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: isDanbiSpeaking
                        ? SvgPicture.asset(
                            'assets/figma_images/onboarding/speak-icon.svg',
                            width: 36,
                            height: 36,
                          )
                        : Text(
                            '단비',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDanbiHighlighted
                                  ? const Color(0xFF003D5B)
                                  : Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              // My Ticket Button (Image)
              Container(
                width: 80,
                height: 80,
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  'assets/figma_images/onboarding/ticket-bnt.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
