import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/models/history_item.dart';
import '../../data/models/nutrition_data.dart';
import '../../data/services/storage_service.dart';

final historyProvider = FutureProvider<List<HistoryItem>>((ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getHistory();
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.transparent,
      ),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return const Center(
              child: Text("No history yet. Please Scan a meal!"),
            );
          }
          return AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Dismissible(
                          key: Key(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                             ref.read(storageServiceProvider).deleteHistoryItem(item.id);
                             ref.refresh(historyProvider);
                          },
                          child: GlassCard(
                            onTap: () => _showEditDialog(context, ref, item),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: item.nutritionData.imagePath != null
                                        ? DecorationImage(
                                            image: NetworkImage(item.nutritionData.imagePath!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    color: Colors.grey[800],
                                  ),
                                  child: item.nutritionData.imagePath == null
                                      ? const Icon(Icons.fastfood, color: Colors.white54)
                                      : null,
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nutritionData.mealName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${item.nutritionData.calories.toInt()} kcal • ${item.nutritionData.protein.toInt()}g Protein",
                                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                                      ),
                                      Text(
                                        DateFormat.yMMMd().add_jm().format(item.timestamp),
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, HistoryItem item) {
    final nameController = TextEditingController(text: item.nutritionData.mealName);
    final calsController = TextEditingController(text: item.nutritionData.calories.toString());
    final proteinController = TextEditingController(text: item.nutritionData.protein.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Edit Data"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Meal Name"),
            ),
            TextField(
              controller: calsController,
              decoration: const InputDecoration(labelText: "Calories"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: proteinController,
              decoration: const InputDecoration(labelText: "Protein (g)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedData = NutritionData(
                mealName: nameController.text,
                calories: double.tryParse(calsController.text) ?? 0,
                protein: double.tryParse(proteinController.text) ?? 0,
                imagePath: item.nutritionData.imagePath,
              );
              
              final updatedItem = HistoryItem(
                id: item.id,
                nutritionData: updatedData,
                timestamp: item.timestamp,
              );

              await ref.read(storageServiceProvider).updateHistoryItem(updatedItem);
              ref.refresh(historyProvider);
              
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
