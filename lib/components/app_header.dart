import 'package:flutter/material.dart';

enum HeaderType {
  image,
  custom,
}

class AppHeader extends StatelessWidget {
  final HeaderType type;
  final String? imagePath;
  final String? title;
  final Color? backgroundColor;
  final VoidCallback? onClosePressed;
  final Widget? customHeader;

  const AppHeader({
    super.key,
    this.type = HeaderType.image,
    this.imagePath = 'assets/figma_images/onboarding/top-navbar.png',
    this.title,
    this.backgroundColor,
    this.onClosePressed,
    this.customHeader,
  });

  const AppHeader.image({
    super.key,
    String imagePath = 'assets/figma_images/onboarding/top-navbar.png',
  })  : type = HeaderType.image,
        imagePath = imagePath,
        title = null,
        backgroundColor = null,
        onClosePressed = null,
        customHeader = null;

  const AppHeader.custom({
    super.key,
    required String title,
    Color backgroundColor = const Color(0xFF6B4FA3),
    VoidCallback? onClosePressed,
  })  : type = HeaderType.custom,
        imagePath = null,
        title = title,
        backgroundColor = backgroundColor,
        onClosePressed = onClosePressed,
        customHeader = null;

  const AppHeader.widget({
    super.key,
    required Widget customHeader,
  })  : type = HeaderType.custom,
        imagePath = null,
        title = null,
        backgroundColor = null,
        onClosePressed = null,
        customHeader = customHeader;

  @override
  Widget build(BuildContext context) {
    if (customHeader != null) {
      return customHeader!;
    }

    if (type == HeaderType.image) {
      return Image.asset(
        imagePath!,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );
    }

    // Custom header
    return Container(
      margin: const EdgeInsets.only(top: 50),
      height: 80,
      color: backgroundColor ?? const Color(0xFF6B4FA3),
      child: Stack(
        children: [
          Center(
            child: Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (onClosePressed != null)
            Positioned(
              right: 24,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: onClosePressed,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
