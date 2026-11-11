import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant.dart';

class PlantApiService {
  
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts'; 

  Future<List<Plant>> fetchPlantsFromApi() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);

        // Mapping JSON ke Model Plant
        List<Plant> plants = body.take(5).map((item) {
          return Plant(
            id: item['id'].toString(),
            name: item['title'].toString().split(' ').take(2).join(' '),
            category: 'Outdoor API',
            imageUrl: '',
            wateringSchedule: 'Setiap 2 Hari',
            light: 'Terang',
            temperature: '20-25°C',
            humidity: '65%',
          );
        }).toList();

        return plants;
      } else {
        throw Exception('Gagal memuat data dari API (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}