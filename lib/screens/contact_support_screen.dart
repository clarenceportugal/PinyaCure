import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@pinyacure.com',
      query: 'subject=PinyaCure Support Request',
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      // Handle error - could show a snackbar
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+639123456789');
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Custom header with back button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primaryGreen,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/logo/pinyacure_logo.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.eco_rounded,
                        color: AppColors.primaryGreen,
                        size: 32,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Makipag-ugnayan at Suporta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Methods
                    Text(
                      'MGA PARAAN NG PAKIKIPAG-UGNAYAN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    _buildContactCard(
                      icon: Icons.email_rounded,
                      title: 'Suporta sa Email',
                      subtitle: 'support@pinyacure.com',
                      description: '',
                      onTap: _launchEmail,
                      color: AppColors.primaryGreen,
                    ),

                    const SizedBox(height: 12),

                    // Phone
                    _buildContactCard(
                      icon: Icons.phone_rounded,
                      title: 'Suporta sa Telepono',
                      subtitle: '+63 912 345 6789',
                      description: '',
                      onTap: _launchPhone,
                      color: AppColors.primaryGreen,
                    ),

                    const SizedBox(height: 32),

                    // FAQ Section
                    Text(
                      'MGA MADALAS NA TANONG',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildFAQItem(
                      question: 'Gaano katumpak ang pagtuklas ng sakit?',
                      answer: 'Ang aming ML model ay nagbibigay ng mataas na katumpakan sa pagtuklas ng mga karaniwang sakit ng pinya. Gayunpaman, para sa mga kritikal na kaso, inirerekomenda naming kumonsulta sa mga eksperto sa agrikultura.',
                    ),

                    const SizedBox(height: 12),

                    _buildFAQItem(
                      question: 'Magagamit ko ba ang app na ito nang offline?',
                      answer: 'Oo, ganap na offline ang app. Lahat ng features kasama ang pagtuklas ng sakit, kasaysayan ng pag-scan, at impormasyon sa gamot ay gumagana kahit walang koneksyon sa internet.',
                    ),

                    const SizedBox(height: 12),

                    _buildFAQItem(
                      question: 'Paano ko mapapabuti ang katumpakan ng pag-scan?',
                      answer: 'Tiyakin ang magandang ilaw, malinaw na focus, at kuhanan ang apektadong bahagi ng maayos. Iwasan ang mga anino at malabo na mga larawan para sa pinakamahusay na resulta.',
                    ),

                    const SizedBox(height: 12),

                    _buildFAQItem(
                      question: 'Ligtas ba ang aking datos?',
                      answer: 'Oo, lahat ng kasaysayan ng pag-scan ay naka-imbak sa iyong device. Hindi namin kinokolekta o ipinapadala ang iyong personal na datos nang walang iyong pahintulot.',
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline_rounded,
                size: 20,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMedium,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
