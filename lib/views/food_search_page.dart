import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/food_controller.dart';
import '../models/food.dart';

class FoodSearchPage extends StatelessWidget {
  FoodSearchPage({super.key});

  final _searchController = TextEditingController();

  static const _green = Color(0xFF4CAF50);
  static const _orange = Color(0xFFFF7043);
  static const _bg = Color(0xFFFAFAFA);
  static const _textPrimary = Color(0xFF212121);
  static const _textSecondary = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FoodController>();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Cari Makanan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 15, color: _textPrimary),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (val) => controller.search(val),
                      decoration: InputDecoration(
                        hintText: 'Cari nama makanan...',
                        hintStyle: const TextStyle(
                          color: _textSecondary,
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: _textSecondary,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: _green,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isLoading.value
                          ? null
                          : () => controller.search(_searchController.text),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _orange,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: controller.isLoading.value
                            ? const Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Results
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.foodResults.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: _green),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.foodResults.isEmpty) {
                  final recentFoods = [
                    'Rice',
                    'Egg',
                    'Chicken Breast',
                    'Banana',
                    'Apple',
                  ];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Makanan Populer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: recentFoods.map((food) {
                            return ActionChip(
                              label: Text(food),
                              onPressed: () {
                                _searchController.text = food;
                                controller.search(food);
                              },
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 40),

                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Cari makanan untuk melihat informasi nutrisi',
                                style: TextStyle(color: _textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  itemCount: controller.foodResults.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final food = controller.foodResults[index];
                    return _buildFoodItem(food, controller);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(Food food, FoodController controller) {
    final dataTypeColor = _getDataTypeColor(food.dataType);

    return GestureDetector(
      onTap: () => controller.onFoodTapped(food),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: _green,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: dataTypeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          food.dataType,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: dataTypeColor,
                          ),
                        ),
                      ),
                      if (food.caloriesPer100g != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${food.caloriesPer100g!.toStringAsFixed(0)} kcal/100g',
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: _textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color _getDataTypeColor(String dataType) {
    switch (dataType.toLowerCase()) {
      case 'foundation':
        return _green;
      case 'sr legacy':
        return const Color(0xFF42A5F5);
      case 'branded':
        return _orange;
      default:
        return const Color(0xFF9C27B0);
    }
  }
}
