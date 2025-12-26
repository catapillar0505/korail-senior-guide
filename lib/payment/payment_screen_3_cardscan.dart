import 'package:flutter/material.dart';
import 'payment_screen_4.dart';

class PaymentScreen3CardScan extends StatelessWidget {
  const PaymentScreen3CardScan({super.key});

  void _onNextPressed(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentScreen4(),
      ),
    );

    // If we got card data back from the camera screens, return it to payment_screen_3
    if (result != null && result is Map<String, String>) {
      if (context.mounted) {
        Navigator.pop(context, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
        children: [
          // Top bar
          Container(
            height: 50,
            color: const Color(0xFF003D5B),
          ),

          // Main content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Camera icon
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1976D2),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: const Icon(
                    Icons.photo_camera,
                    size: 80,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // Text: 카드 스캔
                const Text(
                  '카드 스캔',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const Spacer(),

                // Guide text and next button
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFFB5D4ED).withOpacity(0.75),
                        const Color(0xFFB5D4ED).withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.5],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          '카드를 찍기 위해 카메라가 필요해요\n다음에 나오는 권한을 선택해주세요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Next button
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0, bottom: 24.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () => _onNextPressed(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003D5B), // 배경색
                              foregroundColor: Colors.white, // 글자색
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('다음'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom navigation bar
          Container(
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
                // Home button
                Container(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    'assets/figma_images/onboarding/home-bnt.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // Danbi button
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

                // My Ticket button
                Container(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    'assets/figma_images/onboarding/ticket-bnt.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
          ),

          // Status bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top,
              color: const Color(0xFF0C3C61),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox.shrink(),
      ),
    );
  }
}
