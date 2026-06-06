import 'package:get/get.dart';
import '../models/user.dart';
import '../services/hive_service.dart';
import '../services/session_service.dart';

class AuthController extends GetxController {
  final _hive = HiveService();
  final _session = SessionService();

  final isLoading = false.obs;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    if (_hive.userExists(email)) {
      Get.snackbar('Gagal', 'Email sudah terdaftar');
      return;
    }

    // Simpan user baru dengan data minimal dulu,
    // sisanya diisi saat onboarding
    final user = User(
      email: email,
      password: password,
      name: '',
      age: 0,
      gender: '',
      weight: 0,
      height: 0,
      dailyCalorieTarget: 0,
    );

    await _hive.saveUser(user);
    await _session.saveSession(email);

    Get.offAllNamed('/onboarding');
  }

  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;

    final user = _hive.getUser(email);

    if (user == null || user.password != password) {
      Get.snackbar('Gagal', 'Email atau password salah');
      isLoading.value = false;
      return;
    }

    await _session.saveSession(email);
    isLoading.value = false;

    Get.offAllNamed('/home');
  }

  Future<void> logout() async {
    await _session.clearSession();
    Get.offAllNamed('/login');
  }
}
