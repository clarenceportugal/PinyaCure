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

class _DiseasesListScreenState extends State<DiseasesListScreen> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  // List of diseases to display
  final List<String> _diseases = [
    'Phytophthora Heart Rot',
    'Bacterial Heart Rot',
    'Mealybug Wilt',
    'Fusarium Wilt',
    'Healthy',
  ];

  List<String> get _filteredDiseases {
    if (_searchQuery.isEmpty) {
      return _diseases;
    }
    return _diseases
        .where((d) => d.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'LISTAHAN'),
            
            // Tab Bar
            Container(
              margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textMedium,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                padding: const EdgeInsets.all(4),
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bug_report_rounded, size: 18),
                        SizedBox(width: 6),
                        Text('Mga Sakit'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
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
                    hintText: 'Maghanap...',
                          hintStyle: TextStyle(
                            color: AppColors.textLight,
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
                                    color: AppColors.textLight,
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

            const SizedBox(height: 12),

            // Tab Content
                  Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Diseases Tab
                  _buildDiseasesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseasesTab() {
    if (_filteredDiseases.isEmpty) {
      return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 64,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(height: 16),
                                Text(
              'Walang nakitang sakit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textMedium,
                                  ),
                                ),
                              ],
                            ),
      );
    }

    return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredDiseases.length + 1,
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
                    'Tingnan ang Gamot',
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
      case 'kritikal':
        return Colors.red.shade700;
      case 'high':
      case 'mataas':
        return Colors.orange.shade700;
      case 'medium':
      case 'katamtaman':
        return Colors.amber.shade700;
      case 'low':
      case 'mababa':
        return AppColors.primaryGreen;
      case 'none':
      case 'wala':
        return AppColors.accentBlue;
      default:
        return AppColors.textMedium;
    }
  }
}
