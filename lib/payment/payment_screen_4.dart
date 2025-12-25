import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'payment_screen_5.dart';

class PaymentScreen4 extends StatefulWidget {
  const PaymentScreen4({super.key});

  @override
  State<PaymentScreen4> createState() => _PaymentScreen4State();
}

class _PaymentScreen4State extends State<PaymentScreen4> {
  @override
  void initState() {
    super.initState();
    // Request camera permission directly after screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCameraPermission();
    });
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (!mounted) return;

    if (status.isGranted) {
      // Navigate to camera preview screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentScreen5(),
        ),
      );
    } else {
      // Go back if permission denied
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Stack(
        children: [
          // Background hint text
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                '카드번호와 유효기간이 사각형 안에\n가장 크게 보이도록 가깝게 맞춰주세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
            ),
          ),

          // Camera preview placeholder (black rectangle)
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.red,
                  width: 2,
                ),
              ),
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
