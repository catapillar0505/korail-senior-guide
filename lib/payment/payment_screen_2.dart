import 'package:flutter/material.dart';
import 'payment_screen_3.dart';
import '../components/layouts/custom_layout.dart';

class PaymentScreen2 extends StatefulWidget {
  const PaymentScreen2({super.key});

  @override
  State<PaymentScreen2> createState() => _PaymentScreen2State();
}

class _PaymentScreen2State extends State<PaymentScreen2> with TickerProviderStateMixin {
  late TabController _tabController;
  AnimationController? _shadowController;
  Animation<double>? _shadowAnimation;
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _tabBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {});
    });

    // 그림자 애니메이션 설정
    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 650),
      reverseDuration: const Duration(milliseconds: 650),
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
    _shadowController?.forward();
  }

  void _hideShadowAnimation() {
    if (!mounted) return;
    _shadowController?.reverse();
  }

  @override
  void dispose() {
    _shadowController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String get guideMessage {
    if (_tabController.index == 1) {
      // 간편결제 탭
      return '저희는 실물카드로 결제해볼거예요!\n상단의 카드결제를 선택해주세요';
    } else {
      // 카드결제 탭 - 이 화면에서는 보이지 않음 (payment_screen_3에서 처리)
      return '';
    }
  }

  Widget _buildShadowOverlay() {
    return AnimatedBuilder(
      animation: _shadowAnimation!,
      builder: (context, child) {
        if (_shadowAnimation!.value <= 0.01) {
          return const SizedBox.shrink();
        }

        if (_tabBarKey.currentContext == null) {
          return const SizedBox.shrink();
        }

        final RenderBox? stackRenderBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
        final RenderBox? tabBarRenderBox = _tabBarKey.currentContext?.findRenderObject() as RenderBox?;

        if (stackRenderBox == null || tabBarRenderBox == null) return const SizedBox.shrink();

        final stackOffset = stackRenderBox.localToGlobal(Offset.zero);
        final tabBarOffset = tabBarRenderBox.localToGlobal(Offset.zero);
        final relativeOffset = tabBarOffset - stackOffset;
        final tabBarSize = tabBarRenderBox.size;

        // 왼쪽 절반(카드결제 탭)만 하이라이트
        final highlightRect = Rect.fromLTWH(
          relativeOffset.dx,
          relativeOffset.dy,
          tabBarSize.width / 2,  // 절반 너비
          tabBarSize.height,
        );

        return Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: ShadowOverlayPainter(
                highlightRect: highlightRect,
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
      headerTitle: '결제',
      showGuideZone: guideMessage.isNotEmpty,
      guideText: guideMessage,
      body: Stack(
        key: _stackKey,
        children: [
          Column(
            children: [
              // Tabs
              Container(
                color: Colors.white,
                child: TabBar(
                  key: _tabBarKey,
                  controller: _tabController,
                  onTap: (index) {
                    if (index == 0) {
                      // 그림자 fade out
                      _hideShadowAnimation();

                      // 카드결제 탭 클릭 시 payment_screen_3으로 이동
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentScreen3(),
                        ),
                      );
                    }
                  },
                  tabs: const [
                    Tab(text: '카드결제'),
                    Tab(text: '간편결제'),
                  ],
                  labelColor: const Color(0xFF6B4FA3),
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Color(0xFF6B4FA3),
                      width: 3,
                    ),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price info
                        _buildPriceRow('운임', '46,800원'),
                        _buildPriceRow('요금', '0원'),
                        _buildPriceRow('운임할인', '0원'),
                        _buildPriceRow('요금할인', '0원'),
                        const Divider(height: 32, thickness: 1),
                        _buildPriceRow('결제금액', '46,800원', isBold: true),
                        const SizedBox(height: 8),
                        const Text(
                          '* 특(우등)실은 운임과 요금으로 구성되며 운임만 할인됨',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Point usage
                        const Center(
                          child: Text(
                            '포인트 사용',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B4FA3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // KTX Mileage
                        const Center(
                          child: Text(
                            'KTX 마일리지',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: const Color(0xFF6B4FA3),
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Simple payment
                        const Center(
                          child: Text(
                            '간편결제',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B4FA3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Select
                        const Center(
                          child: Text(
                            '선택 안함',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: const Color(0xFF6B4FA3),
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 200),
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
      ..color = Color(0xFFB3B3B3).withValues(alpha: shadowOpacity);

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
