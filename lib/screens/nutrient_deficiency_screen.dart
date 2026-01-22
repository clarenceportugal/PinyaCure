import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/nutrient_deficiencies.dart';

class NutrientDeficiencyScreen extends StatelessWidget {
  final NutrientDeficiencyInfo deficiency;

  const NutrientDeficiencyScreen({
    super.key,
    required this.deficiency,
  });

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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentYellowLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.eco_rounded,
                      color: AppColors.accentYellowDark,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Detalye ng Kakulangan',
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
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Deficiency Name & Severity Badge
                    _buildDeficiencyHeader(),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    _buildSection(
                      'Paglalarawan',
                      Icons.info_outline_rounded,
                      [deficiency.description],
                      isDescription: true,
                    ),
                    
                    // Symptoms
                    if (deficiency.symptoms.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        'Mga Sintomas',
                        Icons.warning_amber_rounded,
                        deficiency.symptoms,
                        iconColor: AppColors.accentYellowDark,
                      ),
                    ],
                    
                    // Causes
                    if (deficiency.causes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        'Mga Sanhi',
                        Icons.help_outline_rounded,
                        deficiency.causes,
                        iconColor: AppColors.error,
                      ),
                    ],
                    
                    // Treatments
                    if (deficiency.treatments.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        'Gamot/Lunas',
                        Icons.medical_services_rounded,
                        deficiency.treatments,
                        iconColor: AppColors.primaryGreen,
                        isHighlighted: true,
                      ),
                    ],
                    
                    // Prevention
                    if (deficiency.preventions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSection(
                        'Pag-iwas',
                        Icons.shield_rounded,
                        deficiency.preventions,
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

  Widget _buildDeficiencyHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getSeverityColor(deficiency.severity).withOpacity(0.1),
            _getSeverityColor(deficiency.severity).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSeverityColor(deficiency.severity).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  deficiency.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getSeverityColor(deficiency.severity),
                  ),
                ),
              ),
              _buildSeverityBadge(deficiency.severity),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentYellowLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.science_rounded,
                  size: 14,
                  color: AppColors.accentYellowDark,
                ),
                const SizedBox(width: 4),
                Text(
                  'Nutrient: ${deficiency.nutrient}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentYellowDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(String severity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getSeverityColor(severity),
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

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'malubha':
        return Colors.red.shade700;
      case 'katamtaman':
        return Colors.orange.shade700;
      case 'banayad':
        return AppColors.primaryGreen;
      default:
        return AppColors.textMedium;
    }
  }

  Widget _buildSection(
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
            : AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primaryGreen.withOpacity(0.2)
              : AppColors.cardBorder,
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
                            color: AppColors.textMedium,
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
