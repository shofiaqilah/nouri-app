// ini disimpen ke Hive (makanan yang dipilih user)

import 'package:hive/hive.dart';
part 'food_log.g.dart';


@HiveType(typeId: 1)
class FoodLog extends HiveObject {
  @HiveField(0)
  int fdcId;

  @HiveField(1)
  String foodName;

  @HiveField(2)
  double grams;

  @HiveField(3)
  double calories;

  @HiveField(4)
  double protein;

  @HiveField(5)
  double carbs;

  @HiveField(6)
  double fat;

  @HiveField(7)
  DateTime date;

  FoodLog({
    required this.fdcId,
    required this.foodName,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.date,
  });
}
