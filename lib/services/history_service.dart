import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static HistoryService? _instance;
  static const String _historyKey = 'scan_history';

  // Singleton pattern
  static HistoryService get instance {
    _instance ??= HistoryService._();
    return _instance!;
  }

  HistoryService._();

  /// Save a scan result to history
  Future<void> saveScan(ScanHistoryItem item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getHistory();
      
      // Add new item at the beginning
      history.insert(0, item);
      
      // Limit to last 100 scans
      if (history.length > 100) {
        history.removeRange(100, history.length);
      }
      
      // Save to SharedPreferences
      final jsonList = history.map((item) => item.toJson()).toList();
      await prefs.setString(_historyKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving scan history: $e');
    }
  }

  /// Get all scan history
  Future<List<ScanHistoryItem>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_historyKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => ScanHistoryItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading scan history: $e');
      return [];
    }
  }

  /// Delete a specific scan from history
  Future<void> deleteScan(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getHistory();
      history.removeWhere((item) => item.id == id);
      
      final jsonList = history.map((item) => item.toJson()).toList();
      await prefs.setString(_historyKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error deleting scan history: $e');
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      debugPrint('Error clearing scan history: $e');
    }
  }
}

/// Model class for scan history items
class ScanHistoryItem {
  final String id;
  final String disease;
  final double confidence;
  final String? sweetnessLevel;
  final String? sweetnessName;
  final String? imagePath;
  final DateTime timestamp;

  ScanHistoryItem({
    required this.id,
    required this.disease,
    required this.confidence,
    this.sweetnessLevel,
    this.sweetnessName,
    this.imagePath,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disease': disease,
      'confidence': confidence,
      'sweetnessLevel': sweetnessLevel,
      'sweetnessName': sweetnessName,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScanHistoryItem(
      id: json['id'] as String,
      disease: json['disease'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      sweetnessLevel: json['sweetnessLevel'] as String?,
      sweetnessName: json['sweetnessName'] as String?,
      imagePath: json['imagePath'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
