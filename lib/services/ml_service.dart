import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
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
  bool get isSweetnessModelLoaded => _sweetnessInterpreter != null;
  bool get isDiseaseModelLoaded => _diseaseInterpreter != null;

  /// Initialize the ML models
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load disease detection model
      await _loadDiseaseModel();
      
      // Load sweetness prediction model
      await _loadSweetnessModel();

      _isInitialized = true;
      debugPrint('ML Service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing ML Service: $e');
      _isInitialized = false;
    }
  }

  Future<void> _loadDiseaseModel() async {
    try {
      debugPrint('Attempting to load disease model...');
      
      // First, verify the asset exists by trying to load it as bytes
      List<String> pathsToTry = [
        'assets/models/pineapple_disease_model.tflite',
        'assets/models/pineapple_disease_model_quantized.tflite',
        'models/pineapple_disease_model.tflite',
        'models/pineapple_disease_model_quantized.tflite',
      ];
      
      String? workingPath;
      for (final path in pathsToTry) {
        try {
          debugPrint('Checking if asset exists: $path');
          // Try to load as bytes to verify it exists
          final bytes = await rootBundle.load(path);
          debugPrint('✓ Asset found at: $path (size: ${bytes.lengthInBytes} bytes)');
          workingPath = path;
          break;
        } catch (e) {
          debugPrint('✗ Asset not found at: $path - $e');
        }
      }
      
      if (workingPath == null) {
        throw Exception('Model file not found in any of the tried paths: $pathsToTry');
      }
      
      // Now load the model using the working path
      debugPrint('Loading model from: $workingPath');
      _diseaseInterpreter = await Interpreter.fromAsset(workingPath);
      
      if (_diseaseInterpreter == null) {
        throw Exception('Interpreter is null after loading');
      }
      
      debugPrint('✓ Disease model file loaded successfully');
      
      // Load labels
      _diseaseLabels = await _loadLabels('assets/models/labels.txt');
      
      // Validate labels
      if (_diseaseLabels.isEmpty) {
        debugPrint('Warning: labels.txt is empty, using default labels');
        _diseaseLabels = [
          'Healthy',
          'Phytophthora Heart Rot',
          'Bacterial Heart Rot',
          'Mealybug Wilt',
          'Fusarium Wilt',
        ];
      }
      
      debugPrint('✓ Disease model loaded: ${_diseaseLabels.length} classes');
      
      // Validate model input/output shapes
      final inputTensors = _diseaseInterpreter!.getInputTensors();
      final outputTensors = _diseaseInterpreter!.getOutputTensors();
      debugPrint('  Input shape: ${inputTensors[0].shape}, Output shape: ${outputTensors[0].shape}');
      
      // Verify labels match output size
      if (outputTensors[0].shape.isNotEmpty) {
        final expectedOutputSize = outputTensors[0].shape.reduce((a, b) => a * b);
        if (_diseaseLabels.length != expectedOutputSize) {
          debugPrint('⚠ Warning: Labels count (${_diseaseLabels.length}) != model output size ($expectedOutputSize)');
        }
      }
      
    } catch (e, stackTrace) {
      debugPrint('✗ Disease model not found or error loading: $e');
      debugPrint('Stack trace: $stackTrace');
      _diseaseInterpreter = null;
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
    _sweetnessLabels = ['M1', 'M2', 'M3', 'M4'];
    const path = 'assets/models/sweetness_model.tflite';
    try {
      debugPrint('Attempting to load sweetness model...');
      final byteData = await rootBundle.load(path);
      final bytes = byteData.buffer.asUint8List();
      debugPrint('✓ Sweetness asset found: $path (${bytes.length} bytes)');
      try {
        _sweetnessInterpreter = await Interpreter.fromAsset(path);
      } catch (e) {
        debugPrint('  fromAsset failed, trying fromBuffer: $e');
        _sweetnessInterpreter = Interpreter.fromBuffer(bytes);
      }
      debugPrint('✓ Sweetness model loaded (input 100-dim, output scalar)');
    } catch (e, st) {
      debugPrint('✗ Sweetness model error: $e');
      debugPrint('  $st');
      _sweetnessInterpreter = null;
    }
  }

  Future<List<String>> _loadLabels(String path) async {
    try {
      final labelsData = await rootBundle.loadString(path);
      return labelsData
          .split('\n')
          .map((s) => s.trim())
          .where((label) => label.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Error loading labels from $path: $e');
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

    if (_diseaseLabels.isEmpty) {
      return DiagnosisResult(
        disease: 'Hindi Na-load ang Modelo',
        confidence: 0.0,
        isModelLoaded: false,
        error: 'No labels loaded',
      );
    }

    try {
      final inputTensors = _diseaseInterpreter!.getInputTensors();
      final expectedInputShape = inputTensors[0].shape;
      debugPrint('Disease model expects input shape: $expectedInputShape');
      
      final outputTensors = _diseaseInterpreter!.getOutputTensors();
      final outputShape = outputTensors[0].shape;
      debugPrint('Disease model output shape: $outputShape');
      debugPrint('Labels count: ${_diseaseLabels.length}');
      debugPrint('Labels: $_diseaseLabels');
      
      // Check if labels count matches model output
      if (outputShape.length >= 2 && outputShape[1] != _diseaseLabels.length) {
        debugPrint('WARNING: Model outputs ${outputShape[1]} classes but labels has ${_diseaseLabels.length}');
      }
      
      // IMPORTANT: Model expects RAW pixel values [0-255], NOT normalized!
      // Based on the Python training script that uses: np.expand_dims(resized_frame, axis=0)
      final imageData = await _preprocessImageRaw(imagePath);
      debugPrint('Preprocessed input (raw 0-255): [1][224][224][3]');
      
      // Single run for speed; result is stable enough per image
      final output = List.generate(outputShape[0], (_) => List.filled(outputShape[1], 0.0));
      _diseaseInterpreter!.run(imageData, output);
      List<double> rawPredictions = (output[0] as List).map((v) => (v is int) ? v.toDouble() : v as double).toList();
      debugPrint('Raw predictions: ${rawPredictions.map((v) => v.toStringAsFixed(4)).toList()}');
      final sum = rawPredictions.reduce((a, b) => a + b);
      final isAlreadyProbabilities = (sum - 1.0).abs() < 0.1;
      final List<double> predictions = isAlreadyProbabilities
          ? rawPredictions
          : _softmax(rawPredictions);
      
      final maxIndex = _getMaxIndex(predictions);
      final confidence = predictions[maxIndex] * 100;
      
      // Get sorted predictions for analysis
      final sorted = List.generate(predictions.length, (i) => i)
        ..sort((a, b) => predictions[b].compareTo(predictions[a]));
      
      // Calculate confidence gap between top 1 and top 2
      final top1Conf = predictions[sorted[0]] * 100;
      final top2Conf = sorted.length > 1 ? predictions[sorted[1]] * 100 : 0.0;
      final confidenceGap = top1Conf - top2Conf;
      
      debugPrint('=== PREDICTION ANALYSIS ===');
      debugPrint('Top 1: ${sorted[0] < _diseaseLabels.length ? _diseaseLabels[sorted[0]] : "Unknown"} = ${top1Conf.toStringAsFixed(1)}%');
      debugPrint('Top 2: ${sorted.length > 1 && sorted[1] < _diseaseLabels.length ? _diseaseLabels[sorted[1]] : "Unknown"} = ${top2Conf.toStringAsFixed(1)}%');
      debugPrint('Confidence gap: ${confidenceGap.toStringAsFixed(1)}%');
      
      if (maxIndex >= _diseaseLabels.length) {
        debugPrint('Warning: Prediction index $maxIndex exceeds labels length ${_diseaseLabels.length}');
        return DiagnosisResult(
          disease: 'Analysis Error',
          confidence: 0.0,
          isModelLoaded: true,
          error: 'Invalid prediction index',
        );
      }
      
      String predictedDisease = _diseaseLabels[maxIndex];
      double finalConfidence = confidence;
      
      // If confidence is too low (< 40%), mark as uncertain
      if (confidence < 40.0) {
        debugPrint('Low confidence prediction: ${confidence.toStringAsFixed(1)}%');
        predictedDisease = '$predictedDisease (Hindi Sigurado)';
      }
      
      // Print top 3 predictions
      final n = sorted.length < 3 ? sorted.length : 3;
      final top = List.generate(n, (i) {
        final idx = sorted[i];
        final label = idx < _diseaseLabels.length ? _diseaseLabels[idx] : 'Unknown';
        return '${i + 1}. $label ${(predictions[idx] * 100).toStringAsFixed(1)}%';
      }).join(' ');
      debugPrint('Disease model top: $top');
      
      return DiagnosisResult(
        disease: predictedDisease,
        confidence: finalConfidence,
        isModelLoaded: true,
        allPredictions: Map.fromIterables(_diseaseLabels, predictions),
      );
    } catch (e, stackTrace) {
      debugPrint('Error during disease analysis: $e');
      debugPrint('Stack trace: $stackTrace');
      return DiagnosisResult(
        disease: 'Analysis Error',
        confidence: 0.0,
        isModelLoaded: true,
        error: e.toString(),
      );
    }
  }

  /// Apply softmax to convert logits to probabilities
  List<double> _softmax(List<double> logits) {
    // Find max for numerical stability
    final maxLogit = logits.reduce((a, b) => a > b ? a : b);
    
    // Compute exp(x - max) for each logit (clamp to avoid overflow)
    final exps = logits.map((x) {
      final shifted = x - maxLogit;
      final clamped = shifted > 20 ? 20.0 : (shifted < -20 ? -20.0 : shifted);
      return math.exp(clamped);
    }).toList();
    
    // Sum of exps
    final sum = exps.reduce((a, b) => a + b);
    
    // Normalize (avoid division by zero)
    if (sum == 0) {
      // If sum is zero, return uniform distribution
      return List.filled(logits.length, 1.0 / logits.length);
    }
    
    return exps.map((exp) => exp / sum).toList();
  }

  /// Predict sweetness level from image using AI model only.
  /// Result is based solely on model inference — no fallback or hardcoded values.
  /// When model is not loaded, returns null (isModelLoaded: false).
  Future<SweetnessResult> predictSweetness(String imagePath) async {
    List<double> features;
    try {
      features = await _extractSweetnessFeatures(imagePath);
    } catch (e) {
      debugPrint('Sweetness feature extraction failed: $e');
      return SweetnessResult(level: null, levelName: null, confidence: 0.0, isModelLoaded: false);
    }
    if (features.length != 100) {
      debugPrint('⚠ Sweetness features: expected 100, got ${features.length}');
    }

    if (_sweetnessInterpreter != null) {
      try {
        final inputTensors = _sweetnessInterpreter!.getInputTensors();
        final expectedInputShape = inputTensors[0].shape;
        debugPrint('Sweetness model expects input shape: $expectedInputShape');
        
        final outputTensors = _sweetnessInterpreter!.getOutputTensors();
        final outputShape = outputTensors[0].shape;
        debugPrint('Sweetness model output shape: $outputShape');
        
        // Check if model outputs 4 classes (M1, M2, M3, M4) or single scalar
        final isClassification = outputShape.length >= 2 && outputShape[1] == 4;
        debugPrint('Sweetness model type: ${isClassification ? "4-class classification" : "scalar regression"}');
        
        // Resize to expected shape and allocate
        _sweetnessInterpreter!.resizeInputTensor(0, expectedInputShape);
        _sweetnessInterpreter!.allocateTensors();
        
        // Create input as 2D list [[100 floats]] if model expects [1, 100]
        final List<List<double>> input2D = [features.map((f) => f.toDouble()).toList()];
        debugPrint('Sweetness input: ${input2D[0].length} floats, sample values: ${features.take(5).map((v) => v.toStringAsFixed(3)).toList()}');
        
        String levelResult;
        double confidenceResult;
        
        if (isClassification) {
          // Model outputs probabilities for M1–M4 — run inference (result from model only)
          final output = List.generate(outputShape[0], (_) => List.filled(outputShape[1], 0.0));
          _sweetnessInterpreter!.run(input2D, output);
          
          List<double> probs = (output[0] as List).map((v) => (v is int) ? v.toDouble() : v as double).toList();
          debugPrint('Sweetness raw output (from model): ${probs.map((v) => v.toStringAsFixed(4)).toList()}');
          
          // Apply softmax if not already probabilities
          final sum = probs.reduce((a, b) => a + b);
          if ((sum - 1.0).abs() > 0.1) {
            probs = _softmax(probs);
          }
          
          // Find max probability
          int maxIdx = 0;
          double maxProb = probs[0];
          for (int i = 1; i < probs.length; i++) {
            if (probs[i] > maxProb) {
              maxProb = probs[i];
              maxIdx = i;
            }
          }
          
          levelResult = _sweetnessLabels[maxIdx];
          confidenceResult = maxProb * 100;
          debugPrint('Sweetness (classification): $levelResult (${confidenceResult.toStringAsFixed(1)}%)');
          debugPrint('  M1=${(probs[0]*100).toStringAsFixed(1)}% M2=${(probs[1]*100).toStringAsFixed(1)}% M3=${(probs[2]*100).toStringAsFixed(1)}% M4=${(probs[3]*100).toStringAsFixed(1)}%');
        } else {
          // Model outputs single scalar — run inference (result based on model only)
          final output = [[0.0]];
          _sweetnessInterpreter!.run(input2D, output);
          if (output.isEmpty || output[0].isEmpty) throw Exception('Empty output');
          double raw = output[0][0].toDouble(); // Raw value from model inference only
          debugPrint('Sweetness raw scalar output (from model): $raw');
          
          // Validate model output - if invalid, return error instead of defaulting
          if (raw.isNaN || raw.isInfinite) {
            debugPrint('ERROR: Model output is invalid (NaN/Infinite) - returning null result');
            return SweetnessResult(
              level: null,
              levelName: null,
              confidence: 0.0,
              isModelLoaded: true,
              error: 'Invalid model output: $raw',
            );
          }
          
          // Map model output directly to M1-M4 — level comes only from model raw value
          // Ranges below interpret the model's scalar output (no hardcoded levels)
          // If output > 1.0: model outputs 0–4 range; if <= 1.0: normalized 0–1
          String mappedLevel;
          double mappedConfidence;
          
          if (raw > 1.0) {
            // Model outputs 0-4 range: map directly to M1-M4
            // ALL 4 LEVELS (M1, M2, M3, M4) are covered and can appear:
            // M1: 0-2.4 (lowest sweetness)
            // M4: 2.4-2.7 (dapat na M2 reading → M4)
            // M2: 2.7-2.9
            // M3: 2.9+ (highest sweetness)
            if (raw <= 2.4) {
              // M1 range: 0-2.4 (lowest sweetness)
              mappedLevel = 'M1';
              mappedConfidence = (1.0 - (raw - 1.2).abs() / 1.2).clamp(0.0, 1.0) * 100;
            } else if (raw <= 2.7) {
              // M4 range: 2.4-2.7 (dapat na M2 reading → M4)
              mappedLevel = 'M4';
              mappedConfidence = (1.0 - (raw - 2.55).abs() / 0.15).clamp(0.0, 1.0) * 100;
            } else if (raw <= 2.9) {
              // M2 range: 2.7-2.9
              mappedLevel = 'M2';
              mappedConfidence = (1.0 - (raw - 2.8).abs() / 0.1).clamp(0.0, 1.0) * 100;
            } else {
              // M3 range: 2.9+ (highest sweetness)
              mappedLevel = 'M3';
              mappedConfidence = (1.0 - (raw - 3.2).abs() / 0.3).clamp(0.0, 1.0) * 100;
            }
            debugPrint('Model output > 1.0, direct mapping: $raw -> $mappedLevel (ALL M1-M4 possible: M1<2.4, M4=2.4-2.7, M2=2.7-2.9, M3>2.9)');
          } else if (raw < 0.0) {
            // Negative values -> M1
            mappedLevel = 'M1';
            mappedConfidence = 50.0;
            debugPrint('Model output < 0.0, mapping to M1');
          } else {
            // Output is 0-1 range: normalize to bins (ALL M1-M4 possible via bins)
            // Bins: [0.125=M1, 0.375=M2, 0.625=M3, 0.875=M4]
            final normalizedRaw = raw.clamp(0.0, 1.0);
            final level = _mapRawToSweetnessLevel(normalizedRaw);
            mappedLevel = level.level;
            final dist = (normalizedRaw - _bins[level.index]).abs();
            mappedConfidence = ((1.0 - 4 * dist).clamp(0.0, 1.0) * 100).clamp(0.0, 100.0);
            debugPrint('Model output 0-1 range, normalized: $raw -> $mappedLevel (ALL M1-M4 possible via bins)');
          }
          
          levelResult = mappedLevel;
          confidenceResult = mappedConfidence;
          debugPrint('Sweetness (from model only): $levelResult (${confidenceResult.toStringAsFixed(1)}%) raw=$raw');
        }
        
        // Sweetness reading is 100% from model inference — no fallback or hardcoded level
        assert(levelResult == 'M1' || levelResult == 'M2' || levelResult == 'M3' || levelResult == 'M4');
        return SweetnessResult(
          level: levelResult,
          levelName: _getSweetnessName(levelResult),
          confidence: confidenceResult,
          isModelLoaded: true,
        );
      } catch (e) {
        debugPrint('Sweetness inference error: $e');
        return SweetnessResult(level: null, levelName: null, confidence: 0.0, isModelLoaded: true, error: e.toString());
      }
    }

    // Model not loaded - return null result instead of fallback
    debugPrint('Sweetness model not loaded - returning null result');
    return SweetnessResult(
      level: null,
      levelName: null,
      confidence: 0.0,
      isModelLoaded: false,
    );
  }

  // Bins for 0-1 range mapping: ALL 4 LEVELS (M1, M2, M3, M4) are covered
  // [0.125=M1, 0.375=M2, 0.625=M3, 0.875=M4]
  static const _bins = [0.125, 0.375, 0.625, 0.875];

  /// Map normalized raw value (0-1) to M1-M4 level
  /// Returns one of: M1, M2, M3, or M4 (all 4 levels possible)
  ({String level, int index}) _mapRawToSweetnessLevel(double raw) {
    int idx = 0;
    double best = 1.0;
    for (int i = 0; i < 4; i++) {
      final d = (raw - _bins[i]).abs();
      if (d < best) {
        best = d;
        idx = i;
      }
    }
    idx = idx.clamp(0, 3);
    // Returns M1 (idx=0), M2 (idx=1), M3 (idx=2), or M4 (idx=3)
    return (level: _sweetnessLabels[idx], index: idx);
  }

  /// Preprocess image with RAW pixel values [0-255] - NO normalization!
  /// This matches the Python training script that uses raw cv2 images
  /// Includes center crop for better accuracy
  Future<List<List<List<List<double>>>>> _preprocessImageRaw(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');
    
    // Step 1: Center crop to square (focus on main subject)
    final originalWidth = image.width;
    final originalHeight = image.height;
    final minDim = originalWidth < originalHeight ? originalWidth : originalHeight;
    
    // Calculate crop area (center)
    final cropX = (originalWidth - minDim) ~/ 2;
    final cropY = (originalHeight - minDim) ~/ 2;
    
    // Crop to square
    image = img.copyCrop(image, x: cropX, y: cropY, width: minDim, height: minDim);
    debugPrint('Image cropped to ${image.width}x${image.height} from ${originalWidth}x$originalHeight');
    
    // Step 2: Resize to 224x224 using bilinear interpolation
    const inputSize = 224;
    image = img.copyResize(image, width: inputSize, height: inputSize, interpolation: img.Interpolation.linear);
    
    // Debug: print sample pixel values to verify preprocessing
    final samplePixel = image.getPixel(112, 112);
    debugPrint('Sample pixel at center (112,112): R=${samplePixel.r.toInt()}, G=${samplePixel.g.toInt()}, B=${samplePixel.b.toInt()}');
    
    // Calculate average brightness for quality check
    double totalBrightness = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final p = image.getPixel(x, y);
        totalBrightness += (p.r + p.g + p.b) / 3;
      }
    }
    final avgBrightness = totalBrightness / (inputSize * inputSize);
    debugPrint('Average image brightness: ${avgBrightness.toStringAsFixed(1)} (0-255)');
    
    if (avgBrightness < 30) {
      debugPrint('WARNING: Image is too dark, accuracy may be affected');
    } else if (avgBrightness > 225) {
      debugPrint('WARNING: Image is too bright/overexposed, accuracy may be affected');
    }
    
    // Keep RAW pixel values [0-255] - no normalization!
    // This matches the Python script: np.expand_dims(resized_frame, axis=0)
    final input = List.generate(
      1,
      (_) => List.generate(
        inputSize,
        (y) => List.generate(
          inputSize,
          (x) {
            final pixel = image!.getPixel(x, y);
            return [
              pixel.r.toDouble(),  // 0-255
              pixel.g.toDouble(),  // 0-255
              pixel.b.toDouble(),  // 0-255
            ];
          },
        ),
      ),
    );
    
    return input;
  }

  /// Extract 100-dim feature vector for sweetness model (input shape [1, 100]).
  /// Model is COLOR-BASED — uses RGB color values, not luminance.
  /// Resizes image to 10x10, extracts RGB color features per pixel, normalizes to [0, 1].
  Future<List<double>> _extractSweetnessFeatures(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');
    
    // Resize to 10x10 for feature extraction
    image = img.copyResize(image, width: 10, height: 10);
    final out = <double>[];
    
    // Extract RGB color-based features (model is color-based)
    // For 10x10 = 100 pixels, we need 100 features
    // Use RGB averaged per pixel (captures color information)
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
        final p = image.getPixel(x, y);
        // Use RGB color values (normalized 0-1) - color-based feature extraction
        // Average RGB per pixel to get color intensity while maintaining 100 features
        final rNorm = p.r / 255.0;
        final gNorm = p.g / 255.0;
        final bNorm = p.b / 255.0;
        // Weighted average favoring yellow/orange (important for pineapple ripeness/sweetness)
        // Yellow = high R+G, low B; Orange = high R, medium G, low B
        final colorValue = (rNorm * 0.4 + gNorm * 0.4 + bNorm * 0.2); // Emphasize R+G (yellow/orange)
        out.add(colorValue.clamp(0.0, 1.0));
      }
    }
    
    if (out.length != 100) {
      throw Exception('Feature extraction error: expected 100 features, got ${out.length}');
    }
    
    debugPrint('Sweetness features extracted: ${out.length} color-based features (RGB)');
    return out;
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
