import 'package:flutter/material.dart';
import '../payment/payment_screen_1.dart';
import '../components/ai_guide_zone.dart';
import '../components/custom_header.dart';
import '../components/bottom_nav_bar.dart';

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
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // Top Navigation Bar
                  CustomHeader(
                    title: '승차권 정보 확인',
                    topMargin: 0,
                    backgroundColor: const Color(0xFF003D5B),
                    showBackButton: true,
                    backIcon: Icons.close,
                    showBackButtonOnRight: true,
                    onBackPressed: () => Navigator.pop(context),
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

                  const SizedBox(height: 280), // Space for AiGuideZone + Payment + NavBar
                ],
              ),
            ),

            // AI Guide Zone
            Positioned(
              left: 0,
              right: 0,
              bottom: 142, // Payment button (72) + BottomNavBar (70)
              child: AiGuideZone(
                guideText: '예약 정보가 맞으면\n결제하기를 눌러주세요',
                height: 130,
                fontSize: 20,
                wrapWithPositioned: false,
              ),
            ),

            // Payment Button (Fixed at bottom)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  BottomNavBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
