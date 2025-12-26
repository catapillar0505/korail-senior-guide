import 'package:flutter/material.dart';
import '../components/layouts/custom_layout.dart';

class PaymentScreenFinal extends StatefulWidget {
  const PaymentScreenFinal({super.key});

  @override
  State<PaymentScreenFinal> createState() => _PaymentScreenFinalState();
}

class _PaymentScreenFinalState extends State<PaymentScreenFinal> {
  bool _showGuideZone = true;

  void _hideGuideZone() {
    setState(() {
      _showGuideZone = false;
    });
  }

  void _showGuideZoneAgain() {
    setState(() {
      _showGuideZone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      headerTitle: '나의 티켓',
      headerBackgroundColor: const Color(0xFF003D5B),
      body: GestureDetector(
        onTap: _hideGuideZone,
        child: SingleChildScrollView(
          child: Image.asset(
            'assets/figma_images/commoncard/final.png',
            fit: BoxFit.fitWidth,
            width: double.infinity,
          ),
        ),
      ),
      showGuideZone: _showGuideZone,
      guideText: '티켓 발급이 완료되었습니다!',
      backgroundColor: Colors.white,
      onDanbiPressed: _showGuideZoneAgain,
    );
  }
}
