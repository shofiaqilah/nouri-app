import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/food_log_controller.dart';
import 'food_log_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static const _green = Color(0xFF4CAF50);
  static const _bg = Color(0xFFFAFAFA);
  static const _textPrimary = Color(0xFF212121);
  static const _textSecondary = Color(0xFF757575);
  static const _orange = Color(0xFFFF7043);

  @override
  Widget build(BuildContext context) {
    final logController = Get.find<FoodLogController>();
    final dates = logController.logDates;

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
                    'Riwayat',
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

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '${dates.length} hari dengan catatan',
                style: const TextStyle(fontSize: 13, color: _textSecondary),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: dates.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: dates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        final logs = logController.getLogsForDate(date);
                        final totalCal =
                            logs.fold(0.0, (sum, l) => sum + l.calories);

                        return _buildDateCard(date, logs.length, totalCal);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(DateTime date, int entryCount, double totalCal) {
    final isToday = _isToday(date);
    final isYesterday = _isYesterday(date);

    String dateLabel;
    if (isToday) {
      dateLabel = 'Hari Ini';
    } else if (isYesterday) {
      dateLabel = 'Kemarin';
    } else {
      dateLabel = _formatDate(date);
    }

    return GestureDetector(
      onTap: () => Get.to(
        () => FoodLogPage(readOnlyDate: date),
        transition: Transition.rightToLeft,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isToday ? _green.withOpacity(0.3) : const Color(0xFFEEEEEE),
          ),
        ),
        child: Row(
          children: [
            // Date badge
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isToday ? _green.withOpacity(0.1) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isToday ? _green : _textPrimary,
                      height: 1,
                    ),
                  ),
                  Text(
                    _monthAbbr(date.month),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isToday ? _green : _textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        dateLabel,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                      if (isToday) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Aktif',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _green,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$entryCount makanan dicatat',
                    style: const TextStyle(
                      fontSize: 12,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${totalCal.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _orange,
                  ),
                ),
                const Text(
                  'kcal',
                  style: TextStyle(fontSize: 11, color: _textSecondary),
                ),
              ],
            ),

            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: _textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_rounded, size: 64, color: Colors.grey[200]),
          const SizedBox(height: 16),
          const Text(
            'Belum ada riwayat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Mulai tambahkan makanan untuk melihat riwayat',
            style: TextStyle(fontSize: 13, color: _textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  String _formatDate(DateTime date) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return months[month - 1];
  }
}
