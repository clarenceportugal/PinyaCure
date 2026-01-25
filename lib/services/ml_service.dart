import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
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
      print('ML Service initialized successfully');
    } catch (e) {
      print('Error initializing ML Service: $e');
      _isInitialized = false;
    }
  }

  Future<void> _loadDiseaseModel() async {
    try {
      print('Attempting to load disease model...');
      
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
          print('Checking if asset exists: $path');
          // Try to load as bytes to verify it exists
          final bytes = await rootBundle.load(path);
          print('✓ Asset found at: $path (size: ${bytes.lengthInBytes} bytes)');
          workingPath = path;
          break;
        } catch (e) {
          print('✗ Asset not found at: $path - $e');
        }
      }
      
      if (workingPath == null) {
        throw Exception('Model file not found in any of the tried paths: $pathsToTry');
      }
      
      // Now load the model using the working path
      print('Loading model from: $workingPath');
      _diseaseInterpreter = await Interpreter.fromAsset(workingPath);
      
      if (_diseaseInterpreter == null) {
        throw Exception('Interpreter is null after loading');
      }
      
      print('✓ Disease model file loaded successfully');
      
      // Load labels
      _diseaseLabels = await _loadLabels('assets/models/labels.txt');
      
      // Validate labels
      if (_diseaseLabels.isEmpty) {
        print('Warning: labels.txt is empty, using default labels');
        _diseaseLabels = [
          'Healthy',
          'Phytophthora Heart Rot',
          'Bacterial Heart Rot',
          'Mealybug Wilt',
          'Fusarium Wilt',
        ];
      }
      
      print('✓ Disease model loaded: ${_diseaseLabels.length} classes');
      
      // Validate model input/output shapes
      final inputTensors = _diseaseInterpreter!.getInputTensors();
      final outputTensors = _diseaseInterpreter!.getOutputTensors();
      print('  Input shape: ${inputTensors[0].shape}, Output shape: ${outputTensors[0].shape}');
      
      // Verify labels match output size
      if (outputTensors[0].shape.isNotEmpty) {
        final expectedOutputSize = outputTensors[0].shape.reduce((a, b) => a * b);
        if (_diseaseLabels.length != expectedOutputSize) {
          print('⚠ Warning: Labels count (${_diseaseLabels.length}) != model output size ($expectedOutputSize)');
        }
      }
      
    } catch (e, stackTrace) {
      print('✗ Disease model not found or error loading: $e');
      print('Stack trace: $stackTrace');
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
      print('Attempting to load sweetness model...');
      final byteData = await rootBundle.load(path);
      final bytes = byteData.buffer.asUint8List();
      print('✓ Sweetness asset found: $path (${bytes.length} bytes)');
      try {
        _sweetnessInterpreter = await Interpreter.fromAsset(path);
      } catch (e) {
        print('  fromAsset failed, trying fromBuffer: $e');
        _sweetnessInterpreter = await Interpreter.fromBuffer(bytes);
      }
      print('✓ Sweetness model loaded (input 100-dim, output scalar)');
    } catch (e, st) {
      print('✗ Sweetness model error: $e');
      print('  $st');
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
      print('Disease model expects input shape: $expectedInputShape');
      
      final outputTensors = _diseaseInterpreter!.getOutputTensors();
      final outputShape = outputTensors[0].shape;
      print('Disease model output shape: $outputShape');
      print('Labels count: ${_diseaseLabels.length}');
      print('Labels: $_diseaseLabels');
      
      // Check if labels count matches model output
      if (outputShape.length >= 2 && outputShape[1] != _diseaseLabels.length) {
        print('WARNING: Model outputs ${outputShape[1]} classes but labels has ${_diseaseLabels.length}');
      }
      
      // IMPORTANT: Model expects RAW pixel values [0-255], NOT normalized!
      // Based on the Python training script that uses: np.expand_dims(resized_frame, axis=0)
      final imageData = await _preprocessImageRaw(imagePath);
      print('Preprocessed input (raw 0-255): [1][224][224][3]');
      
      // Run inference multiple times and average for stability
      const numRuns = 3;
      List<List<double>> allPredictions = [];
      
      for (int run = 0; run < numRuns; run++) {
        final output = List.generate(outputShape[0], (_) => List.filled(outputShape[1], 0.0));
        _diseaseInterpreter!.run(imageData, output);
        
        // Flatten output [1][N] -> [N]
        List<double> rawPredictions = (output[0] as List).map((v) => (v is int) ? v.toDouble() : v as double).toList();
        allPredictions.add(rawPredictions);
      }
      
      // Average predictions across runs
      List<double> rawPredictions = List.filled(allPredictions[0].length, 0.0);
      for (int i = 0; i < rawPredictions.length; i++) {
        double sum = 0;
        for (int run = 0; run < numRuns; run++) {
          sum += allPredictions[run][i];
        }
        rawPredictions[i] = sum / numRuns;
      }
      
      // Debug: print averaged raw predictions
      print('Averaged raw predictions ($numRuns runs): ${rawPredictions.map((v) => v.toStringAsFixed(4)).toList()}');
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
      
      print('=== PREDICTION ANALYSIS ===');
      print('Top 1: ${sorted[0] < _diseaseLabels.length ? _diseaseLabels[sorted[0]] : "Unknown"} = ${top1Conf.toStringAsFixed(1)}%');
      print('Top 2: ${sorted.length > 1 && sorted[1] < _diseaseLabels.length ? _diseaseLabels[sorted[1]] : "Unknown"} = ${top2Conf.toStringAsFixed(1)}%');
      print('Confidence gap: ${confidenceGap.toStringAsFixed(1)}%');
      
      if (maxIndex >= _diseaseLabels.length) {
        print('Warning: Prediction index $maxIndex exceeds labels length ${_diseaseLabels.length}');
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
        print('Low confidence prediction: ${confidence.toStringAsFixed(1)}%');
        predictedDisease = '$predictedDisease (Hindi Sigurado)';
      }
      
      // Print top 3 predictions
      final n = sorted.length < 3 ? sorted.length : 3;
      final top = List.generate(n, (i) {
        final idx = sorted[i];
        final label = idx < _diseaseLabels.length ? _diseaseLabels[idx] : 'Unknown';
        return '${i + 1}. $label ${(predictions[idx] * 100).toStringAsFixed(1)}%';
      }).join(' ');
      print('Disease model top: $top');
      
      return DiagnosisResult(
        disease: predictedDisease,
        confidence: finalConfidence,
        isModelLoaded: true,
        allPredictions: Map.fromIterables(_diseaseLabels, predictions),
      );
    } catch (e, stackTrace) {
      print('Error during disease analysis: $e');
      print('Stack trace: $stackTrace');
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

  /// Calculate variance of predictions - higher variance = more confident model
  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;
    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => (v - mean) * (v - mean));
    return squaredDiffs.reduce((a, b) => a + b) / values.length;
  }

  /// Predict sweetness level from image using AI model only.
  /// Fallback (luminance heuristic) only when model not loaded.
  Future<SweetnessResult> predictSweetness(String imagePath) async {
    List<double> features;
    try {
      features = await _extractSweetnessFeatures(imagePath);
    } catch (e) {
      print('Sweetness feature extraction failed: $e');
      return SweetnessResult(level: null, levelName: null, confidence: 0.0, isModelLoaded: false);
    }
    if (features.length != 100) {
      print('⚠ Sweetness features: expected 100, got ${features.length}');
    }

    if (_sweetnessInterpreter != null) {
      try {
        final inputTensors = _sweetnessInterpreter!.getInputTensors();
        final expectedInputShape = inputTensors[0].shape;
        print('Sweetness model expects input shape: $expectedInputShape');
        
        final outputTensors = _sweetnessInterpreter!.getOutputTensors();
        final outputShape = outputTensors[0].shape;
        print('Sweetness model output shape: $outputShape');
        
        // Check if model outputs 4 classes (M1, M2, M3, M4) or single scalar
        final isClassification = outputShape.length >= 2 && outputShape[1] == 4;
        print('Sweetness model type: ${isClassification ? "4-class classification" : "scalar regression"}');
        
        // Resize to expected shape and allocate
        _sweetnessInterpreter!.resizeInputTensor(0, expectedInputShape);
        _sweetnessInterpreter!.allocateTensors();
        
        // Create input as 2D list [[100 floats]] if model expects [1, 100]
        final List<List<double>> input2D = [features.map((f) => f.toDouble()).toList()];
        print('Sweetness input: ${input2D[0].length} floats, sample values: ${features.take(5).map((v) => v.toStringAsFixed(3)).toList()}');
        
        String levelResult;
        double confidenceResult;
        
        if (isClassification) {
          // Model outputs probabilities for M1, M2, M3, M4
          final output = List.generate(outputShape[0], (_) => List.filled(outputShape[1], 0.0));
          _sweetnessInterpreter!.run(input2D, output);
          
          List<double> probs = (output[0] as List).map((v) => (v is int) ? v.toDouble() : v as double).toList();
          print('Sweetness raw output: ${probs.map((v) => v.toStringAsFixed(4)).toList()}');
          
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
          print('Sweetness (classification): $levelResult (${confidenceResult.toStringAsFixed(1)}%)');
          print('  M1=${(probs[0]*100).toStringAsFixed(1)}% M2=${(probs[1]*100).toStringAsFixed(1)}% M3=${(probs[2]*100).toStringAsFixed(1)}% M4=${(probs[3]*100).toStringAsFixed(1)}%');
        } else {
          // Model outputs single scalar value 0-1
          final output = [[0.0]];
          _sweetnessInterpreter!.run(input2D, output);
          if (output.isEmpty || output[0].isEmpty) throw Exception('Empty output');
          double raw = output[0][0].toDouble();
          print('Sweetness raw scalar output: $raw');
          
          if (raw.isNaN || raw.isInfinite) raw = 0.5;
          raw = raw.clamp(0.0, 1.0);
          final level = _mapRawToSweetnessLevel(raw);
          final dist = (raw - _bins[level.index]).abs();
          confidenceResult = ((1.0 - 4 * dist).clamp(0.0, 1.0) * 100).clamp(0.0, 100.0);
          levelResult = level.level;
          print('Sweetness (regression): $levelResult (${confidenceResult.toStringAsFixed(1)}%) raw=$raw');
        }
        
        return SweetnessResult(
          level: levelResult,
          levelName: _getSweetnessName(levelResult),
          confidence: confidenceResult,
          isModelLoaded: true,
        );
      } catch (e) {
        print('Sweetness inference error: $e');
        return SweetnessResult(level: null, levelName: null, confidence: 0.0, isModelLoaded: true, error: e.toString());
      }
    }

    final mean = features.isEmpty ? 0.5 : features.reduce((a, b) => a + b) / features.length;
    final raw = mean.clamp(0.0, 1.0);
    final res = _fallbackSweetness(raw);
    print('Sweetness (fallback, no model): ${res.level}');
    return res;
  }

  SweetnessResult _fallbackSweetness(double raw) {
    final level = _mapRawToSweetnessLevel(raw.clamp(0.0, 1.0));
    return SweetnessResult(
      level: level.level,
      levelName: _getSweetnessName(level.level),
      confidence: 50.0,
      isModelLoaded: false,
    );
  }

  static const _bins = [0.125, 0.375, 0.625, 0.875];

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
    return (level: _sweetnessLabels[idx], index: idx);
  }

  /// Preprocess image to flat Float32List buffer [224*224*3]
  Future<Float32List> _preprocessToFloat32Buffer(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');
    const size = 224;
    image = img.copyResize(image, width: size, height: size);
    final out = Float32List(size * size * 3);
    int i = 0;
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final p = image.getPixel(x, y);
        out[i++] = p.r / 255.0;
        out[i++] = p.g / 255.0;
        out[i++] = p.b / 255.0;
      }
    }
    return out;
  }

  /// Reshape flat list to 4D nested structure [batch][height][width][channels]
  List<List<List<List<double>>>> _reshapeTo4D(List<double> flat, int b, int h, int w, int c) {
    return List.generate(b, (bi) =>
      List.generate(h, (hi) =>
        List.generate(w, (wi) =>
          List.generate(c, (ci) {
            final idx = bi * h * w * c + hi * w * c + wi * c + ci;
            return flat[idx];
          })
        )
      )
    );
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
    print('Image cropped to ${image.width}x${image.height} from ${originalWidth}x$originalHeight');
    
    // Step 2: Resize to 224x224 using bilinear interpolation
    const inputSize = 224;
    image = img.copyResize(image, width: inputSize, height: inputSize, interpolation: img.Interpolation.linear);
    
    // Debug: print sample pixel values to verify preprocessing
    final samplePixel = image.getPixel(112, 112);
    print('Sample pixel at center (112,112): R=${samplePixel.r.toInt()}, G=${samplePixel.g.toInt()}, B=${samplePixel.b.toInt()}');
    
    // Calculate average brightness for quality check
    double totalBrightness = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final p = image.getPixel(x, y);
        totalBrightness += (p.r + p.g + p.b) / 3;
      }
    }
    final avgBrightness = totalBrightness / (inputSize * inputSize);
    print('Average image brightness: ${avgBrightness.toStringAsFixed(1)} (0-255)');
    
    if (avgBrightness < 30) {
      print('WARNING: Image is too dark, accuracy may be affected');
    } else if (avgBrightness > 225) {
      print('WARNING: Image is too bright/overexposed, accuracy may be affected');
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

  /// Preprocess image for model input
  /// Tries ImageNet normalization first (standard for most pre-trained models)
  /// If that doesn't work well, can fall back to simple [0,1] normalization
  Future<List<List<List<List<double>>>>> _preprocessImage(String imagePath, {bool useImageNetNormalization = true}) async {
    // Read image file
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    
    // Decode image
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');
    
    // Resize to model input size (typically 224x224)
    const inputSize = 224;
    image = img.copyResize(image, width: inputSize, height: inputSize);
    
    if (useImageNetNormalization) {
      // ImageNet normalization constants (for pre-trained models like ResNet, EfficientNet, etc.)
      // Mean: [0.485, 0.456, 0.406]
      // Std: [0.229, 0.224, 0.225]
      const mean = [0.485, 0.456, 0.406];
      const std = [0.229, 0.224, 0.225];
      
      // Convert to normalized float array with ImageNet normalization
      final input = List.generate(
        1,
        (_) => List.generate(
          inputSize,
          (y) => List.generate(
            inputSize,
            (x) {
              final pixel = image!.getPixel(x, y);
              // Normalize: (pixel / 255.0 - mean) / std
              return [
                ((pixel.r / 255.0) - mean[0]) / std[0],
                ((pixel.g / 255.0) - mean[1]) / std[1],
                ((pixel.b / 255.0) - mean[2]) / std[2],
              ];
            },
          ),
        ),
      );
      
      return input;
    } else {
      // Simple [0, 1] normalization (for custom models)
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
  }

  /// Extract 100-dim feature vector for sweetness model (input shape [1, 100]).
  /// Resizes image to 10x10, uses luminance per pixel, normalizes to [0, 1].
  Future<List<double>> _extractSweetnessFeatures(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');
    image = img.copyResize(image, width: 10, height: 10);
    final out = <double>[];
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
        final p = image.getPixel(x, y);
        final lum = (0.299 * p.r + 0.587 * p.g + 0.114 * p.b) / 255.0;
        out.add(lum.clamp(0.0, 1.0));
      }
    }
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
