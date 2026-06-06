// data makanan yg lebih detail dari API
class FoodDetail {
  final int fdcId;
  final String description;
  final String dataType;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;

  FoodDetail({
    required this.fdcId,
    required this.description,
    required this.dataType,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
  });

  factory FoodDetail.fromJson(Map<String, dynamic> json) {
    final nutrients = json['foodNutrients'] as List<dynamic>? ?? [];

    double parseNutrient(List<String> names, List<String> numbers) {
      final entry = nutrients.firstWhere((n) {
        final name = (n['nutrient']?['name'] as String? ?? '').toLowerCase();
        final number = n['nutrient']?['number']?.toString() ?? '';
        return numbers.contains(number) ||
            names.any((keyword) => name.contains(keyword));
      }, orElse: () => null);
      return (entry?['amount'] as num?)?.toDouble() ?? 0.0;
    }

    return FoodDetail(
      fdcId: json['fdcId'] as int,
      description: json['description'] as String? ?? '',
      dataType: json['dataType'] as String? ?? '',
      caloriesPer100g: parseNutrient(['energy'], ['208']),
      proteinPer100g: parseNutrient(['protein'], ['203']),
      carbsPer100g: parseNutrient(['carbohydrate'], ['205']),
      fatPer100g: parseNutrient(['total lipid', 'fat'], ['204']),
    );
  }

  /// Hitung nilai nutrisi aktual berdasarkan input gram user
  double calories(double grams) => (caloriesPer100g / 100) * grams;
  double protein(double grams) => (proteinPer100g / 100) * grams;
  double carbs(double grams) => (carbsPer100g / 100) * grams;
  double fat(double grams) => (fatPer100g / 100) * grams;
}
