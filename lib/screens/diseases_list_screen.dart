import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../constants/app_colors.dart';
import '../data/disease_treatments.dart';
import 'treatment_screen.dart';

class DiseasesListScreen extends StatefulWidget {
  const DiseasesListScreen({super.key});

  @override
  State<DiseasesListScreen> createState() => _DiseasesListScreenState();
}

class _DiseasesListScreenState extends State<DiseasesListScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // List of diseases to display
  final List<String> _diseases = [
    'Phytophthora Heart Rot',
    'Bacterial Heart Rot',
    'Mealybug Wilt',
    'Fusarium Wilt',
    'Healthy',
  ];

  List<String> get _filteredDiseases {
    if (_searchQuery.isEmpty) return _diseases;
    return _diseases
        .where((d) => d.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'LIST OF DISEASES'),
            Expanded(
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.getCardColor(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.getCardBorderColor(context)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search disease',
                          hintStyle: TextStyle(
                            color: AppColors.getTextLightColor(context),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.primaryGreen,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: AppColors.getTextLightColor(context),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Diseases List
                  Expanded(
                    child: _filteredDiseases.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 64,
                                  color: AppColors.getTextLightColor(context),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No diseases found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.getTextMediumColor(context),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _filteredDiseases.length + 1, // +1 for bottom padding
                            itemBuilder: (context, index) {
                              if (index == _filteredDiseases.length) {
                                return const SizedBox(height: 20);
                              }
                              final diseaseName = _filteredDiseases[index];
                              final disease = DiseaseTreatments.getDisease(diseaseName);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildDiseaseCard(context, disease),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(BuildContext context, DiseaseInfo disease) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with severity dot and name
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _getSeverityColor(disease.severity),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getSeverityColor(disease.severity).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          disease.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          disease.severity,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Description
          Text(
            disease.description,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMedium,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Symptoms preview
          if (disease.symptoms.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 14,
                  color: AppColors.accentYellowDark,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    disease.symptoms.take(2).join(' • '),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 14),
          
          // View Treatment Button
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TreatmentScreen(
                    diseaseName: disease.name,
                    confidence: 0,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Treatment',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primaryGreen,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
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
}
