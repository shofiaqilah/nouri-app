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

  @override
  void onInit() {
    super.onInit();
    loadToday();
  }

  Future<void> loadToday() async {
    final logs = _hive.getLogsForDate(DateTime.now());
    todayLogs.assignAll(logs);
    totalCaloriesToday.value = logs.fold(0.0, (sum, log) => sum + log.calories);

    final email = await _session.getUserEmail();
    if (email != null) {
      final user = _hive.getUser(email);
      calorieTarget.value = user?.dailyCalorieTarget ?? 0;
    }
  }

  /// Dipanggil dari Search Screen setelah user input gram
  Future<void> addFoodLog(FoodDetail detail, double grams) async {
    final log = FoodLog(
      fdcId: detail.fdcId,
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
  List<FoodLog> getLogsForDate(DateTime date) {
    return _hive.getLogsForDate(date);
  }

  List<DateTime> get logDates => _hive.getLogDates();

  double get calorieProgress {
    if (calorieTarget.value == 0) return 0;
    return (totalCaloriesToday.value / calorieTarget.value).clamp(0.0, 1.0);
  }

  Future<void> _checkAndNotify() async {
    if (calorieTarget.value == 0) return;
    final ratio = totalCaloriesToday.value / calorieTarget.value;

    if (ratio >= 1.0) {
      await _notif.showNotification(
        title: 'Target kalori terlampaui!',
        body:
            'Kamu sudah mengonsumsi ${totalCaloriesToday.value.toStringAsFixed(0)} kcal hari ini.',
      );
    } else if (ratio >= 0.9) {
      await _notif.showNotification(
        title: 'Hampir mencapai target kalori!',
        body:
            'Sisa ${(calorieTarget.value - totalCaloriesToday.value).toStringAsFixed(0)} kcal lagi.',
      );
    }
  }
}
