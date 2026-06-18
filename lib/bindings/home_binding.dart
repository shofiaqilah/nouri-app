import 'package:get/get.dart';
import '../controllers/food_log_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FoodLogController>(FoodLogController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController());
    }
  }
}
