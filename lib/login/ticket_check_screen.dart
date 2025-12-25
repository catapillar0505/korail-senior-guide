import 'package:flutter/material.dart';
import '../payment/payment_screen_1.dart';

class TicketCheckScreen extends StatefulWidget {
  const TicketCheckScreen({super.key});

  @override
  State<TicketCheckScreen> createState() => _TicketCheckScreenState();
}

class _TicketCheckScreenState extends State<TicketCheckScreen> {
  String get todayDate {
    final now = DateTime.now();
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final weekday = weekdays[now.weekday % 7];
    return '${now.year}년 ${now.month}월 ${now.day}일 ($weekday)';
  }

  String get paymentDeadline {
    final deadline = DateTime.now().add(const Duration(days: 3));
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final weekday = weekdays[deadline.weekday % 7];
    final hour = deadline.hour.toString().padLeft(2, '0');
    final minute = deadline.minute.toString().padLeft(2, '0');
    return '${deadline.year}. ${deadline.month}. ${deadline.day}($weekday) $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
            SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // Top Navigation Bar
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    height: 70,
                    color: const Color(0xFF003D5B),
                    child: Stack(
                      children: [
                        const Center(
                          child: Text(
                            '승차권 정보 확인',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 24,
                          top: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Ticket Information Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and Count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            todayDate,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                          const Text(
                            '2매',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Train Info
                      const Text(
                        '[KTX-산천 9419] 용산(13:30) →',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '광주송정(16:26)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '일반실 5호차 6C, 일반실 5호차 6D',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Payment Deadline
                      const Text(
                        '결제기한',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        paymentDeadline,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '기한 내 미결제시 승차권이 자동 취소됩니다.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Cancel Reservation Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '예약 취소',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Caution Section
                Container(
                  color: const Color(0xFFF5F5F5),
                  padding: const EdgeInsets.all(24.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• 결제하지 않으면 예약이 취소됩니다.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• 승차권을 발권받은 스마트폰에서만 확인할 수 있습니다.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• 할인승차권 이용시에는 관련 신분증 또는 증명서를 소지하셔야 합니다.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                  const SizedBox(height: 250), // Space for fixed bottom elements
                ],
              ),
            ),

            // Text Guide and Payment Button (Fixed at bottom)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text Guide Area
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          const Color(0xFFB5D4ED).withOpacity(0.75),
                          const Color(0xFFB5D4ED).withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.3],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: const Center(
                      child: Text(
                        '예약 정보가 맞으면\n결제하기를 눌러주세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),

                  // Payment Button
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentScreen1(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90E2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            '결제하기',
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

                  // Bottom Navigation Bar
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
                        // Home Button
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

                        // Danbi Button
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

                        // My Ticket Button
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
                ],
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
