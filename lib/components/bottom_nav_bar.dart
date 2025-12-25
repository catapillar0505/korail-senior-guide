import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final VoidCallback? onHomePressed;
  final VoidCallback? onDanbiPressed;
  final VoidCallback? onTicketPressed;
  final bool isDanbiHighlighted;
  final bool isDanbiSpeaking;
  final Widget? danbiChild;

  const BottomNavBar({
    super.key,
    this.onHomePressed,
    this.onDanbiPressed,
    this.onTicketPressed,
    this.isDanbiHighlighted = false,
    this.isDanbiSpeaking = false,
    this.danbiChild,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Button
            GestureDetector(
              onTap: onHomePressed,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/figma_images/onboarding/home-bnt.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Danbi Button
            GestureDetector(
              onTap: onDanbiPressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 140,
                height: 56,
                decoration: BoxDecoration(
                  color: isDanbiHighlighted
                      ? const Color(0xFFCDE0EE)
                      : const Color(0xFF003D5B),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: danbiChild ??
                      Text(
                        '단비',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDanbiHighlighted
                              ? const Color(0xFF003D5B)
                              : Colors.white,
                        ),
                      ),
                ),
              ),
            ),

            // My Ticket Button
            GestureDetector(
              onTap: onTicketPressed,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/figma_images/onboarding/ticket-bnt.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
