import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PaymentScreen5 extends StatefulWidget {
  const PaymentScreen5({super.key});

  @override
  State<PaymentScreen5> createState() => _PaymentScreen5State();
}

class _PaymentScreen5State extends State<PaymentScreen5> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false, // Disable audio to prevent audio permission request
        );

        await _cameraController!.initialize();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        debugPrint('Picture taken: ${image.path}');

        // Return mock card data (in real app, this would come from OCR)
        if (mounted) {
          // Navigate back to payment_screen_3_cardscan with card data
          // Pop payment_screen_5 and payment_screen_4
          Navigator.of(context).pop(); // Pop payment_screen_5
          Navigator.of(context).pop({   // Pop payment_screen_4 with result
            'cardNumber': '5272829346788373',
            'expiryDate': '06/26',
          });
        }
      } catch (e) {
        debugPrint('Error taking picture: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
        children: [
          // Top bar
          Container(
            height: 50,
            color: const Color(0xFF003D5B),
          ),

          // Instruction text
          Container(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 12),
            child: const Text(
              '후면 카메라로 카드번호와 유효기간이 \n사각형 안에 가장 크게 보이도록\n가깝게 맞춰주세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Camera preview with red border (landscape orientation)
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.9 * 0.55, // Landscape aspect ratio
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 3,
                  ),
                ),
                child: _isCameraInitialized && _cameraController != null
                    ? ClipRect(
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width * 0.9 * 0.55,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Scan button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _takePicture,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003D5B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '스캔하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 100),
        ],
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
