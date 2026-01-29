import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/app_header.dart';
import '../constants/app_colors.dart';
import '../services/ml_service.dart';
import '../services/history_service.dart';
import 'treatment_screen.dart';

/// Top-level for compute(): crops to camera frame and returns JPG bytes (runs off main thread).
Uint8List? _cropAndEncodeFrameForHistory(String imagePath) {
  try {
    final bytes = File(imagePath).readAsBytesSync();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return null;
    final w = image.width;
    final h = image.height;
    final minDim = w < h ? w : h;
    final cropX = (w - minDim) ~/ 2;
    final cropY = (h - minDim) ~/ 2;
    image = img.copyCrop(image, x: cropX, y: cropY, width: minDim, height: minDim);
    const maxSize = 512;
    if (minDim > maxSize) {
      image = img.copyResize(image, width: maxSize, height: maxSize, interpolation: img.Interpolation.linear);
    }
    final jpg = img.encodeJpg(image, quality: 85);
    return Uint8List.fromList(jpg);
  } catch (_) {
    return null;
  }
}

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
  bool _modelsReady = false;

  // Scan results - will be updated by ML model
  String detectedDisease = 'Pindutin ang camera para mag-scan';
  double confidence = 0.0;
  /// Top 3 disease predictions (name, confidence 0-100) from model, null before first scan
  List<MapEntry<String, double>>? top3Diseases;
  String? sweetnessLevel;
  String? sweetnessName;

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
    try {
      await _mlService.initialize();
      if (mounted) setState(() => _modelsReady = true);
    } catch (e) {
      if (mounted) setState(() => _modelsReady = false);
    }
    if (mounted) setState(() => _isLoading = false);
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
      
      // Set focus mode to auto-focus
      await _controller!.setFocusMode(FocusMode.auto);
      await _controller!.setExposureMode(ExposureMode.auto);

      if (mounted) {
        setState(() => _isInitialized = true);
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

  // Handle tap-to-focus
  Future<void> _onCameraTap(TapDownDetails details) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    try {
      // Calculate tap position relative to camera preview
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;
      
      final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
      final Size size = renderBox.size;
      
      // Convert to camera coordinates (0.0 to 1.0)
      final double x = localPosition.dx / size.width;
      final double y = localPosition.dy / size.height;
      
      // Set focus point
      await _controller!.setFocusPoint(Offset(x, y));
      await _controller!.setExposurePoint(Offset(x, y));
      
      // Trigger auto-focus
      await _controller!.setFocusMode(FocusMode.auto);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error setting focus point: $e');
      }
    }
  }

  /// Crops to camera frame and saves to app dir (heavy work in isolate so UI stays responsive).
  Future<String?> _saveCameraFrameForHistory(String imagePath) async {
    try {
      final jpgBytes = await compute(_cropAndEncodeFrameForHistory, imagePath);
      if (jpgBytes == null) return null;
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(jpgBytes);
      return file.path;
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to save camera frame for history: $e');
      return null;
    }
  }

  Future<void> _takePicture() async {
    if (!_isInitialized || _controller == null || !_controller!.value.isInitialized) return;
    if (_isAnalyzing) return;
    if (!_modelsReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Naglo-load pa ang mga model...'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      // Reset results when starting new scan
      top3Diseases = null;
      sweetnessLevel = null;
      sweetnessName = null;
    });

    try {
      // Ensure focus is set before taking picture
      await _controller!.setFocusMode(FocusMode.auto);
      
      // Wait a bit for focus to settle (optional, but helps with accuracy)
      await Future.delayed(const Duration(milliseconds: 300));
      
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

      // Verify models are loaded before scanning
      if (kDebugMode) {
        if (!_mlService.isDiseaseModelLoaded) {
          debugPrint('Warning: Disease model not loaded');
        }
        if (!_mlService.isSweetnessModelLoaded) {
          debugPrint('Warning: Sweetness model not loaded');
        }
      }

      // Run both models in parallel so scan is faster
      final results = await Future.wait([
        _mlService.analyzeImage(photo.path),
        _mlService.predictSweetness(photo.path),
      ]);
      final diagnosisResult = results[0] as DiagnosisResult;
      final sweetnessResult = results[1] as SweetnessResult;
      
      // Log results (sweetness comes from model only when isModelLoaded is true)
      if (kDebugMode) {
        debugPrint('=== SCAN RESULTS ===');
        debugPrint('Disease: ${diagnosisResult.disease} (${diagnosisResult.confidence.toStringAsFixed(1)}%) - Loaded: ${diagnosisResult.isModelLoaded}');
        debugPrint('Sweetness: ${sweetnessResult.level} (${sweetnessResult.confidence.toStringAsFixed(1)}%) - Loaded: ${sweetnessResult.isModelLoaded}');
      }

      if (mounted) {
        // Build top 3 from model allPredictions (sorted by confidence desc)
        List<MapEntry<String, double>>? top3;
        if (diagnosisResult.allPredictions != null &&
            diagnosisResult.allPredictions!.isNotEmpty) {
          final sorted = diagnosisResult.allPredictions!.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          top3 = sorted.take(3).toList();
        }
        setState(() {
          detectedDisease = diagnosisResult.disease;
          confidence = diagnosisResult.confidence;
          top3Diseases = top3;

          if (top3Diseases != null) {
            _showResultsBottomSheet();
          // Sweetness reading: use only when from model (isModelLoaded && level from inference)
          if (sweetnessResult.isModelLoaded && sweetnessResult.level != null) {
            sweetnessLevel = sweetnessResult.level;
            sweetnessName = sweetnessResult.levelName;
            if (kDebugMode) {
              debugPrint('Sweetness display: from model only — ${sweetnessResult.level} (${sweetnessResult.confidence.toStringAsFixed(1)}%)');
            }
          } else {
            sweetnessLevel = null;
            sweetnessName = null;
          }
          _isAnalyzing = false;
        }});

  


        // Save only the camera-frame (center square) image for history
        final String? savedFramePath = await _saveCameraFrameForHistory(photo.path);
        await _historyService.saveScan(
          ScanHistoryItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            disease: diagnosisResult.disease,
            confidence: diagnosisResult.confidence,
            sweetnessLevel: sweetnessResult.level,
            sweetnessName: sweetnessResult.levelName,
            imagePath: savedFramePath,
            timestamp: DateTime.now(),
          ),
        );

        if (mounted) {
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
                    // Camera Preview Area — loading overlay only on this frame
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GestureDetector(
                            onTapDown: _onCameraTap, // Tap to focus
                            onTap: _takePicture, // Long tap or double tap to capture
                            child: _buildCameraContainer(),
                          ),
                          if (_isAnalyzing)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(color: AppColors.primaryGreen),
                                    SizedBox(height: 16),
                                    Text(
                                      'Sinusuri ang larawan...',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Diagnosis Summary Card
                    _buildDiagnosisCard(),

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
          if (top3Diseases != null && top3Diseases!.isNotEmpty) ...[
            Text(
              'Natukoy (Top 3):',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            // Top 3: pinakamataas na confidence nasa taas (sorted by confidence desc)
            ...top3Diseases!.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final name = entry.value.key;
              final isTop = rank == 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$rank. ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isTop ? FontWeight.w600 : FontWeight.w500,
                        color: isTop ? AppColors.error : AppColors.textMedium,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isTop ? FontWeight.w600 : FontWeight.w500,
                          color: isTop ? AppColors.error : AppColors.textMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ] else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Natukoy: $detectedDisease',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ],
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
  
  
  
void _showResultsBottomSheet() {
  if (top3Diseases == null) return;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      // 🔽 20% of screen height
      double sheetHeight = MediaQuery.of(context).size.height * 0.4;

      return Container(
        height: sheetHeight,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const Text(
              'Resulta ng Pagsusuri',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: top3Diseases!.map((entry) {
                final isTop = top3Diseases!.indexOf(entry) == 0;
                return Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: isTop
                            ? AppColors.error.withOpacity(0.1)
                            : AppColors.divider,
                        child: Text(
                          '${(entry.value * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isTop
                                ? AppColors.error
                                : AppColors.textMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entry.key,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isTop ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // ✅ SafeArea prevents navigation bar overlap
            SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  minimumSize: const Size(double.infinity, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      );
    },
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
