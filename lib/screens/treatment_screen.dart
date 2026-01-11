import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/disease_treatments.dart';

class TreatmentScreen extends StatelessWidget {
  final String diseaseName;
  final double confidence;

  const TreatmentScreen({
    super.key,
    required this.diseaseName,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final disease = DiseaseTreatments.getDisease(diseaseName);

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Custom header with back button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.getCardColor(context),
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
                  Expanded(
                    child: Text(
                      'Treatment Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Disease Name & Severity Badge
                    _buildDiseaseHeader(context, disease),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    _buildSection(
                      context,
                      'Description',
                      Icons.info_outline_rounded,
                      [disease.description],
                      isDescription: true,
                    ),
                    
                    // Symptoms
                    if (disease.symptoms.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        context,
                        'Symptoms',
                        Icons.warning_amber_rounded,
                        disease.symptoms,
                        iconColor: AppColors.accentYellowDark,
                      ),
                    ],
                    
                    // Causes
                    if (disease.causes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        context,
                        'Causes',
                        Icons.bug_report_rounded,
                        disease.causes,
                        iconColor: AppColors.error,
                      ),
                    ],
                    
                    // Treatments
                    if (disease.treatments.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        context,
                        'Treatment',
                        Icons.medical_services_rounded,
                        disease.treatments,
                        iconColor: AppColors.primaryGreen,
                        isHighlighted: true,
                      ),
                    ],
                    
                    // Prevention
                    if (disease.preventions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        context,
                        'Prevention',
                        Icons.shield_rounded,
                        disease.preventions,
                        iconColor: AppColors.accentBlue,
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseHeader(BuildContext context, DiseaseInfo disease) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getSeverityColor(context, disease.severity).withOpacity(0.1),
            _getSeverityColor(context, disease.severity).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSeverityColor(context, disease.severity).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  disease.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _getSeverityColor(context, disease.severity),
                  ),
                ),
              ),
              _buildSeverityBadge(context, disease.severity),
            ],
          ),
          if (confidence > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.analytics_rounded,
                  size: 16,
                  color: AppColors.textMedium,
                ),
                const SizedBox(width: 4),
                Text(
                  '${confidence.toStringAsFixed(1)}% Confidence',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.getTextMediumColor(context),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(BuildContext context, String severity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getSeverityColor(context, severity),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        severity,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getSeverityColor(BuildContext context, String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red.shade700;
      case 'high':
        return Colors.orange.shade700;
      case 'medium':
        return Colors.amber.shade700;
      case 'low':
        return AppColors.primaryGreen;
      case 'none':
        return AppColors.accentBlue;
      default:
        return AppColors.getTextMediumColor(context);
    }
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<String> items, {
    Color iconColor = AppColors.primaryGreen,
    bool isHighlighted = false,
    bool isDescription = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.primaryGreen.withOpacity(0.05)
            : AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primaryGreen.withOpacity(0.2)
              : AppColors.getCardBorderColor(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isDescription)
            Text(
              items.first,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
                height: 1.5,
              ),
            )
          else
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.getTextMediumColor(context),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
