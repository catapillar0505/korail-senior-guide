import 'package:flutter/material.dart';

class AiGuideZone extends StatelessWidget {
  final String guideText;
  final double height;
  final TextAlign textAlign;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color? backgroundColor;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final double gradientStartOpacity;
  final double gradientEndOpacity;
  final bool showGradient;
  final bool showBorder;
  final bool showRoundedCorners;
  final BoxShadow? boxShadow;
  final AlignmentGeometry verticalAlignment;
  final bool wrapWithPositioned;

  const AiGuideZone({
    super.key,
    required this.guideText,
    this.height = 200,
    this.textAlign = TextAlign.center,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w600,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.gradientStartColor = const Color(0xFFB5D4ED),
    this.gradientEndColor = const Color(0xFFB5D4ED),
    this.gradientStartOpacity = 0.75,
    this.gradientEndOpacity = 0.0,
    this.showGradient = false,
    this.showBorder = true,
    this.showRoundedCorners = true,
    this.boxShadow,
    this.verticalAlignment = Alignment.center,
    this.wrapWithPositioned = true,
  });

  @override
  Widget build(BuildContext context) {
    final containerWidget = Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: showRoundedCorners
            ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            : null,
        border: showBorder
            ? const Border(
                top: BorderSide(
                  color: Color(0xFFD2D2D2),
                  width: 2,
                ),
                bottom: BorderSide(
                  color: Color(0xFFD2D2D2),
                  width: 2,
                ),
              )
            : null,
        boxShadow: boxShadow != null ? [boxShadow!] : null,
      ),
      child: Stack(
        children: [
          // Gradient overlay (optional)
          if (showGradient)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    gradientStartColor.withValues(alpha: gradientStartOpacity),
                    gradientEndColor.withValues(alpha: gradientEndOpacity),
                  ],
                  stops: const [0.0, 0.3],
                ),
              ),
            ),
          // Text on top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: verticalAlignment,
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
        ],
      ),
    );

    if (wrapWithPositioned) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: containerWidget,
      );
    }

    return containerWidget;
  }
}
