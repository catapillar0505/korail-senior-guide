import 'package:flutter/material.dart';
import 'non_member_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final List<String> textGuides = [
    '비회원으로 진행하기 위해\n위의 버튼을 눌러주세요',
    '이 버튼을 눌러주세요',
  ];
  int currentGuideIndex = 0;
  int wrongTapCount = 0;
  bool isBlinking = false;
  AnimationController? _blinkController;
  Animation<double>? _blinkAnimation;
  final ScrollController _scrollController = ScrollController();

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

    // 화면 진입 시 자동으로 스크롤을 끝까지 내림
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _blinkController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onWrongTap() {
    setState(() {
      wrongTapCount++;
      if (wrongTapCount >= 2) {
        currentGuideIndex = 1;
        isBlinking = true;
        _blinkController?.repeat(reverse: true);
      }
    });
  }

  void _onNonMemberTap() {
    setState(() {
      wrongTapCount = 0;
      isBlinking = false;
      _blinkController?.stop();
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NonMemberLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: GestureDetector(
          onTap: _onWrongTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              Column(
                children: [
                  // Login Body Image (Header + Body)
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/figma_images/reservation/login-body.png',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                        // 비회원 Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: GestureDetector(
                            onTap: _onNonMemberTap,
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF003D5B),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isBlinking && _blinkAnimation != null
                                      ? Color(0xFFFF5959).withOpacity(_blinkAnimation!.value)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    '비회원',
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
                        ),
                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // AI Guide Area Background
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
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
                ),
              ),
            ),

            // AI Guide Area with Text
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
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
                  ],
                ),
              ),
            ),
            ],
          ),
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
}
