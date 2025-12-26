import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final double topMargin;
  final double height;
  final Color backgroundColor;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final IconData backIcon;
  final bool showBackButtonOnRight;

  const CustomHeader({
    super.key,
    required this.title,
    this.topMargin = 0,
    this.height = 56,
    this.backgroundColor = const Color(0xFF0C3C61),
    this.onBackPressed,
    this.showBackButton = false,
    this.backIcon = Icons.arrow_back,
    this.showBackButtonOnRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          margin: EdgeInsets.only(top: topMargin),
          height: height,
          color: backgroundColor,
          child: Stack(
            children: [
              // Back Button on Left (default)
              if (showBackButton && !showBackButtonOnRight)
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(
                      backIcon,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                  ),
                ),
              // Back Button on Right
              if (showBackButton && showBackButtonOnRight)
                Positioned(
                  right: 24,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: onBackPressed ?? () => Navigator.pop(context),
                    child: Icon(
                      backIcon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              // Title
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
