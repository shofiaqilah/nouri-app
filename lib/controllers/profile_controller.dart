import 'package:get/get.dart';
import '../models/user.dart';
import '../services/hive_service.dart';
import '../services/session_service.dart';

class ProfileController extends GetxController {
  final _hive = HiveService();
  final _session = SessionService();

  final user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final email = await _session.getUserEmail();
    if (email != null) {
      user.value = _hive.getUser(email);
    }
  }

  Future<void> saveOnboarding({
    required String name,
    required int age,
    required String gender,
    required double weight,
    required double height,
    required double dailyCalorieTarget,
  }) async {
    if (user.value == null) return;

    user.value!
      ..name = name
      ..age = age
      ..gender = gender
      ..weight = weight
      ..height = height
      ..dailyCalorieTarget = dailyCalorieTarget;

    await _hive.updateUser(user.value!);

    Get.offAllNamed('/home');
  }

  Future<void> updateCalorieTarget(double target) async {
    if (user.value == null) return;

    user.value!.dailyCalorieTarget = target;
    await _hive.updateUser(user.value!);
    user.refresh();

    Get.snackbar('Berhasil', 'Target kalori diperbarui');
  }

  double get bmi => user.value?.bmi ?? 0;
  String get bmiCategory => user.value?.bmiCategory ?? '-';
}
