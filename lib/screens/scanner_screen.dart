import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/app_header.dart';
import '../constants/app_colors.dart';
import '../services/ml_service.dart';
import 'treatment_screen.dart';

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
  String detectedDisease = 'Tap camera to scan';
  double confidence = 0.0;
  String sweetnessLevel = 'M3';
  String sweetnessName = 'Sweet';

  // ML Service
  final MLService _mlService = MLService.instance;

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

      // Find the back camera (main 1x camera)
      CameraDescription? backCamera;
      for (final camera in _cameras!) {
        if (camera.lensDirection == CameraLensDirection.back) {
          backCamera = camera;
          break; // Use the first back camera (usually the main 1x camera)
        }
      }

      // If no back camera found, use the first available camera
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

    if (_isAnalyzing) return; // Prevent multiple scans

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Take picture
      final XFile photo = await _controller!.takePicture();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Analyzing image...'),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 1),
          ),
        );
      }

      // Analyze with ML model
      final diagnosisResult = await _mlService.analyzeImage(photo.path);
      final sweetnessResult = await _mlService.predictSweetness(photo.path);

      if (mounted) {
        setState(() {
          detectedDisease = diagnosisResult.disease;
          confidence = diagnosisResult.confidence;
          sweetnessLevel = sweetnessResult.level;
          sweetnessName = sweetnessResult.levelName;
          _isAnalyzing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(diagnosisResult.isModelLoaded 
              ? 'Analysis complete!' 
              : 'Model not loaded - showing placeholder'),
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
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'SCANNER'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Camera Preview Area
                    Expanded(
                      flex: 5,
                      child: GestureDetector(
                        onTap: _takePicture,
                        child: _buildCameraContainer(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Diagnosis Summary Card
                    _buildDiagnosisCard(),

                    const SizedBox(height: 8),

                    // Sweetness Level Card
                    _buildSweetnessCard(),

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

  Widget _buildCameraContainer() {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.getDividerColor(context),
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
          color: AppColors.getDividerColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 48,
                color: AppColors.getTextLightColor(context),
              ),
              const SizedBox(height: 12),
              Text(
                'Camera permission required',
                style: TextStyle(color: AppColors.getTextLightColor(context)),
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
                child: const Text('Open Settings'),
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
          color: AppColors.getDividerColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 48,
                color: AppColors.getTextLightColor(context),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap to scan',
                style: TextStyle(color: AppColors.getTextLightColor(context)),
              ),
            ],
          ),
        ),
      );
    }

    // Camera is initialized - show with 1:1 aspect ratio (square)
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
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.getCardBorderColor(context)),
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
          // Title with pineapple icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.accentYellowLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.asset(
                  'assets/logo/pinyacure_logo.png',
                  width: 18,
                  height: 18,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.eco_rounded,
                      color: AppColors.primaryGreen,
                      size: 18,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Diagnosis Summary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Detected: $detectedDisease',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${confidence.toStringAsFixed(0)}% Confidence',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.getTextMediumColor(context),
            ),
          ),
          const SizedBox(height: 10),
          // View Treatment Button
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
                    'View Treatment',
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

  Widget _buildSweetnessCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.getCardBorderColor(context)),
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
          Text(
            'Sweetness Level',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          // Gradient Bar with Pineapple Icon
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Gradient Bar
              Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: AppColors.sweetnessGradient,
                ),
              ),
              // Pineapple Icon above M3
              Positioned(
                top: -20,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    const Expanded(flex: 2, child: SizedBox()),
                    Container(
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
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'M1',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextMediumColor(context),
                ),
              ),
              Text(
                'M2',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextMediumColor(context),
                ),
              ),
              Text(
                'M3',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextMediumColor(context),
                ),
              ),
              Text(
                'M4',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextMediumColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentYellowLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Sweetness: ${_getSweetnessText(sweetnessLevel)} ($sweetnessLevel)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accentYellowDark,
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

  String _getSweetnessText(String level) {
    final texts = {
      'M1': 'Mild',
      'M2': 'Moderate',
      'M3': 'Sweet',
      'M4': 'Very Sweet',
    };
    return texts[level] ?? 'Sweet';
  }
}
