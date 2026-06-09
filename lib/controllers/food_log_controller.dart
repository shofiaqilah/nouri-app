import 'package:get/get.dart';
import '../models/food_log.dart';
import '../models/food_detail.dart';
import '../services/hive_service.dart';
import '../services/session_service.dart';
import '../services/notification_service.dart';

class FoodLogController extends GetxController {
  final _hive = HiveService();
  final _session = SessionService();
  final _notif = NotificationService();

  final todayLogs = <FoodLog>[].obs;
  final totalCaloriesToday = 0.0.obs;
  final calorieTarget = 0.0.obs;

  // Guard biar notif ga spam setiap tambah makanan
  bool _notifiedAt90 = false;
  bool _notifiedAt100 = false;

  @override
  void onInit() {
    super.onInit();
    loadToday();
  }

  Future<void> loadToday() async {
    final email = await _session.getUserEmail();
    if (email == null) {
      todayLogs.clear();
      totalCaloriesToday.value = 0;
      calorieTarget.value = 0;
      return;
    }

    final logs = _hive.getLogsForDate(DateTime.now(), email);
    todayLogs.assignAll(logs);
    totalCaloriesToday.value = logs.fold(0.0, (sum, log) => sum + log.calories);

    final user = _hive.getUser(email);
    calorieTarget.value = user?.dailyCalorieTarget ?? 0;

    // Reset guard notifikasi setiap load (misal beda hari)
    _notifiedAt90 = false;
    _notifiedAt100 = false;
  }

  /// Dipanggil dari Search Screen setelah user input gram
  Future<void> addFoodLog(FoodDetail detail, double grams) async {
    final email = await _session.getUserEmail();
    if (email == null) {
      Get.snackbar('Gagal', 'Session pengguna tidak ditemukan');
      return;
    }

    final log = FoodLog(
      fdcId: detail.fdcId,
      userEmail: email,
      foodName: detail.description,
      grams: grams,
      calories: detail.calories(grams),
      protein: detail.protein(grams),
      carbs: detail.carbs(grams),
      fat: detail.fat(grams),
      date: DateTime.now(),
    );

    await _hive.addFoodLog(log);
    await loadToday();
    await _checkAndNotify();
  }

  Future<void> deleteFoodLog(FoodLog log) async {
    await _hive.deleteFoodLog(log);
    await loadToday();
  }

  /// Ambil logs untuk tanggal tertentu (History Screen)
  Future<List<FoodLog>> getLogsForDate(DateTime date) async {
    final email = await _session.getUserEmail();
    if (email == null) return [];
    return _hive.getLogsForDate(date, email);
  }

  Future<List<DateTime>> getLogDates() async {
    final email = await _session.getUserEmail();
    if (email == null) return [];
    return _hive.getLogDates(email);
  }

  double get calorieProgress {
    if (calorieTarget.value == 0) return 0;
    return (totalCaloriesToday.value / calorieTarget.value).clamp(0.0, 1.0);
  }

  Future<void> _checkAndNotify() async {
    if (calorieTarget.value == 0) return;
    final ratio = totalCaloriesToday.value / calorieTarget.value;

    if (ratio >= 1.0 && !_notifiedAt100) {
      _notifiedAt100 = true;
      await _notif.showNotification(
        title: 'Target kalori terlampaui!',
        body:
            'Kamu sudah mengonsumsi ${totalCaloriesToday.value.toStringAsFixed(0)} kcal hari ini.',
      );
    } else if (ratio >= 0.9 && !_notifiedAt90) {
      _notifiedAt90 = true;
      await _notif.showNotification(
        title: 'Hampir mencapai target kalori!',
        body:
            'Sisa ${(calorieTarget.value - totalCaloriesToday.value).toStringAsFixed(0)} kcal lagi.',
      );
    }
  }
}
