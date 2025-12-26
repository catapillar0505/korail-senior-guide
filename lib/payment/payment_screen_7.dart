import 'package:flutter/material.dart';
import 'payment_screen_8.dart';
import 'payment_screen_final.dart';
import '../components/bottom_nav_bar.dart';

class PaymentScreen7 extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;

  const PaymentScreen7({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
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
                // Check icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D5A9B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 80,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // Success text
                const Text(
                  '결제 성공!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 80),

                // Question text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    '결제하신 카드를 자주쓰는 카드로\n등록하시겠습니까?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Buttons
          Row(
            children: [
              // 아니오 button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentScreenFinal(),
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    color: const Color(0xFFD9E6F2),
                    child: const Center(
                      child: Text(
                        '아니오',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D5A9B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                width: 1,
                height: 100,
                color: Colors.white,
              ),

              // 네 button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen8(
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    color: const Color(0xFFD9E6F2),
                    child: const Center(
                      child: Text(
                        '네',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D5A9B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom navigation bar
          const BottomNavBar(),
        ],
            ),
          ],
        ),
      ),
    );
  }
}
