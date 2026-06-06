import 'package:get/get.dart';
import '../controllers/food_controller.dart';
import '../controllers/food_log_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodController>(() => FoodController());
    // FoodLogController dibutuhkan oleh FoodController saat add log
    if (!Get.isRegistered<FoodLogController>()) {
      Get.lazyPut<FoodLogController>(() => FoodLogController());
    }
  }
}
