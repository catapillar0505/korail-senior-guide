import 'package:flutter/material.dart';
import 'payment_screen_2.dart';
import 'payment_screen_3_cardscan.dart';
import 'payment_screen_7.dart';
import '../components/custom_header.dart';
import '../components/bottom_nav_bar.dart';

class PaymentScreen3 extends StatefulWidget {
  const PaymentScreen3({super.key});

  @override
  State<PaymentScreen3> createState() => _PaymentScreen3State();
}

class _PaymentScreen3State extends State<PaymentScreen3> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<TextEditingController> _cardNumberControllers = List.generate(4, (_) => TextEditingController());
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();

  final List<FocusNode> _cardNumberFocusNodes = List.generate(4, (_) => FocusNode());
  final FocusNode _expiryMonthFocusNode = FocusNode();
  final FocusNode _expiryYearFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _idNumberFocusNode = FocusNode();

  String _guideMessage = '좋아요! 이제 카드스캔 또는 직접\n카드정보를 입력해주세요';
  bool _isPrivacyChecked = false;

  final List<bool?> _cardNumberValid = [null, null, null, null]; // null = not started, true = valid, false = invalid
  bool? _expiryMonthValid = null;
  bool? _expiryYearValid = null;
  bool? _passwordValid = null;
  bool? _idNumberValid = null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    // Add listeners for card number fields
    for (int i = 0; i < 4; i++) {
      _cardNumberControllers[i].addListener(() => _validateCardNumber(i));
      _cardNumberFocusNodes[i].addListener(_updateGuideMessage);
    }

    // Add listeners for other fields
    _expiryMonthController.addListener(_validateExpiryMonth);
    _expiryYearController.addListener(_validateExpiryYear);
    _passwordController.addListener(_validatePassword);
    _idNumberController.addListener(_validateIdNumber);

    _expiryMonthFocusNode.addListener(_updateGuideMessage);
    _expiryYearFocusNode.addListener(_updateGuideMessage);
    _passwordFocusNode.addListener(_updateGuideMessage);
    _idNumberFocusNode.addListener(_updateGuideMessage);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var controller in _cardNumberControllers) {
      controller.dispose();
    }
    for (var node in _cardNumberFocusNodes) {
      node.dispose();
    }
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _passwordController.dispose();
    _idNumberController.dispose();
    _expiryMonthFocusNode.dispose();
    _expiryYearFocusNode.dispose();
    _passwordFocusNode.dispose();
    _idNumberFocusNode.dispose();
    super.dispose();
  }

  void _validateCardNumber(int index) {
    setState(() {
      final text = _cardNumberControllers[index].text;
      if (text.isEmpty) {
        _cardNumberValid[index] = null; // Not started
      } else {
        _cardNumberValid[index] = text.length == 4;
      }

      // Auto-focus next field when current is complete
      if (_cardNumberValid[index] == true && index < 3) {
        _cardNumberFocusNodes[index + 1].requestFocus();
      }

      _updateGuideMessage();
    });
  }

  void _validateExpiryMonth() {
    setState(() {
      final text = _expiryMonthController.text;
      if (text.isEmpty) {
        _expiryMonthValid = null;
      } else {
        final month = int.tryParse(text);
        _expiryMonthValid = text.length == 2 && month != null && month >= 1 && month <= 12;
      }

      if (_expiryMonthValid == true) {
        _expiryYearFocusNode.requestFocus();
      }

      _updateGuideMessage();
    });
  }

  void _validateExpiryYear() {
    setState(() {
      final text = _expiryYearController.text;
      if (text.isEmpty) {
        _expiryYearValid = null;
      } else {
        _expiryYearValid = text.length == 4;
      }

      _updateGuideMessage();
    });
  }

  void _validatePassword() {
    setState(() {
      final text = _passwordController.text;
      if (text.isEmpty) {
        _passwordValid = null;
      } else {
        _passwordValid = text.length == 2;
      }

      _updateGuideMessage();
    });
  }

  void _validateIdNumber() {
    setState(() {
      final text = _idNumberController.text;
      if (text.isEmpty) {
        _idNumberValid = null;
      } else {
        _idNumberValid = text.length == 6;
      }

      _updateGuideMessage();
    });
  }

  void _updateGuideMessage() {
      // Check if all fields are valid
      bool allValid = _cardNumberValid.every((v) => v == true) &&
          _expiryMonthValid == true &&
          _expiryYearValid == true &&
          _passwordValid == true &&
          _idNumberValid == true &&
          _isPrivacyChecked;

      if (allValid) {
        _guideMessage = '정보가 다 잘 입력됐네요!\n이제 결제/발권 버튼을 눌러주세요!';
        return;
      }

      // Check for invalid previous card number fields
      for (int i = 0; i < 4; i++) {
        if (_cardNumberValid[i] == false) {
          _guideMessage = '카드번호 ${i + 1}번째 칸이 4자리가 아니에요!';
          return;
        }
      }

      // Check for invalid expiry month
      if (_expiryMonthValid == false) {
        _guideMessage = '월은 01부터 12까지 2자리로 입력해주세요';
        return;
      }

      // Check for invalid expiry year
      if (_expiryYearValid == false) {
        _guideMessage = '년도는 4자리 숫자로 입력해주세요';
        return;
      }

      // Check which field has focus
      for (int i = 0; i < 4; i++) {
        if (_cardNumberFocusNodes[i].hasFocus) {
          if (_cardNumberControllers[i].text.isEmpty) {
            _guideMessage = '카드번호를 입력해주세요';
          } else if (_cardNumberControllers[i].text.length < 4) {
            _guideMessage = '잘하고 있어요!';
          } else if (_cardNumberValid[i] == true && i < 3) {
            _guideMessage = '좋아요! 계속 입력해주세요!';
          } else if (_cardNumberValid[i] == true && i == 3) {
            _guideMessage = '카드번호 입력 완료! 잘하셨어요!';
          } else if (_cardNumberValid[i] == false) {
            _guideMessage = '카드번호는 4자리 숫자여야 해요!';
          }
          return;
        }
      }

      if (_expiryMonthFocusNode.hasFocus) {
        if (_expiryMonthController.text.isEmpty) {
          _guideMessage = '유효기간 월을 입력해주세요';
        } else if (_expiryMonthValid == true) {
          _guideMessage = '잘하고 있어요!';
        } else if (_expiryMonthValid == false) {
          _guideMessage = '월은 01부터 12까지 2자리로 입력해주세요';
        }
      } else if (_expiryYearFocusNode.hasFocus) {
        if (_expiryYearController.text.isEmpty) {
          _guideMessage = '년도를 입력해주세요\n네 자리 숫자로 써야해요';
        } else if (_expiryYearController.text.length < 4) {
          _guideMessage = '네 자리를 모두 입력해주세요';
        } else if (_expiryYearValid == true) {
          _guideMessage = '유효기간 입력 완료! 잘하셨어요!';
        } else if (_expiryYearValid == false) {
          _guideMessage = '년도는 4자리 숫자로 입력해주세요';
        }
      } else if (_passwordFocusNode.hasFocus) {
        if (_passwordController.text.isEmpty) {
          _guideMessage = '앗 눈가릴게요';
        } else if (_passwordController.text.length < 2) {
          _guideMessage = '한 자리 더 입력해주세요';
        } else if (_passwordValid == true) {
          _guideMessage = '잘하고 있어요!';
        } else if (_passwordValid == false) {
          _guideMessage = '비밀번호는 2자리 숫자여야 해요';
        }
      } else if (_idNumberFocusNode.hasFocus) {
        if (_idNumberController.text.isEmpty) {
          _guideMessage = '주민번호 앞 6자리를 입력해주세요';
        } else if (_idNumberController.text.length < 6) {
          _guideMessage = '6자리를 모두 입력해주세요';
        } else if (_idNumberValid == true) {
          _guideMessage = '거의 다 끝났어요! 잘하고 있어요!';
        } else if (_idNumberValid == false) {
          _guideMessage = '주민번호는 6자리 숫자여야 해요';
        }
      }
  }

  void _onCardScan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentScreen3CardScan(),
      ),
    );

    if (result != null && result is Map<String, String>) {
      // Auto-fill card information
      final cardNumber = result['cardNumber'] ?? '';
      final expiryDate = result['expiryDate'] ?? '';

      // Split card number into 4 parts
      if (cardNumber.length == 16) {
        _cardNumberControllers[0].text = cardNumber.substring(0, 4);
        _cardNumberControllers[1].text = cardNumber.substring(4, 8);
        _cardNumberControllers[2].text = cardNumber.substring(8, 12);
        _cardNumberControllers[3].text = cardNumber.substring(12, 16);
      }

      // Split expiry date (format: MM/YY)
      if (expiryDate.length == 5) {
        _expiryMonthController.text = expiryDate.substring(0, 2);
        _expiryYearController.text = '20${expiryDate.substring(3, 5)}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final bottomBarHeight = 70.0;
    final buttonAreaHeight = 80.0; // 버튼 영역 높이 (56 + 패딩)
    final guideZoneHeight = 100.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 메인 컨텐츠 영역
          Positioned.fill(
            bottom: bottomBarHeight + buttonAreaHeight + guideZoneHeight,
            child: Column(
              children: [
                // Header
                CustomHeader(
                  title: '결제',
                  topMargin: 50,
                  height: 70,
                ),

                // Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      if (index == 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentScreen2(),
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
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price info
                          _buildPriceRow('운임', '93,600원'),
                          _buildPriceRow('요금', '0원'),
                          _buildPriceRow('운임할인', '-28,000원'),
                          _buildPriceRow('요금할인', '0원'),
                          const Divider(height: 32, thickness: 1),
                          _buildPriceRow('결제금액', '65,600원', isBold: true),
                          const SizedBox(height: 8),
                          const Text(
                            '* 특(우등)실은 운임과 요금으로 구성되며 운임만 할인됨',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // KTX Mileage
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'KTX 마일리지',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8F0),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '사용',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B4FA3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Card type selection
                          const Center(
                            child: Text(
                              '신용(체크)카드',
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
                          const SizedBox(height: 40),

                          // Direct input section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '직접입력',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: _onCardScan,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xFF4A90E2),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: const Color(0xFF4A90E2),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        '카드스캔',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF4A90E2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 24),

                          // Card issuer (disabled)
                          Opacity(
                            opacity: 0.5,
                            child: IgnorePointer(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 80,
                                    child: Text(
                                      '지주쓰는\n카드',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '등록된 카드가 없습니다.',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Card number
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    '카드번호',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    _buildCardNumberInput(0),
                                    const SizedBox(width: 8),
                                    _buildCardNumberInput(1),
                                    const SizedBox(width: 8),
                                    _buildCardNumberInput(2),
                                    const SizedBox(width: 8),
                                    _buildCardNumberInput(3),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Expiry date
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    '유효기간',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: TextField(
                                        controller: _expiryMonthController,
                                        focusNode: _expiryMonthFocusNode,
                                        decoration: InputDecoration(
                                          hintText: 'MM',
                                          hintStyle: TextStyle(color: Colors.grey.shade400),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _expiryMonthValid == false ? Colors.red : Colors.grey.shade300,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _expiryMonthValid == false ? Colors.red : Colors.grey.shade300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _expiryMonthValid == false ? Colors.red : const Color(0xFF6B4FA3),
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        ),
                                        keyboardType: TextInputType.number,
                                        maxLength: 2,
                                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('월', style: TextStyle(fontSize: 16)),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: TextField(
                                        controller: _expiryYearController,
                                        focusNode: _expiryYearFocusNode,
                                        decoration: InputDecoration(
                                          hintText: 'YYYY',
                                          hintStyle: TextStyle(color: Colors.grey.shade400),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _expiryYearValid == false ? Colors.red : Colors.grey.shade300,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _expiryYearValid == false ? Colors.red : Colors.grey.shade300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _expiryYearValid == false ? Colors.red : const Color(0xFF6B4FA3),
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        ),
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('년', style: TextStyle(fontSize: 16)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Password
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    '비밀번호',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: TextField(
                                        controller: _passwordController,
                                        focusNode: _passwordFocusNode,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _passwordValid == false ? Colors.red : Colors.grey.shade300,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _passwordValid == false ? Colors.red : Colors.grey.shade300,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _passwordValid == false ? Colors.red : const Color(0xFF6B4FA3),
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        ),
                                        obscureText: true,
                                        keyboardType: TextInputType.number,
                                        maxLength: 2,
                                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('**', style: TextStyle(fontSize: 20)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Card type
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    '카드 종류',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Radio<String>(
                                          value: '개인',
                                          groupValue: '개인',
                                          onChanged: (value) {},
                                          activeColor: const Color(0xFF6B4FA3),
                                        ),
                                        const Text('개인', style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    const SizedBox(width: 24),
                                    Row(
                                      children: [
                                        Radio<String>(
                                          value: '법인',
                                          groupValue: '개인',
                                          onChanged: (value) {},
                                        ),
                                        const Text('법인', style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ID number
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    '인증 번호',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: _idNumberController,
                                      focusNode: _idNumberFocusNode,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _idNumberValid == false ? Colors.red : Colors.grey.shade300,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _idNumberValid == false ? Colors.red : Colors.grey.shade300,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: _idNumberValid == false ? Colors.red : const Color(0xFF6B4FA3),
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      ),
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '주민번호 앞 6자리',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B4FA3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Installment
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text(
                                    '할부기간',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '일시불',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF4A90E2),
                                        ),
                                      ),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _isPrivacyChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _isPrivacyChecked = value ?? false;
                                    if (_isPrivacyChecked) {
                                      _guideMessage = '정보가 잘 입력되었어요';
                                    }
                                  });
                                },
                                activeColor: const Color(0xFF6B4FA3),
                              ),
                              const Expanded(
                                child: Text(
                                  '개인정보 수집 및 이용 동의',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Guide Zone - 키보드가 열리면 키보드 위, 닫히면 버튼 영역 위에 위치
          Positioned(
            left: 0,
            right: 0,
            bottom: isKeyboardVisible
                ? keyboardHeight
                : 20 + buttonAreaHeight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: guideZoneHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: isKeyboardVisible
                    ? null
                    : LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          const Color(0xFFB5D4ED).withOpacity(0.75),
                          const Color(0xFFB5D4ED).withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.5],
                      ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    _guideMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Button Area - 하단바 바로 위에 고정
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  // 이전 button
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF6B4FA3),
                        ),
                        child: const Text(
                          '이전',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B4FA3),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 결제/발권 button
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B4FA3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Combine card numbers
                          String fullCardNumber = _cardNumberControllers.map((c) => c.text).join();

                          // Format expiry date as MM/YY
                          String expiryDate = '${_expiryMonthController.text}/${_expiryYearController.text.substring(2)}';

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen7(
                                cardNumber: fullCardNumber,
                                expiryDate: expiryDate,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          '결제/발권',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: isKeyboardVisible ? null : const BottomNavBar(),
    );
  }

  Widget _buildCardNumberInput(int index) {
    return Expanded(
      child: TextField(
        controller: _cardNumberControllers[index],
        focusNode: _cardNumberFocusNodes[index],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: _cardNumberValid[index] == false ? Colors.red : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _cardNumberValid[index] == false ? Colors.red : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _cardNumberValid[index] == false ? Colors.red : const Color(0xFF6B4FA3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        keyboardType: TextInputType.number,
        maxLength: 4,
        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
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
