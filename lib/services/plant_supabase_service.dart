import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plant.dart';

class PlantSupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // READ: Mengambil data dari tabel Supabase
  Future<List<Plant>> getSavedPlants() async {
    final response = await _supabase.from('saved_plants').select();

    return (response as List).map((item) => Plant.fromJson(item)).toList();
  }

  // CREATE: Menambah data ke tabel Supabase
  Future<void> addSavedPlant(Plant plant) async {
    await _supabase.from('saved_plants').insert(plant.toJson());
  }
}