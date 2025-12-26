import 'package:flutter/material.dart';
import 'payment_screen_final.dart';
import '../components/bottom_nav_bar.dart';

class PaymentScreen8 extends StatefulWidget {
  final String cardNumber;
  final String expiryDate;

  const PaymentScreen8({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
  });

  @override
  State<PaymentScreen8> createState() => _PaymentScreen8State();
}

class _PaymentScreen8State extends State<PaymentScreen8> {
  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode _nicknameFocusNode = FocusNode();
  String _guideMessage = '카드 이름을 만들어주세요';
  bool _isSaveEnabled = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_updateGuideMessage);
    _nicknameFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nicknameFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_nicknameFocusNode.hasFocus && _nicknameController.text.isNotEmpty) {
      // 키보드 완료 버튼 눌렀을 때 (포커스가 사라졌을 때)
      setState(() {
        _guideMessage = '좋은 이름이에요!';
        _isSaveEnabled = true;
      });
    } else if (_nicknameFocusNode.hasFocus) {
      // 포커스 받았을 때
      setState(() {
        if (_nicknameController.text.isEmpty) {
          _guideMessage = '카드 이름을 만들어주세요';
        }
      });
    }
  }

  void _updateGuideMessage() {
    if (_nicknameController.text.isNotEmpty) {
      if (_nicknameFocusNode.hasFocus) {
        // 입력 중일 때
        setState(() {
          _guideMessage = '카드 이름을 만들어주세요';
          _isSaveEnabled = true;
        });
      } else {
        setState(() {
          _isSaveEnabled = true;
        });
      }
    } else {
      setState(() {
        _guideMessage = '카드 이름을 만들어주세요';
        _isSaveEnabled = false;
      });
    }
  }

  String _formatCardNumber(String cardNumber) {
    // Format: 5272 **** **** 4303
    if (cardNumber.length == 16) {
      return '${cardNumber.substring(0, 4)} **** **** ${cardNumber.substring(12, 16)}';
    }
    return cardNumber;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final bottomBarHeight = 70.0;
    final buttonAreaHeight = 104.0; // 버튼 영역 높이 (56 + 패딩)
    final guideZoneHeight = 140.0;

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
                // Top bar with title and menu
                Container(
                  height: 100,
                  color: const Color(0xFF003D5B),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SizedBox(width: 40),
                      Text(
                        '자주쓰는 카드 설정',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card scan button
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF4A90E2),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.camera_alt,
                                  color: Color(0xFF4A90E2),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
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
                        const SizedBox(height: 32),

                        // Card nickname
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                '카드별칭',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _nicknameController,
                                focusNode: _nicknameFocusNode,
                                decoration: InputDecoration(
                                  hintText: '최대 10자리',
                                  hintStyle: TextStyle(color: Colors.grey.shade400),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF4A90E2)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF4A90E2)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF4A90E2), width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                maxLength: 10,
                                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Card number (disabled)
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                '카드번호',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: _formatCardNumber(widget.cardNumber)
                                    .split(' ')
                                    .map((part) => Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 8),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              border: Border.all(color: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              part,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Expiry date (disabled)
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                '유효기간',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      widget.expiryDate.substring(0, 2),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text('월', style: TextStyle(fontSize: 16)),
                                  ),
                                  Container(
                                    width: 90,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '20${widget.expiryDate.substring(3, 5)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
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
                        const SizedBox(height: 24),

                        // Card type
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                '카드 종류',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: '개인',
                                    groupValue: '개인',
                                    onChanged: null,
                                    activeColor: const Color(0xFF0D5A9B),
                                  ),
                                  const Text('개인', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 24),
                                  Radio<String>(
                                    value: '법인',
                                    groupValue: '개인',
                                    onChanged: null,
                                  ),
                                  const Text('법인', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Note
                        const Text(
                          '※ 암호화를 통해 안전하게 저장되며, 자주쓰는\n카드 관리 외 목적으로 사용되지 않습니다.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
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
                : bottomBarHeight + buttonAreaHeight,
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
              child: Center(
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

          // Save Button Area - 하단바 바로 위에 고정
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomBarHeight,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaveEnabled
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentScreenFinal(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSaveEnabled ? const Color(0xFF6B4FA3) : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey.shade400,
                  ),
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _isSaveEnabled ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar - 하단 고정
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(),
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
