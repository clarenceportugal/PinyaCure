import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'HOME'),
            // Main Content - No scroll, fit everything
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Pineapple Illustration - takes most space
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Image.asset(
                          'assets/images/parts.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.eco_rounded,
                                    size: 80,
                                    color: AppColors.primaryGreenLight,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Pineapple Plant Illustration',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Description
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: Text(
                          'Pineapple (Ananas comosus) is a tropical fruit native to South America belonging to the Bromeliad family, instantly recognizable by its tough, spiky skin made of hexagonal "eyes" and a crown of stiff green leaves. Inside, the fruit offers juicy, bright yellow flesh with a vibrant sweet-tart flavor that makes it popular in cuisines worldwide, whether eaten fresh, juiced, or cooked. Beyond its unique taste, it is nutritionally significant for being rich in Vitamin C and Manganese, and it is famous for containing bromelain, a unique enzyme mixture that aids in protein digestion and possesses anti-inflammatory properties.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMedium,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Organizations Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ORGANIZATIONS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Organization Cards
                    SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildOrganizationCard(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildOrganizationCard(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Pagination dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDot(true),
                        const SizedBox(width: 8),
                        _buildDot(false),
                        const SizedBox(width: 8),
                        _buildDot(false),
                      ],
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accentYellowLight,
                  AppColors.primaryGreenLight.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'LOGO',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Organization Title',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primaryGreen : AppColors.divider,
      ),
    );
  }
}
