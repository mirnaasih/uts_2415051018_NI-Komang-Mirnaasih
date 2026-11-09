import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/plant_api_service.dart';

class PlantProvider with ChangeNotifier {
  final PlantApiService _apiService = PlantApiService();

  List<Plant> _plants = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Plant> get plants => _plants;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fungsi mengambil data dari REST API
  Future<void> fetchPlants() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _plants = await _apiService.fetchPlantsFromApi();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
  }
}