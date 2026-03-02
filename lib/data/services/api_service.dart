import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/nutrition_data.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio();
  final String _n8nWebhookUrl = 'https://primary-production-9b20.up.railway.app/webhook-test/upload-meal';

  Future<NutritionData> analyzeImage(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      // Simulating API response for now if URL is placeholder
      if (_n8nWebhookUrl.contains('your-n8n-instance')) {
         await Future.delayed(const Duration(seconds: 3)); // Mock delay
         return NutritionData(
           mealName: "Grilled Chicken Salad",
           calories: 320,
           protein: 25,
         );
      }

      final response = await _dio.post(_n8nWebhookUrl, data: formData);

      if (response.statusCode == 200) {
        return NutritionData.fromJson(response.data);
      } else {
        throw Exception('Failed to analyze the image');
      }
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }
}
