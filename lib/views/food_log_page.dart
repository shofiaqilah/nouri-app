import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/food_log_controller.dart';
import '../models/food_log.dart';

class FoodLogPage extends StatelessWidget {

  final DateTime? readOnlyDate;

  const FoodLogPage({super.key, this.readOnlyDate});

  bool get isReadOnly => readOnlyDate != null;

  static const _green = Color(0xFF4CAF50);
  static const _orange = Color(0xFFFF7043);
  static const _bg = Color(0xFFFAFAFA);
  static const _textPrimary = Color(0xFF212121);
  static const _textSecondary = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    final logController = Get.find<FoodLogController>();

    final String title = isReadOnly
        ? _formatDate(readOnlyDate!)
        : 'Food Log Hari Ini';

    if (isReadOnly) {
      return FutureBuilder<List<FoodLog>>(
        future: logController.getLogsForDate(readOnlyDate!),
        builder: (context, snapshot) {
          return _buildPage(
            logController,
            snapshot.data ?? const <FoodLog>[],
            title,
          );
        },
      );
    }

    return Obx(() {
      return _buildPage(
        logController,
        logController.todayLogs.toList(),
        title,
      );
    });
  }

  Widget _buildPage(
    FoodLogController logController,
    List<FoodLog> logs,
    String title,
  ) {
    final double totalCalories =
        logs.fold(0.0, (sum, log) => sum + log.calories);

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: _green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Kalori',
                          style: TextStyle(fontSize: 12, color: _textPrimary, fontWeight: FontWeight(500)),
                        ),
                        Text(
                          '${totalCalories.toStringAsFixed(0)} kcal',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: _green,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Makanan',
                          style: TextStyle(fontSize: 12, color: _textPrimary, fontWeight: FontWeight(500)),
                        ),
                        Text(
                          '${logs.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: _green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // List
            Expanded(
              child: logs.isEmpty
                  ? _buildEmptyState()
                  : _buildList(
                      logs,
                      logController: isReadOnly ? null : logController,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: isReadOnly
          ? null
          : FloatingActionButton.extended(
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

  Widget _buildObxList(FoodLogController logController) {
    return Obx(() {
      final logs = logController.todayLogs;
      if (logs.isEmpty) return _buildEmptyState();
      return _buildList(logs, logController: logController);
    });
  }

  Widget _buildStaticList(List<FoodLog> logs) {
    if (logs.isEmpty) return _buildEmptyState();
    return _buildList(logs);
  }

  Widget _buildList(List<FoodLog> logs, {FoodLogController? logController}) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildLogItem(log, logController);
      },
    );
  }

  Widget _buildLogItem(FoodLog log, FoodLogController? logController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.foodName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    Text(
                      '${log.grams.toStringAsFixed(0)}g',
                      style: const TextStyle(fontSize: 12, color: _textSecondary),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '·',
                      style: TextStyle(color: _textSecondary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'P: ${log.protein.toStringAsFixed(1)}g  K: ${log.carbs.toStringAsFixed(1)}g  L: ${log.fat.toStringAsFixed(1)}g',
                      style: const TextStyle(fontSize: 11, color: _textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${log.calories.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _orange,
                ),
              ),
              const Text(
                'kcal',
                style: TextStyle(fontSize: 10, color: _textSecondary),
              ),
            ],
          ),
          if (!isReadOnly && logController != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _confirmDelete(log, logController),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmDelete(FoodLog log, FoodLogController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus entri?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
        content: Text(
          'Hapus "${log.foodName}" dari log hari ini?',
          style: const TextStyle(fontSize: 14, color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(color: _textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteFoodLog(log);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.no_meals_rounded, size: 64, color: Colors.grey[200]),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada makanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Belum ada makanan yang ditambahkan',
            style: TextStyle(fontSize: 13, color: _textSecondary),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
