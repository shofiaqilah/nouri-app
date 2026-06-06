import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';
import '../models/food_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static const _baseUrl = 'https://api.nal.usda.gov/fdc/v1';

  String get _apiKey {
    final key = dotenv.env['USDA_API_KEY'];
    if (key == null || key.isEmpty) throw Exception('USDA_API_KEY not found in .env');
    return key;
  }

  /// Cari makanan berdasarkan keyword
  Future<List<Food>> searchFood(String query) async {
    final uri = Uri.parse(
      '$_baseUrl/foods/search?query=${Uri.encodeComponent(query)}&api_key=${_apiKey}',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data pencarian: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final foods = json['foods'] as List<dynamic>? ?? [];

    return foods
        .map((item) => Food.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<FoodDetail> getFoodDetail(int fdcId) async {
    final uri = Uri.parse('$_baseUrl/food/$fdcId?api_key=${_apiKey}');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil detail makanan: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return FoodDetail.fromJson(json);
  }
}
