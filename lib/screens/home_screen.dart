import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Sample organizations list
  final List<Map<String, String>> _organizations = [
    {
      'name': 'Kagawaran ng Agrikultura',
      'logo': 'DA',
    },
    {
      'name': 'Bureau of Plant Industry',
      'logo': 'BPI',
    },
    {
      'name': 'Philippine Council for Agriculture',
      'logo': 'PCA',
    },
    {
      'name': 'Agricultural Training Institute',
      'logo': 'ATI',
    },
    {
      'name': 'Lokal na Pamahalaan',
      'logo': 'LGU',
    },
    {
      'name': 'Kooperatiba ng mga Magsasaka',
      'logo': 'FC',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalPages => (_organizations.length / 2).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'TAHANAN'),
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
                                    'Larawan ng Halaman ng Pinya',
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
                          'Ang Pinya (Ananas comosus) ay isang tropikal na prutas na nagmula sa South America at kabilang sa pamilyang Bromeliad. Madaling makilala ito sa kanyang matigas at matulis na balat na may mga hexagonal na "mata" at korona ng matitibay na berdeng dahon. Sa loob, ang prutas ay may makatas at madilaw na laman na may matamis at maasim na lasa na ginagawa itong sikat sa buong mundo, kainin man ito ng sariwa, gawing juice, o lutuin. Bukod sa natatanging lasa nito, ito ay mayaman sa Vitamin C at Manganese, at sikat dahil sa bromelain, isang natatanging enzyme na tumutulong sa pagtunaw ng protina at may katangiang anti-inflammatory.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMedium,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Organizations Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'MGA ORGANISASYON',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Organization Cards - Scrollable
                    SizedBox(
                      height: 100,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: _totalPages,
                        itemBuilder: (context, pageIndex) {
                          final startIndex = pageIndex * 2;
                          final endIndex = (startIndex + 2).clamp(0, _organizations.length);
                          final pageOrgs = _organizations.sublist(startIndex, endIndex);
                          
                          return Row(
                            children: [
                              Expanded(
                                child: _buildOrganizationCard(
                                  name: pageOrgs[0]['name']!,
                                  logo: pageOrgs[0]['logo']!,
                                ),
                              ),
                              if (pageOrgs.length > 1) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildOrganizationCard(
                                    name: pageOrgs[1]['name']!,
                                    logo: pageOrgs[1]['logo']!,
                                  ),
                                ),
                              ] else
                                const Expanded(child: SizedBox()),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Pagination dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _totalPages,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildDot(index == _currentPage),
                        ),
                      ),
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

  Widget _buildOrganizationCard({required String name, required String logo}) {
    return Container(
      padding: const EdgeInsets.all(8),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
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
                logo,
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
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
