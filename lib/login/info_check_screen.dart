import 'package:flutter/material.dart';
import 'ticket_check_screen.dart';
import '../components/custom_header.dart';
import '../components/bottom_nav_bar.dart';

class InfoCheckScreen extends StatefulWidget {
  final String name;
  final String phone;

  const InfoCheckScreen({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  State<InfoCheckScreen> createState() => _InfoCheckScreenState();
}

class _InfoCheckScreenState extends State<InfoCheckScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Navigation Bar
          CustomHeader(
            title: '비회원',
          ),

            // Content with Stack
          Expanded(
            child: Stack(
              children: [
                // Main Content
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 140, // 아니오/네 버튼(70) + BottomNavBar(70)
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          // Title
                          const Text(
                            '이용안내',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Divider
                          Container(
                            height: 2,
                            color: const Color(0xFFE0E0E0),
                          ),
                          const SizedBox(height: 16),

                          // Main Description
                          const Text(
                            '이름, 전화번호는 승차권 반환, 확인을\n위한 필수정보입니다.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // User Info Display
                          Text(
                            '이름 : ${widget.name}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '전화번호 : ${widget.phone}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.8,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Notice Text
                          const Text(
                            '※ 승차권 구입, 원활한 고객상담, 각종 서비스의 제공을 위해 아래와 같은 최소한의 개인정보를 필수항목으로 수집하고 있습니다.\n개인정보 수집 및 이용에 동의하지 않을 권리가 있으나, 동의하지 않는 경우 승차권 구매가 제한되며, 역창구에서 구매하실 수 있습니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Collection Info
                          const Text(
                            '- 수집정보 : 이름, 연락처, 비밀번호',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '- 보유기간 : 승차종료일로부터 최대 2년',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.8,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Consent Question
                          const Text(
                            '개인정보 수집 및 이용에 대한 안내에\n동의하십니까?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Checkbox
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFF666666),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: isChecked
                                      ? const Icon(
                                          Icons.check,
                                          size: 18,
                                          color: Color(0xFF003D5B),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  '위 내용에 대해 확인하였습니다.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
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

                // "아니오"/"네" Buttons (Fixed at bottom, above BottomNavBar)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 70, // BottomNavBar 높이
                  child: Container(
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // "아니오" Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: const Color(0xFFE8F4FC),
                              child: const Center(
                                child: Text(
                                  '아니오',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF003D5B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // "네" Button
                        Expanded(
                          child: GestureDetector(
                            onTap: isChecked
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TicketCheckScreen(),
                                      ),
                                    );
                                  }
                                : null,
                            child: Container(
                              color: isChecked
                                  ? const Color(0xFF003D5B)
                                  : const Color(0xFFE0E0E0),
                              child: Center(
                                child: Text(
                                  '네',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: isChecked ? Colors.white : const Color(0xFF999999),
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

                // BottomNavBar (Fixed at bottom)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomNavBar(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
