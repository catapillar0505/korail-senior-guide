import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import '../components/layouts/custom_layout.dart';

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
  int wrongTapCount = 0;
  bool showReservationModal = false;
  int selectedTrainIndex = -1;
  AnimationController? _shadowController;
  Animation<double>? _shadowAnimation;

  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _normalPriceHeaderKey = GlobalKey();
  final GlobalKey _specialPriceHeaderKey = GlobalKey();
  final GlobalKey _listViewKey = GlobalKey(); // ListView의 높이를 측정하기 위한 키

  final List<String> textGuides = [
    '원하는열차를 선택해주세요\n사각형 버튼을 누르면 돼요',
    '여기를 누르면 돼요!',
  ];

  @override
  void initState() {
    super.initState();

    // 그림자 애니메이션 설정
    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 650), // 0.65초 fade in
      reverseDuration: const Duration(milliseconds: 650), // 0.65초 fade out
      vsync: this,
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _shadowController!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shadowController?.dispose();
    super.dispose();
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

  String _getWeekday(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[date.weekday - 1];
  }

  String _getFormattedDate() {
    return '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일 (${_getWeekday(widget.selectedDate)})';
  }

  void _onScroll() {
    if (showGuideZone && currentGuideIndex < 1) {
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
        currentGuideIndex = 1;
      }
    });

    // 2회 이상 잘못 탭하면 그림자 애니메이션 시작
    if (wrongTapCount >= 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startShadowAnimation();
      });
    }
  }

  void _onCorrectTap(int trainIndex) {
    // 그림자 애니메이션 fade out
    _hideShadowAnimation();

    setState(() {
      wrongTapCount = 0;
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

  Widget _buildShadowOverlay() {
    // wrongTapCount가 2 미만이면 그림자 표시 안 함
    if (wrongTapCount < 2) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _shadowAnimation!,
      builder: (context, child) {
        // 애니메이션 값이 0이면 그림자를 그리지 않음
        if (_shadowAnimation!.value <= 0.01) {
          return const SizedBox.shrink();
        }

        // AnimatedBuilder 안에서 currentContext 체크
        if (_normalPriceHeaderKey.currentContext == null ||
            _specialPriceHeaderKey.currentContext == null ||
            _listViewKey.currentContext == null) {
          return const SizedBox.shrink();
        }

        final RenderBox? stackRenderBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
        final RenderBox? normalPriceRenderBox = _normalPriceHeaderKey.currentContext?.findRenderObject() as RenderBox?;
        final RenderBox? specialPriceRenderBox = _specialPriceHeaderKey.currentContext?.findRenderObject() as RenderBox?;
        final RenderBox? listViewRenderBox = _listViewKey.currentContext?.findRenderObject() as RenderBox?;

        if (stackRenderBox == null || normalPriceRenderBox == null ||
            specialPriceRenderBox == null || listViewRenderBox == null ||
            !stackRenderBox.hasSize || !normalPriceRenderBox.hasSize ||
            !specialPriceRenderBox.hasSize || !listViewRenderBox.hasSize) {
          return const SizedBox.shrink();
        }

        // Stack을 기준으로 상대 좌표 계산
        final stackOffset = stackRenderBox.localToGlobal(Offset.zero);

        // 하이라이트할 Rect 리스트
        List<Rect> highlightRects = [];

        // 일반실 운임 열 전체 (헤더 + ListView의 해당 열)
        final normalPriceOffset = normalPriceRenderBox.localToGlobal(Offset.zero);
        final normalPriceRelativeOffset = normalPriceOffset - stackOffset;
        final normalPriceSize = normalPriceRenderBox.size;

        final listViewSize = listViewRenderBox.size;

        // 일반실 운임 열 (헤더부터 ListView 끝까지)
        highlightRects.add(Rect.fromLTWH(
          normalPriceRelativeOffset.dx,
          normalPriceRelativeOffset.dy,
          normalPriceSize.width,
          normalPriceSize.height + listViewSize.height,
        ));

        // 특/우등 운임+요금 열 (헤더부터 ListView 끝까지)
        final specialPriceOffset = specialPriceRenderBox.localToGlobal(Offset.zero);
        final specialPriceRelativeOffset = specialPriceOffset - stackOffset;
        final specialPriceSize = specialPriceRenderBox.size;

        highlightRects.add(Rect.fromLTWH(
          specialPriceRelativeOffset.dx,
          specialPriceRelativeOffset.dy,
          specialPriceSize.width,
          specialPriceSize.height + listViewSize.height,
        ));

        return Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: MultiShadowOverlayPainter(
                highlightRects: highlightRects,
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
    return CustomLayout(
      headerTitle: '열차조회',
      headerBackgroundColor: const Color(0xFF003D5B),
      backgroundColor: const Color(0xFFF5F5F5),
      showGuideZone: showGuideZone,
      guideText: showGuideZone ? textGuides[currentGuideIndex] : null,
      overlayWidgets: showReservationModal
          ? [
              // Reservation Modal
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
                        const Color(0xFFB5D4ED).withValues(alpha: 0.75),
                        const Color(0xFFB5D4ED).withValues(alpha: 0.0),
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
            ]
          : null,
      body: Stack(
        key: _stackKey,
        children: [
          Column(
            children: [
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
            child: Row(
              children: [
                const Expanded(
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
                const Expanded(
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
                const Expanded(
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
                  child: Container(
                    key: _normalPriceHeaderKey,
                    child: const Text(
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
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    key: _specialPriceHeaderKey,
                    child: const Text(
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
                ),
              ],
            ),
          ),

          // Train List
          Expanded(
            child: Container(
              key: _listViewKey,
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
          // 그림자 오버레이
          _buildShadowOverlay(),
        ],
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
                    color: Colors.transparent,
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
                    color: Colors.transparent,
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

class MultiShadowOverlayPainter extends CustomPainter {
  final List<Rect> highlightRects;
  final double shadowOpacity;

  MultiShadowOverlayPainter({
    required this.highlightRects,
    required this.shadowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFB3B3B3).withValues(alpha: shadowOpacity);

    // 전체 화면 경로
    final fullScreenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 모든 하이라이트 영역을 합친 경로
    Path highlightPath = Path();
    for (var rect in highlightRects) {
      highlightPath.addRRect(RRect.fromRectAndRadius(
        rect,
        const Radius.circular(8),
      ));
    }

    // 차집합으로 하이라이트 영역을 제외한 영역만 그리기
    final shadowPath = Path.combine(
      PathOperation.difference,
      fullScreenPath,
      highlightPath,
    );

    canvas.drawPath(shadowPath, paint);
  }

  @override
  bool shouldRepaint(MultiShadowOverlayPainter oldDelegate) {
    return oldDelegate.highlightRects != highlightRects ||
        oldDelegate.shadowOpacity != shadowOpacity;
  }
}
