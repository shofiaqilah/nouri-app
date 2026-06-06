import 'package:get/get.dart';
import '../controllers/food_log_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FoodLogController>(FoodLogController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    // AuthController sudah di-put oleh AuthBinding, pastikan tersedia
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController());
    }
  }
}
