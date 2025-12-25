import 'package:flutter/material.dart';

class AiGuideZone extends StatelessWidget {
  final String guideText;
  final bool showNextButton;
  final VoidCallback? onNextPressed;
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
    this.showNextButton = false,
    this.onNextPressed,
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              gradientStartColor.withOpacity(gradientStartOpacity),
              gradientEndColor.withOpacity(gradientEndOpacity),
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
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
              if (showNextButton && onNextPressed != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onNextPressed,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 10),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '다음 >',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w100,
                        color: textColor,
                      ),
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
