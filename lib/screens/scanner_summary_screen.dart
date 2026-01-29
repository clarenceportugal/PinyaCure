import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class ScannerSummaryScreen extends StatelessWidget {
  final String? imagePath;
  final String detectedDisease;
  final double confidence;
  final String? sweetnessLevel;

  const ScannerSummaryScreen({
    super.key,
    this.imagePath,
    this.detectedDisease = 'Phytophthora Heart Rot (Top Rot)',
    this.confidence = 92.0,
    this.sweetnessLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'BUOD NG PAG-SCAN'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scanned Image Placeholder
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(imagePath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.image_rounded,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.image_rounded,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      // Diagnosis Summary Card
                      _buildDiagnosisCard(),

                      const SizedBox(height: 16),

                      // Sweetness Level Card
                      _buildSweetnessCard(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buod ng Diagnosis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Natukoy: $detectedDisease',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${confidence.toStringAsFixed(0)}% Katiyakan',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tingnan ang Gamot'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSweetnessCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Antas ng Tamis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Gradient Bar with Pineapple Icon
          Stack(
            children: [
              // Gradient Bar
              Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade200,
                      Colors.orange.shade400,
                      Colors.red.shade400,
                      Colors.red.shade700,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSweetnessLabel('M1'),
                    _buildSweetnessLabel('M2'),
                    _buildSweetnessLabel('M3'),
                    _buildSweetnessLabel('M4'),
                  ],
                ),
              ),
              // Pineapple Icon above M3 (positioned at ~66% of width)
              Positioned(
                top: -20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                    _buildPineappleIcon(),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              sweetnessLevel != null
                  ? 'Tamis: ${_getSweetnessText(sweetnessLevel!)} ($sweetnessLevel)'
                  : 'Mag-scan para malaman ang tamis',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSweetnessLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPineappleIcon() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.eco_rounded,
        color: Color(0xFF4CAF50),
        size: 24,
      ),
    );
  }

  String _getSweetnessText(String? level) {
    if (level == null) return 'Hindi Alam';
    final texts = {
      'M1': 'Bahagya',
      'M2': 'Katamtaman',
      'M3': 'Matamis',
      'M4': 'Sobrang Tamis',
    };
    return texts[level] ?? 'Matamis';
  }
}
