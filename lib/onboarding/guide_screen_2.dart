import 'package:flutter/material.dart';
import 'dart:async';

class GuideScreen2 extends StatefulWidget {
  const GuideScreen2({super.key});

  @override
  State<GuideScreen2> createState() => _GuideScreen2State();
}

class _GuideScreen2State extends State<GuideScreen2> {
  bool isBlinking = true;
  bool showFirstOval = true;
  Timer? _blinkTimer;
  int currentGuideIndex = 0;
  String displayedText = '';
  bool showOverlay = false;
  bool showNextButton = false;
  bool isCheckboxChecked = false;

  final List<String> guideTexts = [
    '왕복 버튼은 여기 있어요!\n눌러주세요',
    '잘하셨어요!\n앞으로도 어려움이 있을 땐\n저를 눌러주세요😊',
  ];

  @override
  void initState() {
    super.initState();
    _startBlinking();
    displayedText = guideTexts[0];
  }

  void _startBlinking() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted && isBlinking) {
        setState(() {
          showFirstOval = !showFirstOval;
        });
      }
    });
  }

  void _stopBlinking() {
    setState(() {
      isBlinking = false;
    });
    _blinkTimer?.cancel();
  }

  void _onCheckboxTapped() async {
    if (!isCheckboxChecked) {
      _stopBlinking();
      setState(() {
        isCheckboxChecked = true;
        showOverlay = true;
        currentGuideIndex = 1;
        displayedText = guideTexts[1];
        showNextButton = true;
      });
    }
  }

  void _onNextPressed() {
    Navigator.pushReplacementNamed(context, '/reservation');
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
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
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Blinking oval effect
                                if (isBlinking)
                                  AnimatedOpacity(
                                    opacity: 1.0,
                                    duration: const Duration(milliseconds: 500),
                                    child: Container(
                                      width: 120,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: showFirstOval
                                            ? const Color(0xFFE8AFAF).withOpacity(0.75)
                                            : const Color(0xFFFF5959).withOpacity(0.35),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                // Checkbox and text
                                GestureDetector(
                                  onTap: _onCheckboxTapped,
                                  child: Row(
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
                                          color: isCheckboxChecked
                                              ? const Color(0xFF003D5B)
                                              : Colors.transparent,
                                        ),
                                        child: isCheckboxChecked
                                            ? const Icon(
                                                Icons.check,
                                                size: 18,
                                                color: Colors.white,
                                              )
                                            : null,
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

          // Dark Overlay with Gradient (shown when checkbox is checked)
          if (showOverlay)
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

          // Guide Zone with Gradient Background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFFB5D4ED).withOpacity(0.0),
                    const Color(0xFFB5D4ED).withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.3],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      displayedText,
                      textAlign: currentGuideIndex == 0 ? TextAlign.center : TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: currentGuideIndex == 0 ? FontWeight.bold : FontWeight.w600,
                        color: currentGuideIndex == 0 ? Colors.black : Colors.white,
                        height: 1.5,
                      ),
                    ),
                    if (showNextButton)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _onNextPressed,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(top: 10),
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

              // Danbi Button (Custom)
              Container(
                width: 140,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF003D5B),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Center(
                  child: Text(
                    '단비',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // My Ticket Button (Image)
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
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
