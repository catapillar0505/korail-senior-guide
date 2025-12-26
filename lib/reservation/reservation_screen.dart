import 'package:flutter/material.dart';
import 'place_selection_modal.dart';
import 'date_setting_screen.dart';
import 'people_setting_screen.dart';
import 'train_setting_screen.dart';
import '../components/layouts/home_layout.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> with SingleTickerProviderStateMixin {
  int currentGuideIndex = 0;
  String displayedText = '';
  String departureStation = '서울';
  String arrivalStation = '부산';
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

  AnimationController? _shadowController;
  Animation<double>? _shadowAnimation;
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _departureKey = GlobalKey();
  final GlobalKey _arrivalKey = GlobalKey();
  final GlobalKey _dateKey = GlobalKey();
  final GlobalKey _peopleKey = GlobalKey();
  final GlobalKey _trainSearchKey = GlobalKey();

  final List<String> guideTexts = [
    '이제 예매를 시작해볼게요!\n위에 출발지를 선택해주세요',
    '좋아요!\n도착지도 똑같이 설정해주세요',
    '출발/도착지 완료!\n이제 원하는 날짜를 선택해주세요',
    '거의 다 했어요!\n마지막으로 인원을 선택해주세요',
    '예매 정보를 모두 입력했어요!\n이제 열차조회를 눌러주세요😊',
  ];

  @override
  void initState() {
    super.initState();
    displayedText = guideTexts[0];
    selectedDate = DateTime.now();

    // 그림자 애니메이션 설정
    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 650), // 0.65초 fade in
      reverseDuration: const Duration(milliseconds: 650), // 0.65초 fade out
      vsync: this,
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _shadowController!, curve: Curves.easeInOut),
    );

    // 첫 렌더링 후 애니메이션 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startShadowAnimation();
    });
  }

  void _startShadowAnimation() {
    if (!mounted) return;
    _shadowController?.reset();
    _shadowController?.forward(); // fade in만 하고 유지
  }

  void _hideShadowAnimation() {
    if (!mounted) return;
    _shadowController?.reverse(); // 사용자 액션 시 fade out
  }

  @override
  void dispose() {
    _shadowController?.dispose();
    super.dispose();
  }

  Future<void> _showDateSettingScreen() async {
    // 현재 그림자 fade out
    _hideShadowAnimation();

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
          currentGuideIndex = 3;
          displayedText = guideTexts[3];
        }
      });
      // 다음 가이드의 그림자 애니메이션 시작
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startShadowAnimation();
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
    // 현재 그림자 fade out
    _hideShadowAnimation();

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
          currentGuideIndex = 4;
          displayedText = guideTexts[4];
        }
      });
      // 다음 가이드의 그림자 애니메이션 시작
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startShadowAnimation();
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
    // 현재 그림자 fade out
    _hideShadowAnimation();

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
            currentGuideIndex = 1;
            displayedText = guideTexts[1];
          }
        } else {
          arrivalStation = result;
          if (!isArrivalChanged) {
            isArrivalChanged = true;
            currentGuideIndex = 2;
            displayedText = guideTexts[2];
          }
        }
      });
      // 다음 가이드의 그림자 애니메이션 시작
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startShadowAnimation();
      });
    }
  }

  Widget _buildShadowOverlay() {
    if (currentGuideIndex >= 5) return const SizedBox.shrink();

    GlobalKey? targetKey;
    switch (currentGuideIndex) {
      case 0:
        targetKey = _departureKey;
        break;
      case 1:
        targetKey = _arrivalKey;
        break;
      case 2:
        targetKey = _dateKey;
        break;
      case 3:
        targetKey = _peopleKey;
        break;
      case 4:
        targetKey = _trainSearchKey;
        break;
    }

    return AnimatedBuilder(
      animation: _shadowAnimation!,
      builder: (context, child) {
        // 애니메이션 값이 0이면 그림자를 그리지 않음
        if (_shadowAnimation!.value <= 0.01) {
          return const SizedBox.shrink();
        }

        // AnimatedBuilder 안에서 currentContext 체크
        if (targetKey?.currentContext == null) {
          return const SizedBox.shrink();
        }

        final RenderBox? stackRenderBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
        final RenderBox? targetRenderBox = targetKey!.currentContext?.findRenderObject() as RenderBox?;

        if (stackRenderBox == null || targetRenderBox == null) return const SizedBox.shrink();

        // 렌더 박스가 아직 레이아웃되지 않았으면 그림자를 그리지 않음
        if (!stackRenderBox.hasSize || !targetRenderBox.hasSize) return const SizedBox.shrink();

        // Stack을 기준으로 상대 좌표 계산
        final stackOffset = stackRenderBox.localToGlobal(Offset.zero);
        final targetOffset = targetRenderBox.localToGlobal(Offset.zero);
        final relativeOffset = targetOffset - stackOffset;
        final size = targetRenderBox.size;

        return Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: ShadowOverlayPainter(
                highlightRect: Rect.fromLTWH(relativeOffset.dx, relativeOffset.dy, size.width, size.height),
                shadowOpacity: _shadowAnimation!.value,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showGuideZone: true,
      guideText: displayedText,
      body: Stack(
        key: _stackKey,
        children: [
          SingleChildScrollView(
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
                              child: Container(
                                key: _departureKey,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                              child: Container(
                                key: _arrivalKey,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Date Selection
                      Container(
                        key: _dateKey,
                        child: InkWell(
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
                      ),

                      // Passenger Selection
                      Container(
                        key: _peopleKey,
                        child: InkWell(
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
                            key: _trainSearchKey,
                            child: GestureDetector(
                              onTap: () {
                                // 현재 그림자 fade out
                                _hideShadowAnimation();

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
          // 그림자 오버레이
          _buildShadowOverlay(),
        ],
      ),
    );
  }
}

class ShadowOverlayPainter extends CustomPainter {
  final Rect highlightRect;
  final double shadowOpacity;

  ShadowOverlayPainter({
    required this.highlightRect,
    required this.shadowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFB3B3B3).withOpacity(shadowOpacity);

    // 전체 화면 경로
    final fullScreenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 하이라이트 영역 경로 (둥근 모서리)
    final highlightPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        highlightRect,
        const Radius.circular(8),
      ));

    // 차집합으로 하이라이트 영역을 제외한 영역만 그리기
    final shadowPath = Path.combine(
      PathOperation.difference,
      fullScreenPath,
      highlightPath,
    );

    canvas.drawPath(shadowPath, paint);
  }

  @override
  bool shouldRepaint(ShadowOverlayPainter oldDelegate) {
    return oldDelegate.highlightRect != highlightRect ||
        oldDelegate.shadowOpacity != shadowOpacity;
  }
}
