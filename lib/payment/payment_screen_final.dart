import 'package:flutter/material.dart';

class PaymentScreenFinal extends StatelessWidget {
  const PaymentScreenFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full screen image
          Positioned.fill(
            top: MediaQuery.of(context).padding.top,
            child: Image.asset(
              'assets/figma_images/commoncard/final.png',
              fit: BoxFit.cover,
            ),
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
