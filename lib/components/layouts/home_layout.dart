import 'package:flutter/material.dart';
import '../app_header.dart';
import '../bottom_nav_bar.dart';
import '../ai_guide_zone.dart';

class MainLayout extends StatelessWidget {
  // Header props
  final AppHeader? header;
  final bool showHeader;

  // Body
  final Widget body;

  // AI Guide Zone props
  final String? guideText;
  final bool showGuideZone;
  final double guideZoneHeight;

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

  const MainLayout({
    super.key,
    this.header,
    this.showHeader = true,
    required this.body,
    this.guideText,
    this.showGuideZone = false,
    this.guideZoneHeight = 200,
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
                // Header
                if (showHeader)
                  header ?? const AppHeader.image(),

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
              ),
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
