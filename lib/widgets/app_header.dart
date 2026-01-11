import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showHeadphoneIcon;

  const AppHeader({
    super.key,
    required this.title,
    this.showHeadphoneIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.getLightShadowColor(context),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and Title
          Row(
            children: [
              // Rounded square logo
              Container(
                width: 40,
                height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.getShadowColor(context),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/logo/pinyacure_logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreenLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.eco_rounded,
                          color: isDark ? AppColors.primaryGreenLight : Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // PINYACURE text - PINYA on top, CURE below (indented)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'PINYA',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreenDark, // Dark green
                      letterSpacing: 1.2,
                      height: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8), // Indent to align C with I or N
                    child: const Text(
                      'CURE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentYellow, // Bright yellow
                        letterSpacing: 1.2,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Headphone icon (theme-aware)
          if (showHeadphoneIcon)
            IconButton(
              icon: Icon(
                Icons.headphones_outlined,
                color: AppColors.getTextColor(context),
                size: 24,
              ),
              onPressed: () {
                // TODO: Add headphone functionality
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
