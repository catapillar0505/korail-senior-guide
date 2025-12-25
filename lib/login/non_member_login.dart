import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'info_check_screen.dart';

class NonMemberLoginScreen extends StatefulWidget {
  const NonMemberLoginScreen({super.key});

  @override
  State<NonMemberLoginScreen> createState() => _NonMemberLoginScreenState();
}

class _NonMemberLoginScreenState extends State<NonMemberLoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

  final List<String> textGuides = [
    '이후에 티켓 확인을 위한\n1회용 정보를 입력해주세요',
    '"비밀번호는 무슨 비밀번호야?"',
    '1회용 비밀번호를 만드는 거예요!\n비밀번호를 입력 후 정확히 썼는지\n확인을 위해 한번더 입력해주세요',
    '비밀번호 5자리를 입력해주세요~',
    '이런🥲 비밀번호가 일치하지 않아요!',
    '정보가 다 잘 입력됐네요!\n이제 확인 버튼을 눌러주세요!',
    '예약 정보가 맞으면\n결제하기를 눌러주세요',
    '이름을 입력해주세요',
    '좋아요!',
    '전화번호를 입력해주세요\n- 없이 숫자만 입력하시면 돼요',
    '전화번호를 정확히 입력해주세요',
    '비밀번호를 입력해주세요\n숫자 5자리로 만들어주세요',
    '5자리를 입력해주세요',
    '위에 입력한 비밀번호와 똑같이 써주세요',
    '앗! 위에 쓴 비밀번호와 달라요\n다시 한번 확인해주세요',
  ];

  int currentGuideIndex = 0;
  int wrongTapCount = 0;
  bool isBlinking = false;
  AnimationController? _blinkController;
  Animation<double>? _blinkAnimation;

  bool isDanbiSpeaking = false;
  String displayedText = '';
  bool isTyping = false;
  Timer? _typingTimer;
  int _typingIndex = 0;

  @override
  void initState() {
    super.initState();
    displayedText = textGuides[0];

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

    // Add listeners to update button state
    _nameController.addListener(_onNameChanged);
    _phoneController.addListener(_onPhoneChanged);
    _passwordController.addListener(_onPasswordChanged);
    _passwordConfirmController.addListener(_onPasswordConfirmChanged);

    // Add focus listeners
    _nameFocusNode.addListener(_onNameFocusChanged);
    _phoneFocusNode.addListener(_onPhoneFocusChanged);
    _passwordFocusNode.addListener(_onPasswordFocusChanged);
    _passwordConfirmFocusNode.addListener(_onPasswordConfirmFocusChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    _blinkController?.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
           _phoneController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty &&
           _passwordConfirmController.text.isNotEmpty;
  }

  void _onWrongTap() {
    setState(() {
      wrongTapCount++;
      if (wrongTapCount >= 2) {
        isBlinking = true;
        _blinkController?.repeat(reverse: true);
      }
    });
  }

  void _onConfirm() {
    if (_isFormValid &&
        _passwordController.text == _passwordConfirmController.text &&
        _passwordController.text.length == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfoCheckScreen(
            name: _nameController.text,
            phone: _phoneController.text,
          ),
        ),
      );
    }
  }

  void _onDanbiPressed() {
    // 1) 즉시 isDanbiSpeaking = true로 설정 (gradient 배경 + speak icon 표시)
    setState(() {
      isDanbiSpeaking = true;
      displayedText = ''; // 텍스트 초기화
    });

    // 2) 5초 대기 (사용자가 말하고 있는 시간)
    Future.delayed(const Duration(seconds: 5), () {
      // 3) 5초 후 textGuides[1]을 타이핑 효과와 함께 표시
      _showTextWithTypingEffect(1, () {
        // 4) 타이핑 완료 후 isDanbiSpeaking = false (gradient 배경 + icon 사라짐)
        setState(() {
          isDanbiSpeaking = false;
        });

        // 5) 2초 후 textGuides[2] 표시
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            currentGuideIndex = 2;
            displayedText = textGuides[2];
          });
        });
      });
    });
  }

  void _showTextWithTypingEffect(int guideIndex, VoidCallback? onComplete) {
    setState(() {
      currentGuideIndex = guideIndex;
      displayedText = '';
      isTyping = true;
      _typingIndex = 0;
    });

    final fullText = textGuides[guideIndex];
    _typingTimer?.cancel();

    _typingTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_typingIndex < fullText.length) {
        setState(() {
          displayedText = fullText.substring(0, _typingIndex + 1);
          _typingIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          isTyping = false;
        });
        onComplete?.call();
      }
    });
  }

  // Name field handlers
  void _onNameFocusChanged() {
    if (_nameFocusNode.hasFocus) {
      setState(() {
        currentGuideIndex = 7;
        displayedText = textGuides[7]; // '이름을 입력해주세요'
      });
    }
  }

  void _onNameChanged() {
    setState(() {
      if (_nameController.text.isNotEmpty && _nameFocusNode.hasFocus) {
        currentGuideIndex = 8;
        displayedText = textGuides[8]; // '잘하고 있어요!'
      }
    });
  }

  // Phone field handlers
  void _onPhoneFocusChanged() {
    if (_phoneFocusNode.hasFocus) {
      setState(() {
        currentGuideIndex = 9;
        displayedText = textGuides[9]; // '전화번호를 입력해주세요\n- 없이 숫자만 입력하시면 돼요'
      });
    }
  }

  void _onPhoneChanged() {
    setState(() {
      if (_phoneController.text.isNotEmpty && _phoneFocusNode.hasFocus) {
        // Check if phone number is valid (10-11 digits)
        if (_phoneController.text.length >= 10 && _phoneController.text.length <= 11) {
          currentGuideIndex = 8;
          displayedText = textGuides[8]; // '잘하고 있어요!'
        } else if (_phoneController.text.length > 11) {
          currentGuideIndex = 10;
          displayedText = textGuides[10]; // '전화번호를 정확히 입력해주세요'
        }
      }
    });
  }

  // Password field handlers
  void _onPasswordFocusChanged() {
    if (_passwordFocusNode.hasFocus) {
      setState(() {
        currentGuideIndex = 11;
        displayedText = textGuides[11]; // '비밀번호를 입력해주세요\n숫자 5자리로 만들어주세요'
      });
    }
  }

  void _onPasswordChanged() {
    setState(() {
      if (_passwordController.text.isNotEmpty && _passwordFocusNode.hasFocus) {
        if (_passwordController.text.length == 5) {
          currentGuideIndex = 8;
          displayedText = textGuides[8]; // '잘하고 있어요!'
        } else if (_passwordController.text.length > 0 && _passwordController.text.length < 5) {
          currentGuideIndex = 12;
          displayedText = textGuides[12]; // '5자리를 입력해주세요'
        }
      }

      // Re-validate password confirm if it has value
      if (_passwordConfirmController.text.isNotEmpty) {
        _validatePasswordConfirm();
      }
    });
  }

  // Password confirm field handlers
  void _onPasswordConfirmFocusChanged() {
    if (_passwordConfirmFocusNode.hasFocus) {
      setState(() {
        currentGuideIndex = 13;
        displayedText = textGuides[13]; // '비밀번호를 한번 더 입력해주세요\n위에 입력한 비밀번호와 똑같이 써주세요'
      });
    }
  }

  void _onPasswordConfirmChanged() {
    setState(() {
      if (_passwordConfirmController.text.isNotEmpty) {
        _validatePasswordConfirm();
      }
    });
  }

  void _validatePasswordConfirm() {
    if (_passwordController.text.isEmpty) return;

    if (_passwordController.text.length == 5 &&
        _passwordConfirmController.text.length == 5) {
      // Both are 5 digits, check if they match
      if (_passwordController.text != _passwordConfirmController.text) {
        // Passwords don't match
        currentGuideIndex = 14;
        displayedText = textGuides[14]; // '앗! 위에 쓴 비밀번호와 달라요\n다시 한번 확인해주세요'
      } else {
        // Passwords match
        currentGuideIndex = 5;
        displayedText = textGuides[5]; // '정보가 잘 입력되었어요!'
      }
    } else if (_passwordConfirmController.text.length >= 5) {
      // Confirm password is 5+ digits but doesn't match
      if (_passwordController.text != _passwordConfirmController.text) {
        currentGuideIndex = 14;
        displayedText = textGuides[14]; // '앗! 위에 쓴 비밀번호와 달라요\n다시 한번 확인해주세요'
      }
    } else if (_passwordConfirmFocusNode.hasFocus && _passwordConfirmController.text.length > 0) {
      // Still typing
      currentGuideIndex = 12;
      displayedText = textGuides[12]; // '5자리를 입력해주세요'
    }
  }

  bool get _isPasswordInvalid {
    return _passwordController.text.isNotEmpty &&
        _passwordController.text.length != 5;
  }

  bool get _isPasswordConfirmInvalid {
    return _passwordConfirmController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text != _passwordConfirmController.text;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final bottomBarHeight = 70.0;
    final confirmButtonHeight = 80.0;
    final guideZoneHeight = 140.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F5F5),
      body: GestureDetector(
        onTap: _onWrongTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
              // 메인 컨텐츠 영역
              Positioned.fill(
                bottom: bottomBarHeight + confirmButtonHeight + guideZoneHeight,
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // Top Navigation Bar
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: Image.asset(
                          'assets/figma_images/reservation/login-top-navbar.png',
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                      ),

                    // Form Container
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 이름 Field
                          _buildInlineField(
                            label: '이름',
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            hintText: '',
                          ),
                          const SizedBox(height: 10),

                          // 전화번호 Field
                          _buildInlineField(
                            label: '전화번호',
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            hintText: '\' - \' 제외하고 입력',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10),

                          // 비밀번호 Field
                          _buildInlineField(
                            label: '비밀번호',
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            hintText: '비밀번호 5자리',
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            isInvalid: _isPasswordInvalid,
                          ),
                          const SizedBox(height: 10),

                          // 비밀번호 확인 Field
                          _buildInlineField(
                            label: '비밀번호 확인',
                            controller: _passwordConfirmController,
                            focusNode: _passwordConfirmFocusNode,
                            hintText: '비밀번호 확인 5자리',
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            isInvalid: _isPasswordConfirmInvalid,
                          ),
                          const SizedBox(height: 10),

                          // Divider
                          Container(
                            height: 1,
                            color: const Color(0xFFE0E0E0),
                          ),
                          const SizedBox(height: 24),

                          // Notice Text
                          const Text(
                            '※ 승차권 반환, 확인 등을 위한 필수정보이니 정확히 입력해 주세요.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '코레일 멤버십에 가입하시면 KTX365할인,\n청소년드림상품 등 할인상품을 이용하실 수 있습니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Gradient overlay when Danbi is speaking (behind guide zone)
            if (isDanbiSpeaking)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

            // Guide Zone - 키보드가 열리면 키보드 위, 닫히면 하단바 위에 위치
            Positioned(
              left: 0,
              right: 0,
              bottom: isKeyboardVisible
                  ? keyboardHeight
                  : bottomBarHeight + confirmButtonHeight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: guideZoneHeight,
                decoration: BoxDecoration(
                  color: isDanbiSpeaking ? Colors.transparent : Colors.white,
                  boxShadow: isDanbiSpeaking
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  children: [
                    // Gradient overlay (only when not speaking)
                    if (!isDanbiSpeaking)
                      Container(
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
                    // Text on top
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: Text(
                          displayedText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isDanbiSpeaking ? Colors.white : Colors.black,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Confirm Button - 하단바 바로 위에 고정 (공백 없음)
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomBarHeight,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: GestureDetector(
                  onTap: _isFormValid ? _onConfirm : null,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _isFormValid ? const Color(0xFF4A90E2) : const Color(0xFFEBF2F8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: _isFormValid ? Colors.white : const Color(0xFFBBBBBB),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: bottomBarHeight,
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
                    GestureDetector(
                      onTap: _onDanbiPressed,
                      child: Container(
                        width: 140,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF003D5B),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: isDanbiSpeaking
                              ? SvgPicture.asset(
                                  'assets/figma_images/onboarding/speak-icon.svg',
                                  width: 36,
                                  height: 36,
                                )
                              : const Text(
                                  '단비',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox.shrink(),
      ),
    );
  }

  Widget _buildInlineField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    FocusNode? focusNode,
    bool obscureText = false,
    TextInputType? keyboardType,
    bool isInvalid = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(
                color: isInvalid ? const Color(0xFFFF0000) : const Color(0xFFE0E0E0),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFBBBBBB),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
