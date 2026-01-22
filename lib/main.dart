import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/diseases_list_screen.dart';
import 'screens/history_screen.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinyaCure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          brightness: Brightness.light,
          primary: AppColors.primaryGreen,
          secondary: AppColors.accentYellow,
          tertiary: AppColors.accentBlue,
          surface: AppColors.backgroundWhite,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundWhite,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.cardWhite,
          foregroundColor: AppColors.primaryGreen,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          color: AppColors.cardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScannerScreen(),
    const DiseasesListScreen(),
    const HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreenDark.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
            child: SafeArea(
              top: false,
              child: Container(
                height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                _buildNavItem(0, Icons.home_rounded, 'TAHANAN'),
                _buildNavItem(1, Icons.camera_alt_rounded, 'I-SCAN'),
                _buildNavItem(2, Icons.list_alt_rounded, 'LISTAHAN'),
                _buildNavItem(3, Icons.history_rounded, 'KASAYSAYAN'),
              ],
              ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                          icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
