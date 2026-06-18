// ini ambil data dari API /food/search (datanya nutrisi blm lengkap)
class Food {
  final int fdcId;
  final String description;
  final String dataType;
  final double? caloriesPer100g;

  Food({
    required this.fdcId,
    required this.description,
    required this.dataType,
    this.caloriesPer100g,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    double? calories;

    final nutrients = json['foodNutrients'] as List<dynamic>?;
    if (nutrients != null) {
      final energyEntry = nutrients.firstWhere(
        (n) =>
            n['nutrientNumber'] == '208' ||
            n['nutrientName']?.toString().toLowerCase().contains('energy') ==
                true,
        orElse: () => null,
      );
      if (energyEntry != null) {
        calories = (energyEntry['value'] as num?)?.toDouble();
      }
    }

    return Food(
      fdcId: json['fdcId'] as int,
      description: json['description'] as String? ?? '',
      dataType: json['dataType'] as String? ?? '',
      caloriesPer100g: calories,
    );
  }
}
