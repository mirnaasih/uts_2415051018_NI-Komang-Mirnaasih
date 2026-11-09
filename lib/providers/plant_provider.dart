import 'package:flutter/foundation.dart';
import '../models/plant.dart';
import '../repositories/plant_repository.dart';

class PlantProvider with ChangeNotifier {
  final PlantRepository _repository = PlantRepository();
  List<Plant> _plants = [];
  bool _isLoading = false;

  List<Plant> get plants => _plants;
  bool get isLoading => _isLoading;

  Future<void> fetchPlants() async {
    _isLoading = true;
    notifyListeners();

    try {
      _plants = await _repository.getPlants();
    } catch (e) {
      debugPrint("Error fetching plants: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNewPlant(Map<String, dynamic> data) async {
    await _repository.addPlant(data);
    await fetchPlants();
  }

  Future<void> editPlant(int id, Map<String, dynamic> data) async {
    await _repository.updatePlant(id, data);
    await fetchPlants();
  }

  Future<void> removePlant(int id) async {
    await _repository.deletePlant(id);
    await fetchPlants();
  }
}