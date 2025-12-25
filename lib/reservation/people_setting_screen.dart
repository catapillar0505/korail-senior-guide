import 'package:flutter/material.dart';

class PeopleSettingScreen extends StatefulWidget {
  const PeopleSettingScreen({super.key});

  @override
  State<PeopleSettingScreen> createState() => _PeopleSettingScreenState();
}

class _PeopleSettingScreenState extends State<PeopleSettingScreen> {
  int adults = 1;
  int teenagers = 0;
  int children = 0;
  int infants = 0;
  int seniors = 0;

  void _increment(String category) {
    setState(() {
      switch (category) {
        case 'adults':
          if (adults < 9) adults++;
          break;
        case 'teenagers':
          if (teenagers < 9) teenagers++;
          break;
        case 'children':
          if (children < 9) children++;
          break;
        case 'infants':
          if (infants < 9) infants++;
          break;
        case 'seniors':
          if (seniors < 3) seniors++;
          break;
      }
    });
  }

  void _decrement(String category) {
    setState(() {
      switch (category) {
        case 'adults':
          if (adults > 0) adults--;
          break;
        case 'teenagers':
          if (teenagers > 0) teenagers--;
          break;
        case 'children':
          if (children > 0) children--;
          break;
        case 'infants':
          if (infants > 0) infants--;
          break;
        case 'seniors':
          if (seniors > 0) seniors--;
          break;
      }
    });
  }

  int _getTotalPassengers() {
    return adults + teenagers + children + infants + seniors;
  }

  Widget _buildPassengerRow(
    String title,
    String subtitle,
    int count,
    String category,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () => _decrement(category),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 24,
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _increment(category),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Stack(
        children: [
          Column(
        children: [
          // Top Navigation Bar
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Image.asset(
              'assets/figma_images/reservation/people-top-navbar.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '최소 1명 — 최대 9명',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Passenger Selection List
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: const Color(0xFFF7F7F7),
                child: Column(
                  children: [
                    _buildPassengerRow('경로', '65세 이상', adults, 'adults'),
                    _buildPassengerRow('어른', '13세 이상', teenagers, 'teenagers'),
                    _buildPassengerRow('어린이', '6세 ~ 12세', children, 'children'),
                    _buildPassengerRow('유아', '6세 미만', infants, 'infants'),

                    // Note Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Text(
                        '어른 1명 당 유아 1명 보호자 최석 동반 승차 가능 (별도 좌석이 필요하거나 어른 1명 당 유아 1명을 초과 승차할 경우 어린이권 구매를 추천드립니다.)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                    ),

                    _buildPassengerRow('중증장애인', '장애 1~3급', seniors, 'seniors'),

                    // Bottom Note
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        '장애인 1명 당 어른 1명 선택 예약 시 보호자 할인 가능',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Action Bar
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4B5963),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
              children: [
                // Passenger Count Display Section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  color: const Color(0xFF4B5963),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '인원',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        '총 ${_getTotalPassengers()}명',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Buttons Section
                Container(
                  color: const Color(0xFFB8CDD9),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            '이전',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF003D5B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, {
                              'adults': adults,
                              'teenagers': teenagers,
                              'children': children,
                              'infants': infants,
                              'seniors': seniors,
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF003D5B),
                              fontWeight: FontWeight.bold,
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
    );
  }
}
