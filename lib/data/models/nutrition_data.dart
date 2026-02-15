class NutritionData {
  final String mealName;
  final double calories;
  final double protein;
  final String? imagePath;

  NutritionData({
    required this.mealName,
    required this.calories,
    required this.protein,
    this.imagePath,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      mealName: json['meal_name'] as String,
      calories: double.tryParse(json['calories'].toString()) ?? 0.0,
      protein: double.tryParse(json['protein'].toString().replaceAll('g', '')) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal_name': mealName,
      'calories': calories,
      'protein': protein,
      'image_path': imagePath,
    };
  }
}
