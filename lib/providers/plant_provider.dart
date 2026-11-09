import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantProvider with ChangeNotifier {
  // Menyimpan daftar tanaman
  List<Plant> _plants = [];

  // Status state
  bool _isLoading = false;
  String _errorMessage = '';

  List<Plant> get plants => _plants;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fungsi simulasi memuat data (nantinya dihubungkan ke API / Supabase)
  Future<void> fetchPlants() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulasi delay jaringan
      await Future.delayed(const Duration(seconds: 1));

      // Data dummy sementara sesuai tema tanaman Anda
      _plants = [
        Plant(
          id: '1',
          name: 'Anggrek',
          category: 'outdoor',
          imageUrl: '',
          wateringSchedule: 'Hari Ini',
          light: 'Terang',
          temperature: '18-25°C',
          humidity: '60-70%',
        ),
        Plant(
          id: '2',
          name: 'Monstera',
          category: 'indoor',
          imageUrl: '',
          wateringSchedule: 'Setiap 3 Hari',
          light: 'Sedang',
          temperature: '20-28°C',
          humidity: '70-80%',
        ),
      ];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Fungsi menambah data tanaman (untuk CRUD Create)
  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
  }
}