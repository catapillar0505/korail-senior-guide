import 'package:flutter/material.dart';
import 'payment_screen_2.dart';
import '../components/layouts/custom_layout.dart';

class PaymentScreen1 extends StatelessWidget {
  const PaymentScreen1({super.key});

  String get todayDate {
    final now = DateTime.now();
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final weekday = weekdays[now.weekday % 7];
    return '${now.year}년 ${now.month}월 ${now.day}일 ($weekday)';
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      headerTitle: '결제',
      showGuideZone: true,
      guideText: '총 2매  65,600원이에요',
      guideTextAlignment: const Alignment(0, -0.3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 140), // Bottom buttons(70) + BottomNavBar(70)
        child: Column(
          children: [
            // Date
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                todayDate,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B4FA3),
                ),
              ),
            ),

            // Train info
            const Text(
              'KTX-산천 9419',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B4FA3),
              ),
            ),
            const SizedBox(height: 40),

            // Route
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      '용산',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '13:30',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 40),
                const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF6B4FA3),
                  size: 32,
                ),
                const SizedBox(width: 40),
                Column(
                  children: [
                    const Text(
                      '광주송정',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '16:26',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Seat info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '5호차 4C 외 1석',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '상세',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B4FA3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Price info
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildPriceRow('운임', '93,600원'),
                  _buildPriceRow('요금', '0원'),
                  _buildPriceRow('운임할인', '-28,000원'),
                  _buildPriceRow('요금할인', '0원'),
                  const Divider(height: 32, thickness: 1),
                  _buildPriceRow('결제금액', '65,600원', isBold: true),
                  const SizedBox(height: 8),
                  const Text(
                    '* 특(우등)실은 운임과 요금으로 구성되며 운임만 할인됨',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            // Discount info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '할인쿠폰 적용',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      overlayWidgets: [
        // Bottom buttons - positioned above BottomNavBar
        Positioned(
          bottom: 0, // BottomNavBar height
          left: 0,
          right: 0,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: const Color(0xFFE8E8F0),
                      child: const Center(
                        child: Text(
                          '예약취소',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B4FA3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentScreen2(),
                        ),
                      );
                    },
                    child: Container(
                      color: const Color(0xFF6B4FA3),
                      child: const Center(
                        child: Text(
                          '다음',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
