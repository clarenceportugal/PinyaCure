import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  static MLService? _instance;
  Interpreter? _diseaseInterpreter;
  Interpreter? _sweetnessInterpreter;
  List<String> _diseaseLabels = [];
  List<String> _sweetnessLabels = [];
  bool _isInitialized = false;

  // Singleton pattern
  static MLService get instance {
    _instance ??= MLService._();
    return _instance!;
  }

  MLService._();

  bool get isInitialized => _isInitialized;

  /// Initialize the ML models
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load disease detection model
      await _loadDiseaseModel();
      
      // Load sweetness prediction model
      await _loadSweetnessModel();

      _isInitialized = true;
      print('ML Service initialized successfully');
    } catch (e) {
      print('Error initializing ML Service: $e');
      _isInitialized = false;
    }
  }

  Future<void> _loadDiseaseModel() async {
    try {
      _diseaseInterpreter = await Interpreter.fromAsset('models/disease_model.tflite');
      _diseaseLabels = await _loadLabels('assets/models/labels.txt');
      print('Disease model loaded: ${_diseaseLabels.length} classes');
    } catch (e) {
      print('Disease model not found or error loading: $e');
      // Use default labels if model not available
      _diseaseLabels = [
        'Healthy',
        'Phytophthora Heart Rot',
        'Bacterial Heart Rot',
        'Mealybug Wilt',
        'Fusarium Wilt',
      ];
    }
  }

  Future<void> _loadSweetnessModel() async {
    try {
      _sweetnessInterpreter = await Interpreter.fromAsset('models/sweetness_model.tflite');
      _sweetnessLabels = await _loadLabels('assets/models/labels_sweetness.txt');
      print('Sweetness model loaded: ${_sweetnessLabels.length} classes');
    } catch (e) {
      print('Sweetness model not found or error loading: $e');
      // Use default labels if model not available
      _sweetnessLabels = ['M1', 'M2', 'M3', 'M4'];
    }
  }

  Future<List<String>> _loadLabels(String path) async {
    try {
      final labelsData = await rootBundle.loadString(path);
      return labelsData.split('\n').where((label) => label.isNotEmpty).toList();
    } catch (e) {
      print('Error loading labels from $path: $e');
      return [];
    }
  }

  /// Analyze an image for disease detection
  Future<DiagnosisResult> analyzeImage(String imagePath) async {
    if (_diseaseInterpreter == null) {
      // Return placeholder result if model not loaded
      return DiagnosisResult(
        disease: 'Model not loaded',
        confidence: 0.0,
        isModelLoaded: false,
      );
    }

    try {
      // Load and preprocess image
      final imageData = await _preprocessImage(imagePath);
      
      // Run inference
      final output = List.filled(1 * _diseaseLabels.length, 0.0).reshape([1, _diseaseLabels.length]);
      _diseaseInterpreter!.run(imageData, output);
      
      // Get prediction
      final predictions = output[0] as List<double>;
      final maxIndex = _getMaxIndex(predictions);
      final confidence = predictions[maxIndex] * 100;
      
      return DiagnosisResult(
        disease: _diseaseLabels[maxIndex],
        confidence: confidence,
        isModelLoaded: true,
        allPredictions: Map.fromIterables(_diseaseLabels, predictions),
      );
    } catch (e) {
      print('Error during disease analysis: $e');
      return DiagnosisResult(
        disease: 'Analysis Error',
        confidence: 0.0,
        isModelLoaded: true,
        error: e.toString(),
      );
    }
  }

  /// Predict sweetness level from image
  Future<SweetnessResult> predictSweetness(String imagePath) async {
    if (_sweetnessInterpreter == null) {
      // Return placeholder result if model not loaded
      return SweetnessResult(
        level: 'M3',
        levelName: 'Sweet',
        confidence: 0.0,
        isModelLoaded: false,
      );
    }

    try {
      // Load and preprocess image
      final imageData = await _preprocessImage(imagePath);
      
      // Run inference
      final output = List.filled(1 * _sweetnessLabels.length, 0.0).reshape([1, _sweetnessLabels.length]);
      _sweetnessInterpreter!.run(imageData, output);
      
      // Get prediction
      final predictions = output[0] as List<double>;
      final maxIndex = _getMaxIndex(predictions);
      final confidence = predictions[maxIndex] * 100;
      final level = _sweetnessLabels[maxIndex];
      
      return SweetnessResult(
        level: level,
        levelName: _getSweetnessName(level),
        confidence: confidence,
        isModelLoaded: true,
      );
    } catch (e) {
      print('Error during sweetness prediction: $e');
      return SweetnessResult(
        level: 'M3',
        levelName: 'Sweet',
        confidence: 0.0,
        isModelLoaded: true,
        error: e.toString(),
      );
    }
  }

  /// Preprocess image for model input
  Future<List<List<List<List<double>>>>> _preprocessImage(String imagePath) async {
    // Read image file
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    
    // Decode image
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');
    
    // Resize to model input size (typically 224x224)
    const inputSize = 224;
    image = img.copyResize(image, width: inputSize, height: inputSize);
    
    // Convert to normalized float array [0, 1]
    final input = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            final pixel = image!.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );
    
    return input;
  }

  int _getMaxIndex(List<double> list) {
    int maxIndex = 0;
    double maxValue = list[0];
    for (int i = 1; i < list.length; i++) {
      if (list[i] > maxValue) {
        maxValue = list[i];
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  String _getSweetnessName(String level) {
    final names = {
      'M1': 'Mild',
      'M2': 'Moderate',
      'M3': 'Sweet',
      'M4': 'Very Sweet',
    };
    return names[level] ?? 'Unknown';
  }

  void dispose() {
    _diseaseInterpreter?.close();
    _sweetnessInterpreter?.close();
    _isInitialized = false;
  }
}

/// Result class for disease diagnosis
class DiagnosisResult {
  final String disease;
  final double confidence;
  final bool isModelLoaded;
  final Map<String, double>? allPredictions;
  final String? error;

  DiagnosisResult({
    required this.disease,
    required this.confidence,
    required this.isModelLoaded,
    this.allPredictions,
    this.error,
  });
}

/// Result class for sweetness prediction
class SweetnessResult {
  final String level;
  final String levelName;
  final double confidence;
  final bool isModelLoaded;
  final String? error;

  SweetnessResult({
    required this.level,
    required this.levelName,
    required this.confidence,
    required this.isModelLoaded,
    this.error,
  });
}
