import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/app_header.dart';
import '../constants/app_colors.dart';
import '../services/ml_service.dart';
import '../services/history_service.dart';
import '../data/nutrient_deficiencies.dart';
import 'treatment_screen.dart';
import 'nutrient_deficiency_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isPermissionGranted = false;
  bool _isLoading = true;
  bool _isAnalyzing = false;

  // Scan results - will be updated by ML model
  String detectedDisease = 'Pindutin ang camera para mag-scan';
  bool _hasScanned = false;
  double confidence = 0.0;
  String? sweetnessLevel;
  String? sweetnessName;
  
  // Nutrient deficiency results
  String? nutrientDeficiency;
  String? nutrientDeficiencyName;
  double nutrientConfidence = 0.0;

  // ML Service
  final MLService _mlService = MLService.instance;
  final HistoryService _historyService = HistoryService.instance;

  @override
  void initState() {
    super.initState();
    _initializeAll();
  }

  Future<void> _initializeAll() async {
    await _initializeCamera();
    await _mlService.initialize();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    
    if (status.isDenied || status.isPermanentlyDenied) {
      setState(() {
        _isLoading = false;
        _isPermissionGranted = false;
      });
      return;
    }

    setState(() {
      _isPermissionGranted = true;
    });

    try {
      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      CameraDescription? backCamera;
      for (final camera in _cameras!) {
        if (camera.lensDirection == CameraLensDirection.back) {
          backCamera = camera;
          break;
        }
      }

      final selectedCamera = backCamera ?? _cameras!.first;

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialized = false;
        });
      }
    }
  }

  Future<void> _takePicture() async {
    if (!_isInitialized || _controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (_isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final XFile photo = await _controller!.takePicture();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Sinusuri ang larawan...'),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // Analyze with ML models
      final diagnosisResult = await _mlService.analyzeImage(photo.path);
      final sweetnessResult = await _mlService.predictSweetness(photo.path);
      final nutrientResult = await _mlService.predictNutrientDeficiency(photo.path);

      if (mounted) {
        setState(() {
          detectedDisease = diagnosisResult.disease;
          confidence = diagnosisResult.confidence;
          sweetnessLevel = sweetnessResult.level;
          sweetnessName = sweetnessResult.levelName;
          nutrientDeficiency = nutrientResult.deficiency;
          nutrientDeficiencyName = nutrientResult.deficiencyName;
          nutrientConfidence = nutrientResult.confidence;
          _isAnalyzing = false;
          _hasScanned = true;
        });

        // Save to history
        await _historyService.saveScan(
          ScanHistoryItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            disease: diagnosisResult.disease,
            confidence: diagnosisResult.confidence,
            sweetnessLevel: sweetnessResult.level,
            sweetnessName: sweetnessResult.levelName,
            nutrientDeficiency: nutrientResult.deficiency,
            nutrientDeficiencyName: nutrientResult.deficiencyName,
            nutrientConfidence: nutrientResult.confidence,
            imagePath: photo.path,
            timestamp: DateTime.now(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(diagnosisResult.isModelLoaded 
              ? 'Tapos na ang pagsusuri!' 
              : 'Hindi na-load ang modelo - placeholder lamang'),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'I-SCAN'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Camera Preview Area
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: GestureDetector(
                        onTap: _takePicture,
                        child: _buildCameraContainer(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Diagnosis Summary Card
                    _buildDiagnosisCard(),

                    const SizedBox(height: 8),

                    // Nutrient Deficiency Card
                    _buildNutrientCard(),

                    const SizedBox(height: 8),

                    // Sweetness Level Card
                    _buildSweetnessCard(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraContainer() {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryGreen,
          ),
        ),
      );
    }

    if (!_isPermissionGranted) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 48,
                color: AppColors.textLight,
              ),
              const SizedBox(height: 12),
              Text(
                'Kailangan ang pahintulot sa camera',
                style: TextStyle(color: AppColors.textLight),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
                  _initializeCamera();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Buksan ang Settings'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _controller == null || !_controller!.value.isInitialized) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 48,
                color: AppColors.textLight,
              ),
              const SizedBox(height: 12),
              Text(
                'Pindutin para mag-scan',
                style: TextStyle(color: AppColors.textLight),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.previewSize?.height ?? 1,
              height: _controller!.value.previewSize?.width ?? 1,
              child: CameraPreview(_controller!),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.bug_report_rounded,
                  color: AppColors.error,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Pagsusuri ng Sakit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Natukoy: $detectedDisease',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${confidence.toStringAsFixed(0)}% Katiyakan',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _openTreatmentScreen(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tingnan ang Gamot',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primaryGreen,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard() {
    final hasDeficiency = nutrientDeficiency != null && nutrientDeficiency!.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentBlue.withOpacity(0.08),
            blurRadius: 8,
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
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.eco_rounded,
                  color: AppColors.accentBlue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Kakulangan sa Nutrient',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Nutrient status bar (similar to sweetness)
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Gradient Bar - Green to Orange to Red
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen,
                          AppColors.primaryGreenLight,
                          Colors.orange.shade300,
                          Colors.orange.shade500,
                          Colors.red.shade400,
                        ],
                      ),
                    ),
                  ),
                  // Indicator icon - only show when there's a scan result
                  if (nutrientDeficiencyName != null)
                    Positioned(
                      top: -20,
                      left: _getNutrientPosition(hasDeficiency, constraints.maxWidth),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          hasDeficiency ? Icons.warning_rounded : Icons.check_circle_rounded,
                          color: hasDeficiency ? Colors.orange.shade700 : AppColors.primaryGreen,
                          size: 22,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Malusog', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
              Text('Bahagya', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
              Text('Malubha', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
            ],
          ),
          const SizedBox(height: 8),
          // Status text
          Center(
            child: GestureDetector(
              onTap: hasDeficiency ? () => _openNutrientScreen(context) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: nutrientDeficiencyName == null
                      ? AppColors.divider
                      : hasDeficiency
                          ? Colors.orange.shade100
                          : AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      nutrientDeficiencyName == null
                          ? 'Mag-scan para suriin'
                          : hasDeficiency
                              ? '$nutrientDeficiencyName'
                              : 'Walang Kakulangan - Malusog!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: nutrientDeficiencyName == null
                            ? AppColors.textLight
                            : hasDeficiency
                                ? Colors.orange.shade700
                                : AppColors.primaryGreen,
                      ),
                    ),
                    if (hasDeficiency) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: Colors.orange.shade700,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getNutrientPosition(bool hasDeficiency, double containerWidth) {
    // If no deficiency (healthy) - position at left (green area)
    // If has deficiency - position at middle-right (orange/red area)
    if (!hasDeficiency) {
      return (containerWidth * 0.1) - 11; // 10% from left
    } else {
      return (containerWidth * 0.7) - 11; // 70% from left (orange area)
    }
  }

  Widget _buildSweetnessCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentYellow.withOpacity(0.1),
            blurRadius: 8,
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
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.accentYellowLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: AppColors.accentYellowDark,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Antas ng Tamis',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: AppColors.sweetnessGradient,
                    ),
                  ),
                  if (sweetnessLevel != null)
                    Positioned(
                      top: -20,
                      left: _getSweetnessPosition(sweetnessLevel!, constraints.maxWidth),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.cardWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/logo/pinyacure_logo.png',
                          width: 22,
                          height: 22,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.eco_rounded,
                              color: AppColors.primaryGreen,
                              size: 22,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('M1', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
              Text('M2', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
              Text('M3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
              Text('M4', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: sweetnessLevel != null 
                    ? AppColors.accentYellowLight.withOpacity(0.5)
                    : AppColors.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                sweetnessLevel != null 
                    ? 'Tamis: ${_getSweetnessText(sweetnessLevel!)} ($sweetnessLevel)'
                    : 'Mag-scan para malaman ang tamis',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: sweetnessLevel != null 
                      ? AppColors.accentYellowDark
                      : AppColors.textLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openTreatmentScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TreatmentScreen(
          diseaseName: detectedDisease,
          confidence: confidence,
        ),
      ),
    );
  }

  void _openNutrientScreen(BuildContext context) {
    if (nutrientDeficiency == null) return;
    
    final deficiencyInfo = NutrientDeficiencies.getDeficiency(nutrientDeficiency!);
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

  String _getSweetnessText(String level) {
    final texts = {
      'M1': 'Bahagya',
      'M2': 'Katamtaman',
      'M3': 'Matamis',
      'M4': 'Sobrang Tamis',
    };
    return texts[level] ?? 'Matamis';
  }

  double _getSweetnessPosition(String level, double containerWidth) {
    final positions = {
      'M1': 0.125,
      'M2': 0.375,
      'M3': 0.625,
      'M4': 0.875,
    };
    final percentage = positions[level] ?? 0.625;
    return (containerWidth * percentage) - 11;
  }
}
