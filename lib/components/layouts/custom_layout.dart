import 'package:flutter/material.dart';
import '../custom_header.dart';
import '../bottom_nav_bar.dart';
import '../ai_guide_zone.dart';

class CustomLayout extends StatelessWidget {
  // Header props
  final String headerTitle;
  final Color headerBackgroundColor;
  final VoidCallback? onBackPressed;
  final bool showHeader;
  final bool showBackButton;

  // Body
  final Widget body;

  // AI Guide Zone props
  final String? guideText;
  final bool showGuideZone;
  final double guideZoneHeight;
  final AlignmentGeometry guideTextAlignment;

  // Overlay widgets (for modals, etc.)
  final List<Widget>? overlayWidgets;

  // Bottom Navigation Bar props
  final VoidCallback? onHomePressed;
  final VoidCallback? onDanbiPressed;
  final VoidCallback? onTicketPressed;
  final bool isDanbiHighlighted;
  final bool isDanbiSpeaking;
  final Widget? danbiChild;
  final bool showBottomNavBar;

  // Background color
  final Color backgroundColor;

  const CustomLayout({
    super.key,
    required this.headerTitle,
    this.headerBackgroundColor = const Color(0xFF0C3C61),
    this.onBackPressed,
    this.showHeader = true,
    this.showBackButton = true,
    required this.body,
    this.guideText,
    this.showGuideZone = true,
    this.guideZoneHeight = 200,
    this.guideTextAlignment = Alignment.center,
    this.overlayWidgets,
    this.onHomePressed,
    this.onDanbiPressed,
    this.onTicketPressed,
    this.isDanbiHighlighted = false,
    this.isDanbiSpeaking = false,
    this.danbiChild,
    this.showBottomNavBar = true,
    this.backgroundColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Custom Header
                if (showHeader)
                  CustomHeader(
                    title: headerTitle,
                    backgroundColor: headerBackgroundColor,
                    showBackButton: showBackButton,
                    onBackPressed: onBackPressed,
                  ),

                // Body
                Expanded(
                  child: body,
                ),
              ],
            ),

            // AI Guide Zone
            if (showGuideZone && guideText != null)
              AiGuideZone(
                guideText: guideText!,
                height: guideZoneHeight,
                verticalAlignment: guideTextAlignment,
              ),

            // Overlay widgets (modals, etc.)
            if (overlayWidgets != null) ...overlayWidgets!,
          ],
        ),
      ),
      bottomNavigationBar: showBottomNavBar
          ? BottomNavBar(
              onHomePressed: onHomePressed,
              onDanbiPressed: onDanbiPressed,
              onTicketPressed: onTicketPressed,
              isDanbiHighlighted: isDanbiHighlighted,
              isDanbiSpeaking: isDanbiSpeaking,
              danbiChild: danbiChild,
            )
          : null,
    );
  }
}
