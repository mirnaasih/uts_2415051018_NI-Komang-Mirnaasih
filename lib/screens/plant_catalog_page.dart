import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plant.dart';
import 'plant_detail_page.dart';
import '../widgets/error_view.dart';

class PlantCatalogPage extends StatefulWidget {
  const PlantCatalogPage({super.key});

  @override
  State<PlantCatalogPage> createState() => _PlantCatalogPageState();
}

class _PlantCatalogPageState extends State<PlantCatalogPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Plant> _plants = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSavedPlants();
  }

  // Fungsi mengambil data dari tabel saved_plants Supabase
  Future<void> _fetchSavedPlants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _supabase.from('saved_plants').select();
      
      final loadedPlants = (response as List).map((item) => Plant.fromJson(item)).toList();

      if (!mounted) return;
      setState(() {
        _plants = loadedPlants;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Katalog Tanaman', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _fetchSavedPlants,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : _errorMessage != null
              ? ErrorView(
                  message: _errorMessage!,
                  onRetry: _fetchSavedPlants,
                )
              : _plants.isEmpty
                  ? const Center(child: Text("Belum ada tanaman tersimpan di database."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _plants.length,
                      itemBuilder: (context, index) {
                        final plant = _plants[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: plant.imageUrl.isNotEmpty
                                    ? Image.network(
                                        plant.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.eco, color: Color(0xFF2E7D32)),
                                      )
                                    : const Icon(Icons.eco, color: Color(0xFF2E7D32)),
                              ),
                            ),
                            title: Text(
                              plant.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              "${plant.category} • ${plant.wateringSchedule}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlantDetailPage(plant: plant),
                                ),
                              );
                              if (result == true) {
                                _fetchSavedPlants();
                              }
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}