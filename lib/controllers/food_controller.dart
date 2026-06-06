import 'package:get/get.dart';
import '../models/food.dart';
import '../models/food_detail.dart';
import '../services/api_service.dart';
import '../views/widgets/gram_input_sheet.dart';
import 'food_log_controller.dart';

class FoodController extends GetxController {
  final _api = ApiService();

  final foodResults = <Food>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await _api.searchFood(query);
      foodResults.assignAll(results);

      if (results.isEmpty) {
        errorMessage.value = 'Makanan tidak ditemukan';
      }
    } catch (e) {
      errorMessage.value = 'Gagal mengambil data. Cek koneksi internet.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Dipanggil saat user tap salah satu item di list
  /// Fetch detail → tampil bottom sheet input gram
  Future<void> onFoodTapped(Food item) async {
    isLoading.value = true;

    try {
      final detail = await _api.getFoodDetail(item.fdcId);
      isLoading.value = false;
      _showGramInput(detail);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Gagal', 'Tidak dapat memuat detail makanan');
    }
  }

  void _showGramInput(FoodDetail detail) {
    // Bottom sheet ini dipanggil dari controller supaya view tetap bersih.
    // GramInputSheet adalah widget stateful yang menerima callback onConfirm.
    Get.bottomSheet(
      GramInputSheet(
        foodName: detail.description,
        caloriesPer100g: detail.caloriesPer100g,
        onConfirm: (grams) async {
          final foodlogController = Get.find<FoodLogController>();
          await foodlogController.addFoodLog(detail, grams);
          Get.back(); // tutup bottom sheet
          Get.offNamed('/home');
        },
      ),
      isScrollControlled: true,
    );
  }
}
