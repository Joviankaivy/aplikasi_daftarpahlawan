import 'dart:convert';
import 'package:http/http.dart' as http;

class HeroService {
  static const String url = 'https://indonesia-public-static-api.vercel.app/api/heroes';

  static Future<List<dynamic>> fetchHeroes() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load heroes');
    }
  }
}
