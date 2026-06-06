import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/food_log.dart';

class HiveService {
  static const _userBox = 'userBox';
  static const _foodLogBox = 'foodLogBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(FoodLogAdapter());
    await Hive.openBox<User>(_userBox);
    await Hive.openBox<FoodLog>(_foodLogBox);
  }

  // BOX USER
  Box<User> get _users => Hive.box<User>(_userBox);

  Future<void> saveUser(User user) async {
    await _users.put(user.email, user);
  }

  User? getUser(String email) {
    return _users.get(email);
  }

  // Cek apakah email sudah terdaftar
  bool userExists(String email) {
    return _users.containsKey(email);
  }

  /// Update data profil (berat, tinggi, target kalori, dll)
  Future<void> updateUser(User user) async {
    await user.save();
  }

  // BOX FOOD LOG
  Box<FoodLog> get _foodLogs => Hive.box<FoodLog>(_foodLogBox);

  /// Tambah entri makanan baru
  Future<void> addFoodLog(FoodLog log) async {
    await _foodLogs.add(log);
  }

  /// Ambil semua log untuk tanggal tertentu
  List<FoodLog> getLogsForDate(DateTime date) {
    return _foodLogs.values.where((log) {
      return log.date.year == date.year &&
          log.date.month == date.month &&
          log.date.day == date.day;
    }).toList();
  }

  /// Ambil semua tanggal yang punya log (untuk History Screen)
  List<DateTime> getLogDates() {
    final dates = _foodLogs.values
        .map((log) {
          return DateTime(log.date.year, log.date.month, log.date.day);
        })
        .toSet()
        .toList();
    dates.sort((a, b) => b.compareTo(a)); // terbaru di atas
    return dates;
  }

  /// Hapus satu entri log
  Future<void> deleteFoodLog(FoodLog log) async {
    await log.delete();
  }

  /// Hitung total kalori untuk tanggal tertentu
  double getTotalCaloriesForDate(DateTime date) {
    return getLogsForDate(date).fold(0.0, (sum, log) => sum + log.calories);
  }
}
