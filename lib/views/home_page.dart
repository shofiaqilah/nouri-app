import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/food_log_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/food_log.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _green = Colors.green;
  static const _orange = Colors.deepOrangeAccent;
  static const _bg = Colors.white;
  static const _textPrimary = Colors.black;
  static const _textSecondary = Colors.grey;
  static const _cardBg = Colors.white;

  @override
  Widget build(BuildContext context) {
    final logController = Get.find<FoodLogController>();
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: _green,
          onRefresh: () async {
            await logController.loadToday();
            await profileController.loadProfile();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Obx(() {
                  final name = profileController.user.value?.name ?? '';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, ${name.isNotEmpty ? name.split(' ').first : 'Kamu'} 👋',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _textPrimary,
                            ),
                          ),
                          const Text(
                            'Pantau asupanmu hari ini',
                            style: TextStyle(
                              fontSize: 13,
                              color: _textSecondary,
                            ),
                          ),
                        ],
                      ),
                      // Logo
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.eco_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 28),

                // Calorie card
                Obx(() {
                  final total = logController.totalCaloriesToday.value;
                  final target = logController.calorieTarget.value;
                  final progress = logController.calorieProgress;
                  final remaining = (target - total).clamp(0, double.infinity);

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kalori Hari Ini',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              total.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                '/ ${target.toStringAsFixed(0)} kcal',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (progress >= 1.0)
                              const Text(
                                'Target kalori terlampaui!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            else
                              Text(
                                'Sisa ${remaining.toStringAsFixed(0)} kcal',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 28),

                // Quick actions
                Row(
                  children: [
                    _buildActionCard(
                      icon: Icons.search_rounded,
                      label: 'Cari\nMakanan',
                      color: _orange,
                      onTap: () => Get.toNamed('/search'),
                    ),
                    const SizedBox(width: 12),
                    _buildActionCard(
                      icon: Icons.receipt_long_rounded,
                      label: 'Food\nLog',
                      color: const Color(0xFF42A5F5),
                      onTap: () => Get.toNamed('/today-log'),
                    ),
                    const SizedBox(width: 12),
                    _buildActionCard(
                      icon: Icons.history_rounded,
                      label: 'Riwayat',
                      color: const Color(0xFF9C27B0),
                      onTap: () => Get.toNamed('/history'),
                    ),
                    const SizedBox(width: 12),
                    _buildActionCard(
                      icon: Icons.person_rounded,
                      label: 'Profil',
                      color: const Color(0xFF26A69A),
                      onTap: () => Get.toNamed('/profile'),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Today's food preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Makanan Hari Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed('/today-log'),
                      child: const Text(
                        'Lihat semua',
                        style: TextStyle(
                          fontSize: 13,
                          color: _textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Obx(() {
                  final logs = logController
                      .todayLogs; // ambil data log makanan hari ini
                  if (logs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 40,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Belum ada makanan hari ini',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            // dia menuju ke search page
                            onTap: () => Get.toNamed('/search'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Tambah makanan',
                                style: TextStyle(
                                  color: _orange,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // menampilkan 3 data makanan terakhir
                  final preview = logs.length > 3
                      ? logs.sublist(logs.length - 3).reversed.toList()
                      : logs.reversed.toList();

                  return Column(
                    children: preview
                        .map((log) => _buildFoodPreviewItem(log))
                        .toList(),
                  );
                }),

                const SizedBox(height: 24),

                // menampilkan data makro
                Obx(() {
                  final logs = logController.todayLogs;
                  if (logs.isEmpty) return const SizedBox.shrink();

                  final totalProtein = logs.fold(
                    0.0,
                    (sum, l) => sum + l.protein,
                  );
                  final totalCarbs = logs.fold(0.0, (sum, l) => sum + l.carbs);
                  final totalFat = logs.fold(0.0, (sum, l) => sum + l.fat);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ringkasan Makro',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroItem(
                              'Protein',
                              totalProtein,
                              const Color(0xFF42A5F5),
                            ),
                            _buildMacroItem('Karbohidrat', totalCarbs, _orange),
                            _buildMacroItem(
                              'Lemak',
                              totalFat,
                              const Color(0xFFFFCA28),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/search'),
        backgroundColor: _orange,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodPreviewItem(FoodLog log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.foodName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${log.grams.toStringAsFixed(0)}g',
                  style: const TextStyle(fontSize: 12, color: _textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '${log.calories.toStringAsFixed(0)} kcal',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          '${value.toStringAsFixed(1)}g',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: _textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
