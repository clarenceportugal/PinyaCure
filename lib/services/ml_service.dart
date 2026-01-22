import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  static MLService? _instance;
  Interpreter? _diseaseInterpreter;
  Interpreter? _sweetnessInterpreter;
  Interpreter? _nutrientInterpreter;
  List<String> _diseaseLabels = [];
  List<String> _sweetnessLabels = [];
  List<String> _nutrientLabels = [];
  bool _isInitialized = false;

  // Singleton pattern
  static MLService get instance {
    _instance ??= MLService._();
    return _instance!;
  }

  MLService._();

  bool get isInitialized => _isInitialized;
  bool get isSweetnessModelLoaded => _sweetnessInterpreter != null;
  bool get isDiseaseModelLoaded => _diseaseInterpreter != null;
  bool get isNutrientModelLoaded => _nutrientInterpreter != null;

  /// Initialize the ML models
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load disease detection model
      await _loadDiseaseModel();
      
      // Load sweetness prediction model
      await _loadSweetnessModel();
      
      // Load nutrient deficiency model
      await _loadNutrientModel();

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

  Future<void> _loadNutrientModel() async {
    try {
      _nutrientInterpreter = await Interpreter.fromAsset('models/nutrient_model.tflite');
      _nutrientLabels = await _loadLabels('assets/models/labels_nutrient.txt');
      print('Nutrient model loaded: ${_nutrientLabels.length} classes');
    } catch (e) {
      print('Nutrient model not found or error loading: $e');
      // Use default labels if model not available
      _nutrientLabels = [
        'Walang Kakulangan',
        'Nitrogen (N)',
        'Phosphorus (P)',
        'Potassium (K)',
        'Iron (Fe)',
        'Zinc (Zn)',
        'Magnesium (Mg)',
        'Calcium (Ca)',
        'Boron (B)',
      ];
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
        disease: 'Hindi Na-load ang Modelo',
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
      // Return null result if model not loaded
      return SweetnessResult(
        level: null,
        levelName: null,
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
        level: null,
        levelName: null,
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
      'M1': 'Bahagya',
      'M2': 'Katamtaman',
      'M3': 'Matamis',
      'M4': 'Sobrang Tamis',
    };
    return names[level] ?? 'Hindi Alam';
  }

  /// Predict nutrient deficiency from image
  Future<NutrientResult> predictNutrientDeficiency(String imagePath) async {
    if (_nutrientInterpreter == null) {
      // Return placeholder result if model not loaded (simulate for demo)
      // In production, this would return null/error
      return NutrientResult(
        deficiency: null,
        deficiencyName: null,
        confidence: 0.0,
        isModelLoaded: false,
      );
    }

    try {
      // Load and preprocess image
      final imageData = await _preprocessImage(imagePath);
      
      // Run inference
      final output = List.filled(1 * _nutrientLabels.length, 0.0).reshape([1, _nutrientLabels.length]);
      _nutrientInterpreter!.run(imageData, output);
      
      // Get prediction
      final predictions = output[0] as List<double>;
      final maxIndex = _getMaxIndex(predictions);
      final confidence = predictions[maxIndex] * 100;
      final deficiency = _nutrientLabels[maxIndex];
      
      // If healthy/no deficiency
      if (deficiency == 'Walang Kakulangan' || maxIndex == 0) {
        return NutrientResult(
          deficiency: null,
          deficiencyName: 'Walang Kakulangan',
          confidence: confidence,
          isModelLoaded: true,
        );
      }
      
      return NutrientResult(
        deficiency: deficiency,
        deficiencyName: _getNutrientDeficiencyName(deficiency),
        confidence: confidence,
        isModelLoaded: true,
      );
    } catch (e) {
      print('Error during nutrient analysis: $e');
      return NutrientResult(
        deficiency: null,
        deficiencyName: null,
        confidence: 0.0,
        isModelLoaded: true,
        error: e.toString(),
      );
    }
  }

  String _getNutrientDeficiencyName(String nutrient) {
    final names = {
      'Walang Kakulangan': 'Walang Kakulangan',
      'Nitrogen (N)': 'Kakulangan sa Nitrogen',
      'Phosphorus (P)': 'Kakulangan sa Phosphorus',
      'Potassium (K)': 'Kakulangan sa Potassium',
      'Iron (Fe)': 'Kakulangan sa Iron',
      'Zinc (Zn)': 'Kakulangan sa Zinc',
      'Magnesium (Mg)': 'Kakulangan sa Magnesium',
      'Calcium (Ca)': 'Kakulangan sa Calcium',
      'Boron (B)': 'Kakulangan sa Boron',
    };
    return names[nutrient] ?? nutrient;
  }

  void dispose() {
    _diseaseInterpreter?.close();
    _sweetnessInterpreter?.close();
    _nutrientInterpreter?.close();
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
  final String? level;
  final String? levelName;
  final double confidence;
  final bool isModelLoaded;
  final String? error;

  SweetnessResult({
    this.level,
    this.levelName,
    required this.confidence,
    required this.isModelLoaded,
    this.error,
  });
}

/// Result class for nutrient deficiency prediction
class NutrientResult {
  final String? deficiency;
  final String? deficiencyName;
  final double confidence;
  final bool isModelLoaded;
  final String? error;

  NutrientResult({
    this.deficiency,
    this.deficiencyName,
    required this.confidence,
    required this.isModelLoaded,
    this.error,
  });
}
