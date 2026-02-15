import 'package:uuid/uuid.dart';

import 'nutrition_data.dart';

class HistoryItem {
  final String id;
  final NutritionData nutritionData;
  final DateTime timestamp;

  HistoryItem({
    String? id,
    required this.nutritionData,
    required this.timestamp,
  }) : id = id ?? const Uuid().v4();

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      nutritionData: NutritionData.fromJson(json['nutrition_data']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nutrition_data': nutritionData.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
