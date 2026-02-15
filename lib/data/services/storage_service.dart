import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

class StorageService {
  static const String _historyKey = 'nutrition_history';

  Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_historyKey);
    if (historyJson == null) return [];

    final List<dynamic> decoded = jsonDecode(historyJson);
    return decoded.map((e) => HistoryItem.fromJson(e)).toList();
  }

  Future<void> saveHistoryItem(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final List<HistoryItem> currentHistory = await getHistory();
    currentHistory.insert(0, item); // Add new item to the top

    final String encoded = jsonEncode(currentHistory.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  Future<void> deleteHistoryItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<HistoryItem> currentHistory = await getHistory();
    currentHistory.removeWhere((item) => item.id == id);

    final String encoded = jsonEncode(currentHistory.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }
    
  Future<void> updateHistoryItem(HistoryItem updatedItem) async {
    final prefs = await SharedPreferences.getInstance();
    List<HistoryItem> currentHistory = await getHistory();
    final index = currentHistory.indexWhere((item) => item.id == updatedItem.id);
    
    if (index != -1) {
      currentHistory[index] = updatedItem;
      final String encoded = jsonEncode(currentHistory.map((e) => e.toJson()).toList());
      await prefs.setString(_historyKey, encoded);
    }
  }
}
