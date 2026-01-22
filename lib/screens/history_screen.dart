import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../constants/app_colors.dart';
import '../services/history_service.dart';
import '../data/nutrient_deficiencies.dart';
import 'treatment_screen.dart';
import 'image_viewer_screen.dart';
import 'nutrient_deficiency_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService.instance;
  List<ScanHistoryItem> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });
    
    final history = await _historyService.getHistory();
    
    if (mounted) {
      setState(() {
        _history = history;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteScan(ScanHistoryItem item) async {
    await _historyService.deleteScan(item.id);
    await _loadHistory();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nabura na ang scan'),
          backgroundColor: AppColors.primaryGreen,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Burahin Lahat ng Kasaysayan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sigurado ka bang gusto mong burahin lahat ng kasaysayan ng pag-scan?',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hindi na maibabalik ang aksyong ito.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: AppColors.cardBorder),
              ),
            ),
            child: Text(
              'Kanselahin',
              style: TextStyle(
                color: AppColors.textMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Burahin Lahat',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _historyService.clearHistory();
      await _loadHistory();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('Matagumpay na nabura ang kasaysayan'),
              ],
            ),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'KASAYSAYAN'),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    )
                  : _history.isEmpty
                      ? _buildEmptyState()
                      : _buildHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Walang kasaysayan ng pag-scan',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dito makikita ang iyong mga resulta ng pag-scan',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children: [
        // Clear all button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _clearAllHistory,
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 16,
                color: AppColors.error,
              ),
              label: Text(
                'Burahin Lahat',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // History list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _history.length + 1, // +1 for bottom padding
            itemBuilder: (context, index) {
              if (index == _history.length) {
                return const SizedBox(height: 20);
              }
              final item = _history[index];
              return _buildHistoryCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(ScanHistoryItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            if (item.imagePath != null)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageViewerScreen(
                        imagePath: item.imagePath!,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: AppColors.divider,
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Image.file(
                          File(item.imagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.divider,
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported_rounded,
                                  color: AppColors.textLight,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Date badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _formatDate(item.timestamp),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Zoom icon
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.zoom_in_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disease and Delete button row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.disease,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.analytics_rounded,
                                  size: 14,
                                  color: AppColors.textMedium,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.confidence.toStringAsFixed(0)}% Katiyakan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMedium,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                            color: AppColors.error,
                          ),
                        ),
                        onPressed: () => _deleteScan(item),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Nutrient Deficiency info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item.nutrientDeficiency != null 
                          ? AppColors.accentBlue.withOpacity(0.1)
                          : item.nutrientDeficiencyName == 'Walang Kakulangan'
                              ? AppColors.primaryGreen.withOpacity(0.1)
                              : AppColors.divider,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: item.nutrientDeficiency != null 
                            ? AppColors.accentBlue.withOpacity(0.3)
                            : item.nutrientDeficiencyName == 'Walang Kakulangan'
                                ? AppColors.primaryGreen.withOpacity(0.3)
                                : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.nutrientDeficiency != null 
                              ? Icons.warning_rounded
                              : item.nutrientDeficiencyName == 'Walang Kakulangan'
                                  ? Icons.check_circle_rounded
                                  : Icons.eco_rounded,
                          size: 18,
                          color: item.nutrientDeficiency != null 
                              ? Colors.orange.shade700
                              : item.nutrientDeficiencyName == 'Walang Kakulangan'
                                  ? AppColors.primaryGreen
                                  : AppColors.textLight,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.nutrientDeficiency != null 
                                ? 'Nutrient: ${item.nutrientDeficiencyName}'
                                : item.nutrientDeficiencyName == 'Walang Kakulangan'
                                    ? 'Nutrient: Walang Kakulangan'
                                    : 'Nutrient: Walang datos ng modelo',
                            style: TextStyle(
                              fontSize: 13,
                              color: item.nutrientDeficiency != null 
                                  ? Colors.orange.shade700
                                  : item.nutrientDeficiencyName == 'Walang Kakulangan'
                                      ? AppColors.primaryGreen
                                      : AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (item.nutrientDeficiency != null)
                          GestureDetector(
                            onTap: () => _openNutrientScreen(context, item.nutrientDeficiency!),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Colors.orange.shade700,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),

                  // Sweetness info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item.sweetnessLevel != null 
                          ? AppColors.accentYellowLight.withOpacity(0.2)
                          : AppColors.divider,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: item.sweetnessLevel != null 
                            ? AppColors.accentYellowDark.withOpacity(0.3)
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: item.sweetnessLevel != null 
                              ? AppColors.accentYellowDark
                              : AppColors.textLight,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.sweetnessLevel != null 
                              ? 'Tamis: ${item.sweetnessName} (${item.sweetnessLevel})'
                              : 'Tamis: Walang datos ng modelo',
                          style: TextStyle(
                            fontSize: 13,
                            color: item.sweetnessLevel != null 
                                ? AppColors.textDark
                                : AppColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // View Treatment Button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TreatmentScreen(
                            diseaseName: item.disease,
                            confidence: item.confidence,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Tingnan ang Gamot',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
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

  void _openNutrientScreen(BuildContext context, String nutrient) {
    final deficiencyInfo = NutrientDeficiencies.getDeficiency(nutrient);
    if (deficiencyInfo != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NutrientDeficiencyScreen(
            deficiency: deficiencyInfo,
          ),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Ngayon lang';
        }
        return '${difference.inMinutes} minuto ang nakalipas';
      }
      return '${difference.inHours} oras ang nakalipas';
    } else if (difference.inDays == 1) {
      return 'Kahapon';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} araw ang nakalipas';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
