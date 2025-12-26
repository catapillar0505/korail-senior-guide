import 'package:flutter/material.dart';

class AiGuideZone extends StatelessWidget {
  final String guideText;
  final double height;
  final TextAlign textAlign;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final double gradientStartOpacity;
  final double gradientEndOpacity;

  const AiGuideZone({
    super.key,
    required this.guideText,
    this.height = 200,
    this.textAlign = TextAlign.center,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w600,
    this.textColor = Colors.black,
    this.gradientStartColor = const Color(0xFFB5D4ED),
    this.gradientEndColor = const Color(0xFFB5D4ED),
    this.gradientStartOpacity = 0.75,
    this.gradientEndOpacity = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(
              color: Color(0xFFD2D2D2),
              width: 2,
            ),
            bottom: BorderSide(
              color: Color(0xFFD2D2D2),
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Text(
              guideText,
              textAlign: textAlign,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
