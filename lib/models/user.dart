// simpan data dari pengguna ke Hive Box (age, weight, height, gender, inputan kalori)
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  int age;

  @HiveField(4)
  String gender; // 'male' | 'female'

  @HiveField(5)
  double weight; // kg

  @HiveField(6)
  double height; // cm

  @HiveField(7)
  double dailyCalorieTarget;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.dailyCalorieTarget,
  });

  /// hitung BMI
  double get bmi {
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  String get bmiCategory {
    final b = bmi;
    if (b < 18.5) return 'Underweight';
    if (b < 25.0) return 'Normal';
    if (b < 30.0) return 'Overweight';
    return 'Obese';
  }
}
