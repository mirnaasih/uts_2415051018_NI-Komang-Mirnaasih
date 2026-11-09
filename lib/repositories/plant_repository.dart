import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plant.dart';

class PlantRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil data dari tabel saved_plants
  Future<List<Plant>> getPlants() async {
    final response = await _supabase.from('saved_plants').select();
    return (response as List).map((item) => Plant.fromJson(item)).toList();
  }

  // Menambah data baru
  Future<void> addPlant(Map<String, dynamic> plantData) async {
    await _supabase.from('saved_plants').insert(plantData);
  }

  // Update data
  Future<void> updatePlant(dynamic id, Map<String, dynamic> plantData) async {
    await _supabase.from('saved_plants').update(plantData).eq('id', id);
  }

  // Hapus data
  Future<void> deletePlant(dynamic id) async {
    await _supabase.from('saved_plants').delete().eq('id', id);
  }
}