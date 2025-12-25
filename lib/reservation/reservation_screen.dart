import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'place_selection_modal.dart';
import 'date_setting_screen.dart';
import 'people_setting_screen.dart';
import 'train_setting_screen.dart';
import '../components/layouts/main_layout.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  int currentGuideIndex = 0;
  String displayedText = '';
  String departureStation = '서울';
  String arrivalStation = '부산';
  bool showNextButton = true;
  bool isDepartureChanged = false;
  bool isArrivalChanged = false;
  bool isDateChanged = false;
  bool isPeopleChanged = false;
  DateTime selectedDate = DateTime.now();
  int selectedHour = 0;
  int adults = 1;
  int teenagers = 0;
  int children = 0;
  int infants = 0;
  int seniors = 0;

  final List<String> guideTexts = [
    '이제부터 저와 함께 예매해볼게요',
    '출발지를 설정하기 위해\n상단의 출발지를 눌러주세요',
    '이제 도착지를 설정해주세요',
    '좋아요! 이제 가는날을 눌러서\n원하는 날짜를 선택해주세요',
    '이제 인원을 선택해주세요\n바꾸실 게 없으면 바로 열차조회로\n넘어가셔도 좋아요!',
    '예매 정보를 모두 입력했어요!\n이제 열차조회를 눌러주세요😊',
  ];

  @override
  void initState() {
    super.initState();
    displayedText = guideTexts[0];
    selectedDate = DateTime.now();
  }

  void _onNextPressed() {
    if (currentGuideIndex == 0) {
      setState(() {
        currentGuideIndex = 1;
        displayedText = guideTexts[1];
        showNextButton = false;
      });
    }
  }

  Future<void> _showDateSettingScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateSettingScreen(
          initialDate: selectedDate,
          initialHour: selectedHour,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedDate = result['date'];
        selectedHour = result['hour'];
        if (!isDateChanged) {
          isDateChanged = true;
          currentGuideIndex = 4;
          displayedText = guideTexts[4];
        }
      });
    }
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[date.weekday - 1];
  }

  String _getFormattedDate() {
    return '${selectedDate.year}년 ${selectedDate.month.toString().padLeft(2, '0')}월 ${selectedDate.day.toString().padLeft(2, '0')}일 (${_getWeekday(selectedDate)}) ${selectedHour.toString().padLeft(2, '0')}:00';
  }

  Future<void> _showPeopleSettingScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PeopleSettingScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        adults = result['adults'];
        teenagers = result['teenagers'];
        children = result['children'];
        infants = result['infants'];
        seniors = result['seniors'];
        if (!isPeopleChanged) {
          isPeopleChanged = true;
          currentGuideIndex = 5;
          displayedText = guideTexts[5];
        }
      });
    }
  }

  String _getPassengerText() {
    int total = adults + teenagers + children + infants + seniors;
    if (total == 0) return '경로 0명';

    List<String> parts = [];
    if (adults > 0) parts.add('경로 ${adults}명');
    if (teenagers > 0) parts.add('어른 ${teenagers}명');
    if (children > 0) parts.add('어린이 ${children}명');
    if (infants > 0) parts.add('유아 ${infants}명');
    if (seniors > 0) parts.add('중증장애인 ${seniors}명');

    return parts.join(', ');
  }

  void _showPlaceSelectionModal(bool isDeparture) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => PlaceSelectionModal(
        title: isDeparture ? '출발' : '도착',
        currentPlace: isDeparture ? departureStation : arrivalStation,
      ),
    );

    if (result != null) {
      setState(() {
        if (isDeparture) {
          departureStation = result;
          if (!isDepartureChanged) {
            isDepartureChanged = true;
            currentGuideIndex = 2;
            displayedText = guideTexts[2];
          }
        } else {
          arrivalStation = result;
          if (!isArrivalChanged) {
            isArrivalChanged = true;
            currentGuideIndex = 3;
            displayedText = guideTexts[3];
          }
        }
      });
    }
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
                                  child: GestureDetector(
                                    onTap: () => _showPlaceSelectionModal(true),
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
                                        Text(
                                          departureStation,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF003D5B),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                  child: GestureDetector(
                                    onTap: () => _showPlaceSelectionModal(false),
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
                                        Text(
                                          arrivalStation,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF003D5B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Date Selection
                            InkWell(
                              onTap: _showDateSettingScreen,
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
                                          _getFormattedDate(),
                                          style: const TextStyle(
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
                              onTap: _showPeopleSettingScreen,
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
                                          _getPassengerText(),
                                          style: const TextStyle(
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
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TrainSettingScreen(
                                            departureStation: departureStation,
                                            arrivalStation: arrivalStation,
                                            selectedDate: selectedDate,
                                            selectedHour: selectedHour,
                                          ),
                                        ),
                                      );
                                    },
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

          // AI Guide Area with Gradient Shadow
          Positioned(
            bottom: 0, // Above bottom navigation bar
            left: 0,
            right: 0,
            child: Container(
              height: 200,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        displayedText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          height: 1.5,
                        ),
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
                              color: Colors.black,
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
