import 'package:flutter/material.dart';
import '../login/login_screen.dart';

class TrainSettingScreen extends StatefulWidget {
  final String departureStation;
  final String arrivalStation;
  final DateTime selectedDate;
  final int selectedHour;

  const TrainSettingScreen({
    super.key,
    required this.departureStation,
    required this.arrivalStation,
    required this.selectedDate,
    required this.selectedHour,
  });

  @override
  State<TrainSettingScreen> createState() => _TrainSettingScreenState();
}

class _TrainSettingScreenState extends State<TrainSettingScreen> with SingleTickerProviderStateMixin {
  int currentGuideIndex = 0;
  bool showGuideZone = true;
  bool showNextButton = true;
  int wrongTapCount = 0;
  bool isBlinking = false;
  bool showReservationModal = false;
  int selectedTrainIndex = -1;
  AnimationController? _blinkController;
  Animation<double>? _blinkAnimation;

  final List<String> textGuides = [
    '이 화면에서는\n열차를 시간순으로 볼 수 있어요',
    '사각형 버튼을 누르면 돼요\n원하는 열차를 선택해주세요!',
    '도움이 필요하신가요?\n여기 버튼을 눌러주세요',
  ];

  @override
  void initState() {
    super.initState();
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _blinkController = controller;

    _blinkAnimation = Tween<double>(begin: 0.2, end: 0.4).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _blinkController?.dispose();
    super.dispose();
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[date.weekday - 1];
  }

  String _getFormattedDate() {
    return '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일 (${_getWeekday(widget.selectedDate)})';
  }

  void _onNextPressed() {
    setState(() {
      currentGuideIndex = 1;
      showNextButton = false;
    });
  }

  void _onScroll() {
    if (showGuideZone && currentGuideIndex < 2) {
      setState(() {
        showGuideZone = false;
      });
    }
  }

  void _onWrongTap() {
    setState(() {
      wrongTapCount++;
      if (wrongTapCount >= 2) {
        showGuideZone = true;
        currentGuideIndex = 2;
        showNextButton = false;
        isBlinking = true;
        _blinkController?.repeat(reverse: true);
      }
    });
  }

  void _onCorrectTap(int trainIndex) {
    setState(() {
      wrongTapCount = 0;
      isBlinking = false;
      _blinkController?.stop();
      showReservationModal = true;
      showGuideZone = false;
      selectedTrainIndex = trainIndex;
    });
  }

  void _onModalCancel() {
    setState(() {
      showReservationModal = false;
    });
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
                // Top Navigation Bar
                Image.asset(
                  'assets/figma_images/reservation/train-top-navbar.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),

              // Route Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5),
                color: const Color(0xFFD0E8F2),
                child: Center(
                  child: Text(
                    '${widget.departureStation} → ${widget.arrivalStation}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003D5B),
                    ),
                  ),
                ),
              ),

              // Date Selection Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: const Color(0xFFE8E8E8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Previous Day Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF003D5B), width: 2),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: const Text(
                        '이전날',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF003D5B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Current Date
                    Text(
                      _getFormattedDate(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Next Day Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF003D5B), width: 2),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: const Text(
                        '다음날',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF003D5B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Table Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                color: const Color(0xFFE0E0E0),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        '열차',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '출발',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '도착',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '일반실\n운임',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                          height: 1.2,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '특/우등\n운임+요금',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Train List
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification) {
                        _onScroll();
                      }
                      return false;
                    },
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                      _buildTrainItem(
                        0,
                        'KTX-산천\n401',
                        '11:18\n용산',
                        '13:12\n광주송정',
                        '30%할인',
                        '32,800원',
                        '운임30%',
                        '51,500원',
                        const Color(0xFFFF5722),
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      _buildTrainItem(
                        1,
                        'KTX-산천\n403',
                        '11:45\n용산',
                        '13:39\n광주송정',
                        '25%할인',
                        '35,100원',
                        '운임25%',
                        '53,800원',
                        const Color(0xFFFF5722),
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      _buildTrainItem(
                        2,
                        'KTX\n405',
                        '12:15\n용산',
                        '14:21\n광주송정',
                        '10%할인',
                        '42,100원',
                        '운임10%',
                        '60,800원',
                        const Color(0xFFFF5722),
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      _buildTrainItem(
                        3,
                        'KTX-산천\n9419',
                        '13:30\n용산',
                        '15:23\n광주송정',
                        '46,800원',
                        'Ⓜ5%적립',
                        '65,500원',
                        'Ⓜ5%적립',
                        const Color(0xFFFF9800),
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      _buildTrainItem(
                        4,
                        'KTX\n421',
                        '14:48\n용산',
                        '16:46\n광주송정',
                        '46,800원',
                        'Ⓜ5%적립',
                        '65,500원',
                        'Ⓜ5%적립',
                        const Color(0xFFFF9800),
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      _buildTrainItem(
                        5,
                        'KTX\n423',
                        '15:33\n용산',
                        '17:33\n광주송정',
                        '46,800원',
                        'Ⓜ5%적립',
                        '65,500원',
                        'Ⓜ5%적립',
                        const Color(0xFFFF9800),
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      _buildTrainItem(
                        6,
                        'KTX-청룡\n425',
                        '16:08\n용산',
                        '17:44\n광주송정',
                        '47,100원',
                        'Ⓜ5%적립',
                        '56,500원',
                        'Ⓜ5%적립',
                        const Color(0xFFFF9800),
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      _buildTrainItem(
                        7,
                        'KTX-산천\n427',
                        '16:43\n용산',
                        '18:43\n광주송정',
                        '46,800원',
                        'Ⓜ5%적립',
                        '매진',
                        '',
                        const Color(0xFFFF9800),
                        isSoldOut: true,
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      _buildTrainItem(
                        8,
                        'KTX\n481',
                        '17:10\n용산',
                        '20:08\n광주송정',
                        '38,800원',
                        'Ⓜ5%적립',
                        '54,000원',
                        'Ⓜ5%적립',
                        const Color(0xFFFF9800),
                      ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // AI Guide Area with Text
          if (showGuideZone)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                color: Colors.white,
                child: Container(
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
                            textGuides[currentGuideIndex],
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
            ),

          // Reservation Modal
          if (showReservationModal)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedTrainIndex == 3) ...[
                        const Text(
                          '일반실 3시간 6분 소요',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0288D1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '이 열차는 서대전을 경유해요',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '소요시간이 더 걸리는데 괜찮으신가요?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.3,
                          ),
                        ),
                      ] else ...[
                        const Text(
                          '일반실 2시간 6분 소요',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0288D1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '이 열차로 예매할까요?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.3,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _onModalCancel,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD0E8F2),
                                  border: Border.all(
                                    color: const Color(0xFF003D5B),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '취소',
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
                          Container(
                            width: 1,
                            height: 48,
                            color: const Color(0xFF003D5B),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD0E8F2),
                                  border: Border.all(
                                    color: const Color(0xFF003D5B),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '예매',
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
      ),
    );
  }

  Widget _buildTrainItem(
    int trainIndex,
    String trainName,
    String departure,
    String arrival,
    String normalPrice,
    String normalSubtext,
    String specialPrice,
    String specialSubtext,
    Color discountColor, {
    bool isSoldOut = false,
  }) {
    return GestureDetector(
      onTap: _onWrongTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            // Train Name
            Expanded(
              flex: 2,
              child: Text(
                trainName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
            ),
            // Departure
            Expanded(
              flex: 2,
              child: Text(
                departure,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
            ),
            // Arrival
            Expanded(
              flex: 2,
              child: Text(
                arrival,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
            ),
            // Normal Price
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => _onCorrectTap(trainIndex),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF003D5B), width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: isBlinking && _blinkAnimation != null
                        ? Color(0xFFFF5959).withOpacity(_blinkAnimation!.value)
                        : Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Text(
                        normalPrice,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: discountColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        normalSubtext,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D5B),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Special Price
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: isSoldOut ? null : () => _onCorrectTap(trainIndex),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSoldOut ? const Color(0xFFFF5959) : const Color(0xFF003D5B),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isBlinking && _blinkAnimation != null
                        ? Color(0xFFFF5959).withOpacity(_blinkAnimation!.value)
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: isSoldOut
                        ? const Text(
                            '매진',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF5959),
                              height: 1.2,
                            ),
                          )
                        : Column(
                            children: [
                              Text(
                                specialPrice,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: discountColor,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                specialSubtext,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003D5B),
                                  height: 1.2,
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
      ),
    );
  }
}
